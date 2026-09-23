/// Profile's backup rows: seal the plan with a password and hand it to the
/// phone's share sheet, or pick a backup and put it back.
library;

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/backup.dart';
import '../design/parts.dart';
import '../design/tokens.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class BackupSection extends StatelessWidget {
  const BackupSection({required this.state, super.key});

  final AppState state;

  Future<void> _save(BuildContext context) async {
    final password = await PasswordDialog.show(context, confirm: true);
    if (password == null || !context.mounted) return;

    final sealed = await _busy(
      context,
      sealBackup(state.toDocument(), password),
    );
    if (sealed == null) return;

    final today = state.today;
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/upino-backup-$today.$backupExtension');
    await file.writeAsString(sealed, flush: true);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<void> _restore(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final picked = await FilePicker.pickFile();
    if (picked == null || !context.mounted) return;

    final String text;
    try {
      text = utf8.decode(await picked.readAsBytes());
    } on Object {
      if (context.mounted) _tell(context, l.backupNotABackup);
      return;
    }
    if (!context.mounted) return;

    final password = await PasswordDialog.show(context, confirm: false);
    if (password == null || !context.mounted) return;

    try {
      final document = await _busy(context, openBackup(text, password));
      if (document == null || !context.mounted) return;
      final replace = await _confirmReplace(context);
      if (!replace || !context.mounted) return;
      state.replaceWith(document);
      _tell(context, l.backupRestored);
    } on BackupFailure catch (failure) {
      if (!context.mounted) return;
      final message = switch (failure.kind) {
        BackupFailureKind.notABackup => l.backupNotABackup,
        BackupFailureKind.wrongPassword => l.backupWrongPassword,
        BackupFailureKind.unreadablePlan => l.backupUnreadable,
      };
      _tell(context, message);
    }
  }

  /// Key stretching takes a moment on purpose, so the wait is shown rather
  /// than looking like a frozen screen.
  Future<T?> _busy<T>(BuildContext context, Future<T> work) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      return await work;
    } finally {
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmReplace(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor(dialogContext),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
        ),
        title: Text(l.backupReplaceTitle),
        content: Text(l.backupReplaceBlurb),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            key: const Key('backup-replace'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.backupReplace),
          ),
        ],
      ),
    );
    return answer ?? false;
  }

  void _tell(BuildContext context, String message) =>
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(l.backupSection),
        ActionRow(
          key: const Key('profile-backup-save'),
          title: l.backupSave,
          subtitle: l.backupSaveSub,
          trailing: const RowAffordance(icon: 'chevronRight'),
          onTap: () => _save(context),
        ),
        const SizedBox(height: 10),
        ActionRow(
          key: const Key('profile-backup-restore'),
          title: l.backupRestore,
          subtitle: l.backupRestoreSub,
          trailing: const RowAffordance(icon: 'chevronRight'),
          onTap: () => _restore(context),
        ),
      ],
    );
  }
}

/// Asks for a password. When saving, it is typed twice, because a typo here
/// locks the person out of their own backup for good.
class PasswordDialog extends StatefulWidget {
  const PasswordDialog({required this.confirm, super.key});

  final bool confirm;

  static Future<String?> show(BuildContext context, {required bool confirm}) =>
      showDialog<String>(
        context: context,
        builder: (_) => PasswordDialog(confirm: confirm),
      );

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final _first = TextEditingController();
  final _second = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  void _submit() {
    final l = AppLocalizations.of(context);
    final password = _first.text;
    if (widget.confirm && password.length < 6) {
      setState(() => _error = l.backupPasswordShort);
      return;
    }
    if (widget.confirm && password != _second.text) {
      setState(() => _error = l.backupPasswordMismatch);
      return;
    }
    if (password.isEmpty) return;
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: cardColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
      ),
      title: Text(widget.confirm ? l.backupSave : l.backupRestore),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.confirm
                ? l.backupPasswordSaveBlurb
                : l.backupPasswordOpenBlurb,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('backup-password'),
            controller: _first,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(labelText: l.backupPassword),
            onSubmitted: (_) => widget.confirm ? null : _submit(),
          ),
          if (widget.confirm)
            TextField(
              key: const Key('backup-password-repeat'),
              controller: _second,
              obscureText: true,
              decoration: InputDecoration(labelText: l.backupPasswordRepeat),
              onSubmitted: (_) => _submit(),
            ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              key: const Key('backup-password-error'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark(context)
                    ? UpinoTokens.darkCritical
                    : UpinoTokens.critical,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        TextButton(
          key: const Key('backup-password-ok'),
          onPressed: _submit,
          child: Text(widget.confirm ? l.save : l.backupOpen),
        ),
      ],
    );
  }
}
