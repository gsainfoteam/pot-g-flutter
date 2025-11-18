import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/date_select.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/path_select.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/small_alert.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/route_list_bloc.dart';
import 'package:pot_g/app/modules/create/presentation/bloc/create_cubit.dart';
import 'package:pot_g/app/modules/create/presentation/bloc/create_pot_bloc.dart';
import 'package:pot_g/app/modules/create/presentation/widgets/time_interval_selector.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class CreateForm extends StatefulWidget {
  const CreateForm({super.key});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  bool _showInvalidAlert = false;
  Timer? _alertTimer;

  void _showInvalidFormAlert() {
    setState(() {
      _showInvalidAlert = true;
    });
    _alertTimer?.cancel();
    _alertTimer = Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() {
        _showInvalidAlert = false;
      });
    });
  }

  @override
  void dispose() {
    _alertTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  _Info(showValidation: _showInvalidAlert),
                  const SizedBox(height: 32),
                  _Capacity(showValidation: _showInvalidAlert),
                  const SizedBox(height: 32),
                  _TimeInterval(showValidation: _showInvalidAlert),
                ],
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: _showInvalidAlert ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: SmallAlert(
            text: context.t.create.errors.invalid_form,
            type: SmallAlertType.error,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: PotButton(
              onPressed: context.select(
                (CreateCubit cubit) => cubit.state.valid
                    ? () {
                        L.c('createPot');
                        final state = cubit.state;
                        final bloc = context.read<CreatePotBloc>();
                        final startsAt = state.date!.copyWith(
                          hour: state.startTime!.hour,
                          minute: state.startTime!.minute,
                        );
                        final endsAt = state.date!.copyWith(
                          hour: state.endTime!.hour,
                          minute: state.endTime!.minute,
                        );
                        bloc.add(
                          CreatePotEvent.create(
                            routeId: state.route!.id,
                            startsAt: startsAt,
                            endsAt: endsAt.isBefore(startsAt)
                                ? endsAt.add(const Duration(days: 1))
                                : endsAt,
                            maxCount: state.maxCapacity!,
                          ),
                        );
                      }
                    : () => _showInvalidFormAlert(),
              ),
              variant: PotButtonVariant.emphasized,
              child: Text(context.t.create.action),
            ),
          ),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final bool showValidation;

  const _Info({required this.showValidation});

  @override
  Widget build(BuildContext context) {
    final filled = context.select(
      (CreateCubit cubit) =>
          cubit.state.route != null && cubit.state.date != null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t.create.info.title,
          style: TextStyles.title4.copyWith(
            color: showValidation && !filled
                ? Palette.warning
                : Palette.textGrey,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          context.t.create.info.fields.route.label,
          style: TextStyles.caption,
        ),
        const SizedBox(height: 4),
        const _PathInput(),
        const SizedBox(height: 12),
        Text(
          context.t.create.info.fields.date.label,
          style: TextStyles.caption,
        ),
        const SizedBox(height: 4),
        const _DateInput(),
      ],
    );
  }
}

class _PathInput extends StatelessWidget {
  const _PathInput();

  @override
  Widget build(BuildContext context) {
    final opened = context.select(
      (CreateCubit cubit) => cubit.state.pathOpened,
    );
    final selected = context.select((CreateCubit cubit) => cubit.state.route);

    return PathSelect(
      showAll: false,
      selectedRoute: selected,
      routes: context.select((RouteListBloc bloc) => bloc.state.routes),
      onSelected: (route) {
        L.c('routeSelectorItem', properties: {'item': route!.name});
        context.read<CreateCubit>().routeChanged(route);
      },
      isOpen: opened,
      onOpenChanged: (value) {
        if (value) {
          L.c('routeSelector');
        }
        context.read<CreateCubit>().pathOpenedChanged(value);
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  const _DateInput();

  @override
  Widget build(BuildContext context) {
    final opened = context.select(
      (CreateCubit cubit) => cubit.state.dateOpened,
    );
    final selected = context.select((CreateCubit cubit) => cubit.state.date);

    return DateSelect(
      selectedDate: selected,
      minDate: DateTime.now().startOfDay(),
      maxDate: DateTime.now().add(const Duration(days: 13)).endOfDay(),
      onSelected: (date) {
        L.c(
          'dateSelectorItem',
          properties: {'item': DateFormat.yMd().format(date)},
        );
        context.read<CreateCubit>().dateChanged(date);
      },
      isOpen: opened,
      onOpenChanged: (value) {
        if (value) {
          L.c('dateSelector');
        }
        context.read<CreateCubit>().dateOpenedChanged(value);
      },
    );
  }
}

class _Capacity extends StatelessWidget {
  final bool showValidation;

  const _Capacity({required this.showValidation});

  @override
  Widget build(BuildContext context) {
    final preFilled = context.select(
      (CreateCubit cubit) =>
          cubit.state.route != null && cubit.state.date != null,
    );
    final selected = context.select(
      (CreateCubit cubit) => cubit.state.maxCapacity,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t.create.capacity.title,
          style: TextStyles.title4.copyWith(
            color: showValidation && selected == null
                ? Palette.warning
                : Palette.textGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(context.t.create.capacity.description, style: TextStyles.caption),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 2; i <= 4; i++) ...[
              Expanded(
                child: PotButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  onPressed: () {
                    L.c('capacity', properties: {'item': i.toString()});
                    context.read<CreateCubit>().maxCapacityChanged(i);
                  },
                  size: PotButtonSize.medium,
                  child: Text(
                    context.t.create.capacity.fields.max_capacity.item(n: i),
                    style: TextStyle(
                      color: selected == i
                          ? Palette.primary
                          : preFilled
                          ? Palette.textGrey
                          : Palette.grey,
                    ),
                  ),
                ),
              ),
              if (i < 4) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _TimeInterval extends StatelessWidget {
  final bool showValidation;

  const _TimeInterval({required this.showValidation});

  @override
  Widget build(BuildContext context) {
    final preFilled = context.select(
      (CreateCubit cubit) =>
          cubit.state.route != null &&
          cubit.state.date != null &&
          cubit.state.maxCapacity != null,
    );
    final filled = context.select(
      (CreateCubit cubit) =>
          cubit.state.startTime != null && cubit.state.endTime != null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t.create.time_interval.title,
          style: TextStyles.title4.copyWith(
            color: showValidation && !filled
                ? Palette.warning
                : Palette.textGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.t.create.time_interval.description,
          style: TextStyles.caption,
        ),
        const SizedBox(height: 12),
        Builder(
          builder: (context) {
            final cubit = context.watch<CreateCubit>();
            final minStartTime = cubit.state.date?.isToday == true
                ? DateTime.now()
                      .add(const Duration(minutes: 10))
                      .copyWith(second: 0, millisecond: 0, microsecond: 0)
                : null;

            return TimeIntervalSelector(
              disabled: !preFilled,
              minStartTime: minStartTime,
              startTime: cubit.state.startTime,
              endTime: cubit.state.endTime,
              onStartChanged: (time) {
                L.c(
                  'startTimeSelector',
                  properties: {'item': DateFormat.Hm().format(time)},
                );
                context.read<CreateCubit>().startTimeChanged(time);
              },
              onEndChanged: (time) {
                L.c(
                  'endTimeSelector',
                  properties: {'item': DateFormat.Hm().format(time)},
                );
                context.read<CreateCubit>().endTimeChanged(time);
              },
            );
          },
        ),
      ],
    );
  }
}
