/// Where the app meets the phone: the home-screen widget, the evening
/// reminder and the bank messages in the inbox.
///
/// Everything here is Android-only and optional. Off Android, and in tests,
/// [DeviceBridge.instance] is null and the app behaves exactly as before.
/// The state layer never calls in here; this listens to it, so the plan's
/// arithmetic cannot depend on whether a widget exists.
library;

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_widget/home_widget.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../engine/clock.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class DeviceBridge {
  DeviceBridge._(this.state);

  /// Null wherever the phone's features are not available.
  static DeviceBridge? instance;

  static const _widgetProvider = 'com.upino.upino.UpinoWidgetProvider';
  static const _reminderId = 1;

  /// The evening reminder's hour, local time. Late enough that the day's
  /// spending is done, early enough that it is still remembered.
  static const reminderHour = 21;

  final AppState state;
  final _notifications = FlutterLocalNotificationsPlugin();
  final _sms = const MethodChannel('upino/sms');
  final _spendRequests = StreamController<void>.broadcast();

  String? _lastWidget;
  String? _lastReminder;
  bool _pendingSpend = false;

  /// Fires when the person asked to record a spend from outside the app:
  /// the widget's button or the reminder.
  Stream<void> get spendRequests => _spendRequests.stream;

  /// True once, if the app was opened to record a spend before anything was
  /// listening for [spendRequests].
  bool takePendingSpend() {
    final pending = _pendingSpend;
    _pendingSpend = false;
    return pending;
  }

  static Future<void> start(AppState state) async {
    if (kIsWeb || !Platform.isAndroid) return;
    final bridge = DeviceBridge._(state);
    instance = bridge;
    try {
      await bridge._init();
    } on Object catch (error) {
      // A broken plugin must never take the plan down with it.
      debugPrint('Device features unavailable: $error');
    }
  }

  Future<void> _init() async {
    tzdata.initializeTimeZones();
    await _notifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (_) => _requestSpend(),
    );
    final launch = await _notifications.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) _pendingSpend = true;

    final launchedWith = await HomeWidget.initiallyLaunchedFromHomeWidget();
    if (_isSpend(launchedWith)) _pendingSpend = true;
    HomeWidget.widgetClicked.listen((uri) {
      if (_isSpend(uri)) _requestSpend();
    });

    state.addListener(_sync);
    _sync();
    await readInbox();
  }

  static bool _isSpend(Uri? uri) => uri?.host == 'spend';

  void _requestSpend() {
    if (_spendRequests.hasListener) {
      _spendRequests.add(null);
    } else {
      _pendingSpend = true;
    }
  }

  void _sync() {
    unawaited(_updateWidget());
    unawaited(_scheduleReminder());
  }

  AppLocalizations get _l {
    final code =
        state.languageCode ?? PlatformDispatcher.instance.locale.languageCode;
    try {
      return lookupAppLocalizations(Locale(code));
    } on FlutterError {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  // --- widget ---------------------------------------------------------------

  /// The figure is written already formatted, so the widget does no
  /// arithmetic of its own and cannot disagree with the app.
  Future<void> _updateWidget() async {
    if (!state.isRestored) return;
    final l = _l;
    final String amount;
    final String note;
    if (!state.isOnboarded) {
      amount = '—';
      note = '';
    } else {
      final snapshot = state.snapshot;
      amount = snapshot.safeToSpendNow.display();
      note = snapshot.mandatoryFundingGap.minor > 0
          ? l.heroShort(snapshot.mandatoryFundingGap.display())
          : '';
    }
    final label = l.heroSafeToSpend;
    final spend = l.widgetSpend;
    final key = '$label|$amount|$note|$spend';
    if (key == _lastWidget) return;
    _lastWidget = key;
    try {
      await HomeWidget.saveWidgetData<String>('label', label);
      await HomeWidget.saveWidgetData<String>('amount', amount);
      await HomeWidget.saveWidgetData<String>('note', note);
      await HomeWidget.saveWidgetData<String>('spend', spend);
      await HomeWidget.updateWidget(qualifiedAndroidName: _widgetProvider);
    } on Object catch (error) {
      debugPrint('Widget not updated: $error');
    }
  }

  Future<bool> canPinWidget() async {
    try {
      return await HomeWidget.isRequestPinWidgetSupported() ?? false;
    } on Object {
      return false;
    }
  }

  Future<void> pinWidget() async {
    try {
      await HomeWidget.requestPinWidget(qualifiedAndroidName: _widgetProvider);
    } on Object catch (error) {
      debugPrint('Widget not pinned: $error');
    }
  }

  // --- reminder -------------------------------------------------------------

  /// The next evening to remind on: today, unless a spend is already
  /// recorded today or the hour has passed.
  static LocalDate nextReminderDay({
    required LocalDate today,
    required DateTime localNow,
    required bool spentToday,
  }) {
    final passed = localNow.hour >= reminderHour;
    return spentToday || passed ? today.addDays(1) : today;
  }

  Future<void> _scheduleReminder() async {
    if (!state.isRestored) return;
    final enabled = state.reminderEnabled && state.isOnboarded;
    final offset = DateTime.now().timeZoneOffset;
    final localNow = DateTime.now().toUtc().add(offset);
    final day = enabled
        ? nextReminderDay(
            today: LocalDate.at(DateTime.now().toUtc(), offset),
            localNow: localNow,
            spentToday: state.spentToday,
          )
        : null;
    final key = '$enabled|$day|${state.languageCode}';
    if (key == _lastReminder) return;
    _lastReminder = key;
    try {
      await _notifications.cancel(id: _reminderId);
      if (day == null) return;
      // 21:00 on that day in the phone's current offset, as an instant. It
      // then repeats at that time daily; opening the app moves it again.
      final at = DateTime.utc(day.year, day.month, day.day, reminderHour)
          .subtract(offset);
      final l = _l;
      await _notifications.zonedSchedule(
        id: _reminderId,
        title: l.reminderTitle,
        body: l.reminderBody,
        scheduledDate: tz.TZDateTime.from(at, tz.UTC),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'evening-reminder',
            l.reminderChannel,
            importance: Importance.defaultImportance,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'spend',
      );
    } on Object catch (error) {
      debugPrint('Reminder not scheduled: $error');
    }
  }

  Future<bool> requestNotifications() async {
    try {
      final android = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      // Null below Android 13, where no runtime permission exists.
      return await android?.requestNotificationsPermission() ?? true;
    } on Object {
      return false;
    }
  }

  // --- bank messages ----------------------------------------------------------

  Future<bool> requestSms() async {
    try {
      return await _sms.invokeMethod<bool>('requestPermission') ?? false;
    } on Object {
      return false;
    }
  }

  /// Reads messages that arrived since the feature was turned on and hands
  /// them to the state, which keeps only what describes a spend.
  Future<void> readInbox() async {
    final since = state.smsSince;
    if (since == null) return;
    try {
      final raw = await _sms.invokeListMethod<Map<Object?, Object?>>(
        'inbox',
        {'since': since.millisecondsSinceEpoch},
      );
      if (raw == null) return;
      state.offerBankMessages([
        for (final m in raw)
          InboxMessage(
            id: m['id']! as String,
            body: (m['body'] as String?) ?? '',
            sender: m['address'] as String?,
            receivedAt: DateTime.fromMillisecondsSinceEpoch(
              (m['date']! as num).toInt(),
              isUtc: true,
            ),
          ),
      ]);
    } on Object catch (error) {
      debugPrint('Inbox not read: $error');
    }
  }
}
