import 'package:pot_g/app/modules/chat/data/repositories/deep_link_repository.dart';

enum BankAppType implements AppType {
  toss(iOS: 'id839333328', android: 'viva.republica.toss');

  final String iOS;
  final String android;
  @override
  String get iOSStoreUrl => 'https://apps.apple.com/app/$iOS';
  @override
  String get androidStoreUrl =>
      'https://play.google.com/store/apps/details?id=$android';
  const BankAppType({required this.iOS, required this.android});
}
