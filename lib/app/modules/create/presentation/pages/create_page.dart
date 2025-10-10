import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/create/presentation/bloc/create_cubit.dart';
import 'package:pot_g/app/modules/create/presentation/bloc/create_pot_bloc.dart';
import 'package:pot_g/app/modules/create/presentation/widgets/create_form.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class CreatePage extends StatelessWidget with LogPageStateless {
  const CreatePage({super.key, this.date, this.route});

  @override
  String get pageName => 'createPot';

  final DateTime? date;
  final RouteEntity? route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(title: Text(context.t.create.title)),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<CreateCubit>(
            create: (context) {
              final cubit = sl<CreateCubit>();
              if (date != null) cubit.dateChanged(date!);
              if (route != null) cubit.routeChanged(route!);
              return cubit;
            },
          ),
          BlocProvider<CreatePotBloc>(create: (context) => sl<CreatePotBloc>()),
        ],
        child: const CreateForm(),
      ),
    );
  }
}
