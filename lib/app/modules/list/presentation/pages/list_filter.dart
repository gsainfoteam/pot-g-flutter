import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/date_select.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/path_select.dart';
import 'package:pot_g/app/modules/core/presentation/route_list_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/list_cubit.dart';

class ListFilter extends StatelessWidget {
  const ListFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const _PathSelect(),
        const SizedBox(height: 15),
        const _DateSelect(),
      ],
    );
  }
}

class _PathSelect extends StatelessWidget {
  const _PathSelect();

  @override
  Widget build(BuildContext context) {
    final opened = context.select((ListCubit bloc) => bloc.state.pathOpened);
    final selected = context.select((ListCubit bloc) => bloc.state.route);
    return PathSelect(
      routes: context.select((RouteListBloc bloc) => bloc.state.routes),
      selectedRoute: selected,
      onSelected: (route) => context.read<ListCubit>().routeChanged(route),
      isOpen: opened,
      onOpenChanged:
          (value) => context.read<ListCubit>().pathOpenedChanged(value),
    );
  }
}

class _DateSelect extends StatelessWidget {
  const _DateSelect();

  @override
  Widget build(BuildContext context) {
    final opened = context.select((ListCubit bloc) => bloc.state.dateOpened);
    final selected = context.select((ListCubit bloc) => bloc.state.date);
    return DateSelect(
      selectedDate: selected,
      isOpen: opened,
      onOpenChanged:
          (value) => context.read<ListCubit>().dateOpenedChanged(value),
      onSelected: (date) => context.read<ListCubit>().dateChanged(date),
    );
  }
}
