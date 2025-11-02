enum TaxiAppType {
  kakaoT(iOS: 'id981110422', android: 'com.kakao.taxi'),
  uber(iOS: 'id1131342792', android: 'com.ubercab'),
  tMoney(iOS: 'id1483433931', android: 'kr.co.tmoney.tia');

  final String iOS;
  final String android;
  String get iOSStoreUrl => 'https://apps.apple.com/app/$iOS';
  String get androidStoreUrl =>
      'https://play.google.com/store/apps/details?id=$android';
  const TaxiAppType({required this.iOS, required this.android});
}
