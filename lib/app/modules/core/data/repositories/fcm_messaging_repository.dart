import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/core/data/data_sources/fcm_api.dart';
import 'package:pot_g/app/modules/core/data/models/fcm_request_model.dart';
import 'package:pot_g/app/modules/core/domain/repositories/app_version_repository.dart';
import 'package:pot_g/app/modules/core/domain/repositories/link_repository.dart';
import 'package:pot_g/app/modules/core/domain/repositories/messaging_repository.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:package_info_plus/package_info_plus.dart';

// TODO: https://firebase.google.com/docs/cloud-messaging/flutter/receive?hl=en#apple_platforms_and_android

@singleton
class FcmMessagingRepository implements MessagingRepository, LinkRepository {
  final _tokenSubject = BehaviorSubject<String?>.seeded(null);
  final _linkSubject = BehaviorSubject<String?>();
  final FcmApi _api;
  static final _androidNotificationChannel = AndroidNotificationChannel(
    'potg_notification_channel',
    'potg',
    importance: Importance.max,
  );
  final AppVersionRepository _appVersionRepository;
  final AuthRepository _authRepository;

  FcmMessagingRepository(
    this._api,
    this._appVersionRepository,
    this._authRepository,
  );

  @override
  Future<void> init() async {
    final instance = FirebaseMessaging.instance;
    await instance.requestPermission(announcement: true, provisional: true);
    await _waitForIosToken();

    FirebaseMessaging.instance
        .getToken()
        .then(_tokenSubject.add)
        .catchError((_) {});
    FirebaseMessaging.instance.onTokenRefresh.listen(_tokenSubject.add);
    await refresh();
    _tokenSubject.listen(refresh);

    await _setupForeground();
    _initRemoteMessage();
  }

  Future<void> _waitForIosToken() async {
    if (!Platform.isIOS) return;
    for (var i = 0; i < 10; i++) {
      final token = await FirebaseMessaging.instance.getAPNSToken();
      if (token != null) return;
      await Future.delayed(const Duration(seconds: 1));
    }
    throw PlatformException(
      code: 'no_ios_token',
      message: 'Failed to get APNS token',
    );
  }

  Future<void> _setupForeground() async {
    final instance = FirebaseMessaging.instance;
    await instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    final localNotificationPlugin = FlutterLocalNotificationsPlugin();
    await localNotificationPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _handleForegroundMessage,
    );
    localNotificationPlugin.getNotificationAppLaunchDetails().then((value) {
      if (value == null || !value.didNotificationLaunchApp) return;
      final response = value.notificationResponse;
      if (response == null) return;
      _handleForegroundMessage(response);
    });
    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidNotificationChannel);
    FirebaseMessaging.onMessage.listen(_androidMessageListener);
  }

  void _handleRemoteMessage(RemoteMessage? rm) {
    final path = rm?.data['path'];
    if (path == null || path is! String || path.isEmpty) return;
    _linkSubject.add(path);
  }

  void _handleForegroundMessage(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    final json = jsonDecode(payload);
    final path = json['path'];
    if (path == null || path is! String || path.isEmpty) return;
    _linkSubject.add(path);
  }

  Future<void> _androidMessageListener(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    final android = message.notification?.android;
    if (android == null) return;
    final imageUrl = android.imageUrl;
    final image = imageUrl != null && imageUrl.isNotEmpty
        ? BigPictureStyleInformation(
            ByteArrayAndroidBitmap(
              await NetworkAssetBundle(
                Uri.parse(imageUrl),
              ).load(imageUrl).then((value) => value.buffer.asUint8List()),
            ),
          )
        : null;
    FlutterLocalNotificationsPlugin().show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidNotificationChannel.id,
          _androidNotificationChannel.name,
          styleInformation: image,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _initRemoteMessage() {
    FirebaseMessaging.instance.getInitialMessage().then(_handleRemoteMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessage);
  }

  @override
  Future<void> refresh([String? token]) async {
    final signedIn = await _authRepository.isSignedIn.first;
    if (!signedIn) return;
    final fcmToken = token ?? _tokenSubject.value;
    if (fcmToken == null) return;

    final request = FcmRequestModel(
      fcmToken: fcmToken,
      os: await _appVersionRepository.getPlatform(),
      version: (await _appVersionRepository.getCurrentVersion()).toString(),
    );

    await _api.fcm(request);
  }

  @override
  Stream<String> getLinkStream() => _linkSubject.stream.whereType();
}
