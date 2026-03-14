import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/user/data/data_source/constant/term_storage.dart';
import 'package:pot_g/app/modules/user/domain/entities/self_user_entity.dart';
import 'package:pot_g/app/modules/user/domain/entities/term_entity.dart';
import 'package:pot_g/app/modules/user/presentation/blocs/consent_bloc.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class ConsentPage extends StatelessWidget with LogPage {
  const ConsentPage({super.key, this.onDone});

  final VoidCallback? onDone;

  bool _redirect(BuildContext context, SelfUserEntity user) {
    if (!user.agreedTerms.allRequired) return false;
    if (onDone != null) {
      onDone!();
    } else {
      context.router.popUntilRoot();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ConsentBloc>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConsentBloc, ConsentState>(
            listener: (context, state) {
              state.mapOrNull(
                error: (e) => context.showToast(
                  '${context.t.common.unknown_error} (${e.errorId})',
                ),
                loaded: (_) {
                  final user = context.read<AuthBloc>().state.user;
                  if (user == null) return;
                  if (_redirect(context, user)) return;
                  context.read<AuthBloc>().add(AuthEvent.update());
                },
              );
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.mapOrNull(
                authenticated: (user) {
                  _redirect(context, user.user);
                },
              );
            },
          ),
        ],
        child: _Layout(),
      ),
    );
  }

  @override
  String get pageName => 'consent';
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  List<TermEntity> _agreedTerms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.logo.color.image(),
                    const SizedBox(height: 12),
                    Text(
                      context.t.consent.welcome,
                      style: TextStyles.title1.copyWith(color: Palette.dark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.t.consent.description,
                      style: TextStyles.body.copyWith(color: Palette.textGrey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              PotPressable(
                opacity: 0.9,
                onTap: () {
                  setState(() {
                    if (_agreedTerms.allRequired) {
                      _agreedTerms = [];
                    } else {
                      _agreedTerms = TermStorage.requiredTerms.toList();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _agreedTerms.allRequired
                          ? Palette.primary
                          : Palette.borderGrey2,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _agreedTerms.allRequired
                          ? Assets.icons.checkCircleFilled.svg()
                          : Assets.icons.checkCircle.svg(),
                      const SizedBox(width: 12),
                      Text(
                        context.t.consent.cta,
                        style: TextStyles.title3.copyWith(
                          color: _agreedTerms.allRequired
                              ? Palette.primary
                              : Palette.borderGrey2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...(TermStorage.terms.map(
                _buildTerm,
              )).intersperse(const SizedBox(height: 4)),
              const SizedBox(height: 24),
              PotButton(
                onPressed: _agreedTerms.allRequired
                    ? () {
                        context.read<ConsentBloc>().add(
                          ConsentEvent.update(_agreedTerms),
                        );
                      }
                    : null,
                variant: PotButtonVariant.emphasized,
                child: Text(context.t.consent.cta),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTerm(TermEntity term) {
    return PotPressable(
      opacity: 0.9,
      onTap: () {
        setState(() {
          if (_agreedTerms.contains(term)) {
            _agreedTerms.remove(term);
          } else {
            _agreedTerms.add(term);
          }
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Assets.icons.check.svg(
                colorFilter: ColorFilter.mode(
                  _agreedTerms.contains(term)
                      ? Palette.primary
                      : Palette.borderGrey2,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              context.t.consent.type(context: term.type),
              style: TextStyles.title4.copyWith(
                color: _agreedTerms.contains(term)
                    ? Palette.textGrey
                    : Palette.borderGrey2,
              ),
            ),
          ),
          PotPressable(
            onTap: () => launchUrlString(term.url),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Assets.icons.navArrowRight.svg(
                  colorFilter: ColorFilter.mode(
                    Palette.borderGrey2,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
