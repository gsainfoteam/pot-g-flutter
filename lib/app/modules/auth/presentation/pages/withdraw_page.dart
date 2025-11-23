import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/domain/enums/withdraw_consent_type.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/withdraw_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/withdraw_consent_cubit.dart';
import 'package:pot_g/app/modules/auth/presentation/extensions/withdraw_consent_type_extension.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_checkbox.dart';
import 'package:pot_g/app/modules/user/domain/entities/self_user_entity.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<WithdrawConsentCubit>()),
        BlocProvider(create: (context) => sl<WithdrawBloc>()),
      ],
      child: BlocListener<WithdrawBloc, WithdrawState>(
        listener: (context, state) {
          state.mapOrNull(
            error: (e) => context.showToast(context.t.profile.withdraw.error),
            success: (e) =>
                context.router.push(const MainBottomNavigationRoute()),
          );
        },
        child: _Layout(user: user),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout({required this.user});

  final SelfUserEntity user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(
        title: Text(context.t.profile.account_management.withdraw),
      ),
      body: BlocBuilder<WithdrawConsentCubit, WithdrawConsentState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FofoAnimation(),
                    SizedBox(height: 20),
                    Text(
                      context.t.profile.withdraw.description(user: user.name),
                      style: TextStyles.title2,
                    ),
                    SizedBox(height: 20),
                    _ConsentList(),
                  ],
                ),
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: PotButton(
                          onPressed: () => context.router.pop(),
                          size: PotButtonSize.large,
                          variant: PotButtonVariant.outlined,
                          child: Text(context.t.common.cancel),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: PotButton(
                          onPressed: state.allChecked
                              ? () {
                                  context.read<WithdrawBloc>().add(
                                    WithdrawEvent.withdraw(),
                                  );
                                }
                              : null,
                          size: PotButtonSize.large,
                          variant: PotButtonVariant.emphasized,
                          child: Text(
                            context.t.profile.account_management.withdraw,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FofoAnimation extends StatefulWidget {
  const _FofoAnimation();

  @override
  State<_FofoAnimation> createState() => _FofoAnimationState();
}

class _FofoAnimationState extends State<_FofoAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Assets.lottie.withdrawFofo.lottie(
      fit: BoxFit.contain,
      width: 100,
      height: 100,
      controller: _controller,
      decoder: _customDecoder,
      onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..forward();
      },
    );
  }
}

class _ConsentList extends StatelessWidget {
  const _ConsentList();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<WithdrawConsentCubit>();
    return Column(
      children: WithdrawConsentType.values.map((type) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              PotCheckbox(
                value: cubit.state.consents.contains(type),
                onChanged: (value) => cubit.toggleConsent(type, value ?? false),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  type.getDescription(context),
                  style: TextStyles.body,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

Future<LottieComposition?> _customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}
