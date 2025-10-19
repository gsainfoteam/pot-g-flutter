import 'package:pot_g/app/modules/user/domain/enums/term_type.dart';

final class TermEntity {
  final String slug;
  final TermType type;
  final String url;
  final bool required;
  const TermEntity({
    required this.slug,
    required this.type,
    required this.url,
    required this.required,
  });
}
