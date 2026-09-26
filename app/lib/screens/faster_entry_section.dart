/// Profile's switches for the things that save typing: reading bank
/// messages, the evening reminder and the home-screen widget.
///
/// Each asks for its permission only when it is switched on, and says in
/// plain words what it does with it.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show appFlavor;

import '../design/parts.dart';
import '../device/device_bridge.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

/// Whether this build may read the SMS inbox. Only the Play build declares
/// READ_SMS (see android/app/build.gradle.kts); in the direct APK the switch
/// would ask for a permission the app does not have.
bool get smsInboxAvailable => appFlavor == 'play';

class FasterEntrySection extends StatelessWidget {
  const FasterEntrySection({required this.state, super.key});

  final AppState state;

  Future<void> _toggleSms(BuildContext context, bool on) async {
    final bridge = DeviceBridge.instance;
    if (!on) {
      state.setSmsEnabled(false);
      return;
    }
    if (bridge == null || !await bridge.requestSms()) {
      if (context.mounted) _tell(context, AppLocalizations.of(context).smsDenied);
      return;
    }
    state.setSmsEnabled(true);
    await bridge.readInbox();
  }

  Future<void> _toggleReminder(BuildContext context, bool on) async {
    final bridge = DeviceBridge.instance;
    if (!on) {
      state.setReminderEnabled(false);
      return;
    }
    if (bridge == null || !await bridge.requestNotifications()) {
      if (context.mounted) {
        _tell(context, AppLocalizations.of(context).reminderDenied);
      }
      return;
    }
    state.setReminderEnabled(true);
  }

  void _tell(BuildContext context, String message) =>
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bridge = DeviceBridge.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(l.fasterTitle),
        if (smsInboxAvailable) ...[
          _SwitchCard(
            key: const Key('profile-sms'),
            title: l.smsTitle,
            detail: l.smsDetail,
            value: state.smsEnabled,
            onChanged: (on) => unawaited(_toggleSms(context, on)),
          ),
          const SizedBox(height: 10),
        ],
        _SwitchCard(
          key: const Key('profile-reminder'),
          title: l.reminderTitleSetting,
          detail: l.reminderDetail,
          value: state.reminderEnabled,
          onChanged: (on) => unawaited(_toggleReminder(context, on)),
        ),
        if (bridge != null) ...[
          const SizedBox(height: 10),
          FutureBuilder<bool>(
            future: bridge.canPinWidget(),
            builder: (context, snap) => snap.data != true
                ? const SizedBox.shrink()
                : ActionRow(
                    key: const Key('profile-widget'),
                    title: l.widgetAdd,
                    subtitle: l.widgetAddSub,
                    trailing: const RowAffordance(icon: 'add'),
                    onTap: bridge.pinWidget,
                  ),
          ),
        ],
      ],
    );
  }
}

class _SwitchCard extends StatelessWidget {
  const _SwitchCard({
    required this.title,
    required this.detail,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UpinoCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(detail, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
