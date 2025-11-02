import 'package:pot_g/app/modules/chat/data/repositories/deep_link_repository.dart';

enum TaxiAppType implements AppType {
  kakaoT(iOS: 'id981110422', android: 'com.kakao.taxi'),
  uber(iOS: 'id368677368', android: 'com.ubercab');

  final String iOS;
  final String android;
  @override
  String get iOSStoreUrl => 'https://apps.apple.com/app/$iOS';
  @override
  String get androidStoreUrl =>
      'https://play.google.com/store/apps/details?id=$android';
  const TaxiAppType({required this.iOS, required this.android});
}
