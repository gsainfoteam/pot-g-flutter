import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/date_select.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/path_select.dart';
import 'package:pot_g/app/modules/core/presentation/route_list_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/list_cubit.dart';
import 'package:pot_g/app/values/palette.dart';

class ListFilter extends StatelessWidget {
  const ListFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, -2),
            blurRadius: 8,
            color: Color(0x0d000000),
          ),
          BoxShadow(
            offset: Offset(-3, -2),
            blurRadius: 8,
            color: Color(0x0d000000),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Palette.grey,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const _PathSelect(),
            const SizedBox(height: 15),
            const _DateSelect(),
          ],
        ),
      ),
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
