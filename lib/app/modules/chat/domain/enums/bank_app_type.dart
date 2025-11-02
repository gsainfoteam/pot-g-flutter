enum BankAppType {
  toss(iOS: 'id839333328', android: 'viva.republica.toss');

  final String iOS;
  final String android;
  String get iOSStoreUrl => 'https://apps.apple.com/app/$iOS';
  String get androidStoreUrl =>
      'https://play.google.com/store/apps/details?id=$android';
  const BankAppType({required this.iOS, required this.android});
}
