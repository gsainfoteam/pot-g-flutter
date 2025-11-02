import 'package:pot_g/app/modules/chat/data/repositories/deep_link_repository.dart';

enum BankAppType implements AppType {
  toss(iOS: 'id839333328', android: 'viva.republica.toss');

  @override
  final String iOS;
  @override
  final String android;
  const BankAppType({required this.iOS, required this.android});
}
