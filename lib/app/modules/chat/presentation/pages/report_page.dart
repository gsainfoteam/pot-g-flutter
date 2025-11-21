import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/report_reason.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/report_cubit.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/report_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/report_exception_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_profile_image.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_text_area.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/select.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/small_alert.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class ReportPage extends StatelessWidget {
  const ReportPage({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ReportCubit>()),
        BlocProvider(create: (_) => sl<ReportBloc>()),
      ],
      child: _ReportView(pot: pot),
    );
  }
}

class _ReportView extends StatelessWidget {
  const _ReportView({required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportSubmitState>(
      listenWhen: (previous, current) => previous.success != current.success,
      listener: (context, state) {
        if (state.success) {
          context.router.pop();
        }
      },
      child: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, formState) {
          final submitState = context.watch<ReportBloc>().state;
          final targetTitle = formState.target == null
              ? context.report.fields.target.label
              : context.report.fields.target.label_filled;
          return Scaffold(
            appBar: PotAppBar(title: Text(context.report.title)),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              targetTitle,
                              style: TextStyles.title4.copyWith(
                                color: Palette.dark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _TargetSelect(
                              pot: pot,
                              selectedTarget: formState.target,
                              isOpen: formState.targetSelectorOpen,
                              onTargetSelected: (user) => context
                                  .read<ReportCubit>()
                                  .targetChanged(user),
                              onOpenChanged: (value) => context
                                  .read<ReportCubit>()
                                  .targetSelectorToggled(value),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              context.report.fields.reason.label,
                              style: TextStyles.title4.copyWith(
                                color: Palette.dark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _ReasonSelect(
                              selectedReason: formState.reason,
                              isOpen: formState.reasonSelectorOpen,
                              onReasonSelected: (reason) => context
                                  .read<ReportCubit>()
                                  .reasonChanged(reason),
                              onOpenChanged: (value) => context
                                  .read<ReportCubit>()
                                  .reasonSelectorToggled(value),
                            ),
                            if (formState.reason?.requiresDetail ?? false) ...[
                              const SizedBox(height: 12),
                              PotTextArea(
                                hintText: context
                                    .report
                                    .fields
                                    .reason
                                    .placeholder_other,
                                maxLength: ReportCubit.maxReasonLength,
                                initialValue: formState.reasonDetail,
                                onChanged: (value) => context
                                    .read<ReportCubit>()
                                    .reasonDetailChanged(value),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: submitState.error != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: SmallAlert(
                        text: submitState.error?.getErrorMessage(context) ?? '',
                        type: SmallAlertType.error,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SafeArea(
                      child: PotButton(
                        onPressed:
                            formState.canSubmit && !submitState.isSubmitting
                            ? () => context.read<ReportBloc>().add(
                                ReportSubmitEvent.submit(
                                  pot: pot,
                                  target: formState.target!,
                                  reason: formState.reason!,
                                  reasonDetail:
                                      (formState.reason?.requiresDetail ??
                                          false)
                                      ? formState.reasonDetail
                                      : null,
                                ),
                              )
                            : null,
                        variant: PotButtonVariant.emphasized,
                        child: submitState.isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(context.report.fields.reason.button),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TargetSelect extends StatelessWidget {
  const _TargetSelect({
    required this.pot,
    this.selectedTarget,
    required this.isOpen,
    required this.onTargetSelected,
    required this.onOpenChanged,
  });

  final PotInfoEntity pot;
  final PotUserEntity? selectedTarget;
  final bool isOpen;
  final void Function(PotUserEntity?) onTargetSelected;
  final void Function(bool) onOpenChanged;

  @override
  Widget build(BuildContext context) {
    final users = pot.getPassengersExceptMe(context);
    return Select<PotUserEntity>(
      items: users,
      selectedItem: selectedTarget,
      onSelected: onTargetSelected,
      isOpen: isOpen,
      onOpenChanged: onOpenChanged,
      placeholder: Text(context.report.fields.target.label),
      itemBuilder: (context, user, selected) {
        if (user == null) return const SizedBox.shrink();
        return _TargetSelector(user: user, pot: pot, selected: selected);
      },
      selectedItemBuilder: (context, user) =>
          _TargetSelector(user: user, pot: pot, selected: false),
    );
  }
}

class _ReasonSelect extends StatelessWidget {
  const _ReasonSelect({
    this.selectedReason,
    required this.isOpen,
    required this.onReasonSelected,
    required this.onOpenChanged,
  });

  final ReportReason? selectedReason;
  final bool isOpen;
  final void Function(ReportReason?) onReasonSelected;
  final void Function(bool) onOpenChanged;

  @override
  Widget build(BuildContext context) {
    return Select<ReportReason>(
      items: ReportReason.values,
      selectedItem: selectedReason,
      onSelected: onReasonSelected,
      isOpen: isOpen,
      onOpenChanged: onOpenChanged,
      placeholder: Text(context.report.fields.reason.placeholder),
      itemBuilder: (context, reason, selected) {
        if (reason == null) return const SizedBox.shrink();
        return _ReasonSelector(
          title: context.report.fields.reason.items(context: reason),
          selected: selected,
        );
      },
      selectedItemBuilder: (context, reason) => _ReasonSelector(
        title: context.report.fields.reason.items(context: reason),
        selected: false,
      ),
    );
  }
}

class _TargetSelector extends StatelessWidget {
  const _TargetSelector({
    required this.user,
    required this.pot,
    required this.selected,
  });

  final PotUserEntity user;
  final PotInfoEntity pot;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PotProfileImage(user: user, pot: pot),
          const SizedBox(width: 8),
          Text(
            user.name,
            style: TextStyles.description.copyWith(
              color: selected ? Palette.primary : Palette.dark,
            ),
          ),
          Spacer(),
          if (selected)
            Assets.icons.check.svg(
              colorFilter: ColorFilter.mode(Palette.primary, BlendMode.srcIn),
            ),
        ],
      ),
    );
  }
}

class _ReasonSelector extends StatelessWidget {
  const _ReasonSelector({required this.title, this.selected = false});

  final String title;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyles.description.copyWith(
              color: selected ? Palette.primary : Palette.textGrey,
            ),
          ),
          if (selected)
            Assets.icons.check.svg(
              colorFilter: ColorFilter.mode(Palette.primary, BlendMode.srcIn),
            ),
        ],
      ),
    );
  }
}

extension on BuildContext {
  TranslationsChatRoomDrawerActionsReportPageEn get report =>
      this.t.chat_room.drawer.actions.report.page;
}
