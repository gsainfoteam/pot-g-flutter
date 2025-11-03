import 'package:pot_g/app/modules/chat/data/repositories/deep_link_repository.dart';

enum TaxiAppType implements AppType {
  kakaoT(iOS: 'id981110422', android: 'com.kakao.taxi'),
  uber(iOS: 'id368677368', android: 'com.ubercab'),
  tmoney(iOS: 'id1483433931', android: 'kr.co.tmoney.tia');

  @override
  final String iOS;
  @override
  final String android;
  const TaxiAppType({required this.iOS, required this.android});
}
