import 'package:collection/collection.dart';
import 'package:pot_g/app/modules/user/domain/entities/term_entity.dart';
import 'package:pot_g/app/modules/user/domain/enums/term_type.dart';

abstract class TermStorage {
  static final terms = [
    TermEntity(
      slug: 'privacy-policy-v1',
      type: TermType.privacyPolicy,
      url: 'https://terms.gistory.me/pot-g/privacy/251022/',
      required: true,
    ),
    TermEntity(
      slug: 'terms-of-service-v1',
      type: TermType.termsOfService,
      url: 'https://terms.gistory.me/pot-g/tos/251022/',
      required: true,
    ),
  ];

  static Iterable<TermEntity> get requiredTerms =>
      terms.where((element) => element.required);

  static TermEntity? getTermBySlug(String slug) =>
      terms.firstWhereOrNull((element) => element.slug == slug);
}

extension TermEntityListX on List<TermEntity> {
  Iterable<String> get _slugs => map((e) => e.slug);
  bool get allRequired =>
      TermStorage.requiredTerms.every((e) => _slugs.contains(e.slug));
}
