import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/report_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/report_exception_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_profile_image.dart';
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
    return BlocProvider(
      create: (_) => sl<ReportBloc>(param1: pot),
      child: _ReportView(pot: pot),
    );
  }
}

class _ReportView extends StatelessWidget {
  const _ReportView({required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listenWhen: (previous, current) =>
          previous.submissionSuccess != current.submissionSuccess,
      listener: (context, state) {
        if (state.submissionSuccess) {
          context.router.pop();
        }
      },
      child: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          final targetTitle = state.target == null
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
                              selectedTarget: state.target,
                              isOpen: state.targetSelectorOpen,
                              onTargetSelected: (user) => context
                                  .read<ReportBloc>()
                                  .add(ReportEvent.targetChanged(user)),
                              onOpenChanged: (value) =>
                                  context.read<ReportBloc>().add(
                                    ReportEvent.targetSelectorToggled(value),
                                  ),
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
                              selectedReason: state.reasonKey,
                              isOpen: state.reasonSelectorOpen,
                              onReasonSelected: (reason) => context
                                  .read<ReportBloc>()
                                  .add(ReportEvent.reasonChanged(reason)),
                              onOpenChanged: (value) =>
                                  context.read<ReportBloc>().add(
                                    ReportEvent.reasonSelectorToggled(value),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: state.error != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: SmallAlert(
                        text: state.error?.getErrorMessage(context) ?? '',
                        type: SmallAlertType.error,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SafeArea(
                      child: PotButton(
                        onPressed: state.canSubmit
                            ? () => context.read<ReportBloc>().add(
                                const ReportEvent.submitted(),
                              )
                            : null,
                        variant: PotButtonVariant.emphasized,
                        child: state.isSubmitting
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
      itemTitle: (user) => user.name,
      placeholder: context.report.fields.target.label,
      openItemBuilder: (context, user, selected) {
        if (user == null) return const SizedBox.shrink();
        return _TargetSelector(user: user, pot: pot, selected: selected);
      },
      closedItemBuilder: (context, user) =>
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

  final String? selectedReason;
  final bool isOpen;
  final void Function(String?) onReasonSelected;
  final void Function(bool) onOpenChanged;

  List<_ReasonOption> _options(BuildContext context) => [
    _ReasonOption(
      key: 'uncooperative_chat',
      label: context.report.fields.reason.items.uncooperative_chat,
    ),
    _ReasonOption(
      key: 'no_show',
      label: context.report.fields.reason.items.no_show,
    ),
    _ReasonOption(
      key: 'bad_behavior_during_ride',
      label: context.report.fields.reason.items.bad_behavior_during_ride,
    ),
    _ReasonOption(
      key: 'settlement_no_response',
      label: context.report.fields.reason.items.settlement_no_response,
    ),
    _ReasonOption(
      key: 'other',
      label: context.report.fields.reason.items.other,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final options = _options(context);
    final selected = options.firstWhereOrNull(
      (option) => option.key == selectedReason,
    );
    return Select<_ReasonOption>(
      items: options,
      selectedItem: selected,
      onSelected: (option) => onReasonSelected(option?.key),
      isOpen: isOpen,
      onOpenChanged: onOpenChanged,
      itemTitle: (reason) => reason.label,
      placeholder: context.report.fields.reason.placeholder,
      openItemBuilder: (context, reason, selected) {
        if (reason == null) return const SizedBox.shrink();
        return _ReasonSelector(title: reason.label, selected: selected);
      },
      closedItemBuilder: (context, reason) =>
          _ReasonSelector(title: reason.label, selected: false),
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

class _ReasonOption {
  const _ReasonOption({required this.key, required this.label});

  final String key;
  final String label;
}

extension on BuildContext {
  TranslationsChatRoomDrawerActionsReportPageEn get report =>
      this.t.chat_room.drawer.actions.report.page;
}
