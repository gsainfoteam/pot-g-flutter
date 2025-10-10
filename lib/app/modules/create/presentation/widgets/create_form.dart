import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/date_select.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/path_select.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/core/data/models/pot_model.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/route_list_bloc.dart';
import 'package:pot_g/app/modules/create/presentation/bloc/create_cubit.dart';
import 'package:pot_g/app/modules/create/presentation/bloc/create_pot_bloc.dart';
import 'package:pot_g/app/modules/create/presentation/widgets/time_interval_selector.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class CreateForm extends StatelessWidget {
  const CreateForm({super.key});

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
                  const _Info(),
                  const SizedBox(height: 32),
                  const _Capacity(),
                  const SizedBox(height: 32),
                  const _TimeInterval(),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: PotButton(
              onPressed: context.select(
                (CreateCubit cubit) =>
                    cubit.state.valid
                        ? () {
                          L.c('createPot');
                          final state = cubit.state;

                          final pot = PotModel(
                            id: '',
                            name: '',
                            route: state.route! as RouteModel,
                            startsAt: DateTime(
                              state.date!.year,
                              state.date!.month,
                              state.date!.day,
                              state.startTime!.hour,
                              state.startTime!.minute,
                              0,
                            ),
                            endsAt: DateTime(
                              state.date!.year,
                              state.date!.month,
                              state.date!.day,
                              state.endTime!.hour,
                              state.endTime!.minute,
                              0,
                            ),
                            current: 1,
                            total: state.maxCapacity!,
                          );

                          context.read<CreatePotBloc>().add(
                            CreatePotEvent.create(potData: pot),
                          );

                          context.router.push(ListRoute());
                        }
                        : null,
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
  const _Info();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.t.create.info.title, style: TextStyles.title4),
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
  const _Capacity();

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
        Text(context.t.create.capacity.title, style: TextStyles.title4),
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
                      color:
                          selected == i
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
  const _TimeInterval();

  @override
  Widget build(BuildContext context) {
    final preFilled = context.select(
      (CreateCubit cubit) =>
          cubit.state.route != null &&
          cubit.state.date != null &&
          cubit.state.maxCapacity != null,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.t.create.time_interval.title, style: TextStyles.title4),
        const SizedBox(height: 4),
        Text(
          context.t.create.time_interval.description,
          style: TextStyles.caption,
        ),
        const SizedBox(height: 12),
        TimeIntervalSelector(
          disabled: !preFilled,
          startTime: context.select(
            (CreateCubit cubit) => cubit.state.startTime,
          ),
          endTime: context.select((CreateCubit cubit) => cubit.state.endTime),
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
        ),
      ],
    );
  }
}
