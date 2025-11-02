enum TaxiAppType {
  kakaoT(iOS: 'id981110422', android: 'com.kakao.taxi'),
  uber(iOS: 'id368677368', android: 'com.ubercab');

  final String iOS;
  final String android;
  String get iOSStoreUrl => 'https://apps.apple.com/app/$iOS';
  String get androidStoreUrl =>
      'https://play.google.com/store/apps/details?id=$android';
  const TaxiAppType({required this.iOS, required this.android});
}
