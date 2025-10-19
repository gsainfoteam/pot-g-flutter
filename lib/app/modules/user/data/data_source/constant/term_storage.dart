import 'package:pot_g/app/modules/user/domain/entities/term_entity.dart';
import 'package:pot_g/app/modules/user/domain/enums/term_type.dart';

abstract class TermStorage {
  static final terms = [
    TermEntity(
      slug: 'privacy-policy-v1',
      type: TermType.privacyPolicy,
      url:
          'https://infoteam-rulrudino.notion.site/1c5365ea27df800f8143f31218070a87',
      required: true,
    ),
    TermEntity(
      slug: 'terms-of-service-v1',
      type: TermType.termsOfService,
      url:
          'https://infoteam-rulrudino.notion.site/1c5365ea27df80aeac2cc6e1d8729a11',
      required: true,
    ),
  ];

  static Iterable<TermEntity> get requiredTerms =>
      terms.where((element) => element.required);

  static TermEntity getTermBySlug(String slug) =>
      terms.firstWhere((element) => element.slug == slug);
}

extension TermEntityListX on List<TermEntity> {
  Iterable<String> get _slugs => map((e) => e.slug);
  bool get allRequired =>
      TermStorage.requiredTerms.every((e) => _slugs.contains(e.slug));
}
