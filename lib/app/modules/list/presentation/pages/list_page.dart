import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/list_cubit.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/pot_list_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/pages/list_filter.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/panel_draggable.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/pot_list_item.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ListCubit>()),
        BlocProvider(
          create: (_) => sl<PotListBloc>()..add(PotListEvent.search()),
        ),
      ],
      child: BlocListener<PotListBloc, PotListState>(
        listenWhen:
            (prev, curr) => prev.error != curr.error && curr.error != null,
        listener: (context, state) => context.showToast(state.error!),
        child: BlocListener<ListCubit, ListState>(
          listenWhen:
              (prev, curr) =>
                  prev.date != curr.date || prev.route != curr.route,
          listener:
              (context, state) => context.read<PotListBloc>().add(
                PotListEvent.search(date: state.date),
              ),
          child: _Layout(),
        ),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) => Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Palette.lightGrey,
                      child: BlocBuilder<PotListBloc, PotListState>(
                        builder:
                            (context, state) =>
                                state.pots.isEmpty
                                    ? _EmptyScreen()
                                    : _ListView(pots: state.pots),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PanelDraggable(
                      builder: (context) => const ListFilter(),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({required this.pots});
  final List<PotEntity> pots;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        20,
        16,
        MediaQuery.of(context).size.height * 0.4,
      ),
      child: Column(
        children: [
          ...pots.indexed.expand(
            (element) => [
              PotListItem(pot: element.$2),
              const SizedBox(height: 15),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 32),
            child: Text(
              context.t.list.reached_all,
              style: TextStyles.description.copyWith(color: Palette.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyScreen extends StatelessWidget {
  const _EmptyScreen();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.fofoSad.svg(
            colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
          ),
          const SizedBox(height: 16),
          Text(
            context.t.list.empty.description,
            style: TextStyles.description.copyWith(color: Palette.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PotButton(
                onPressed: () => context.router.push(const CreateRoute()),
                size: PotButtonSize.medium,
                prefixIcon: Assets.icons.addPot.svg(
                  colorFilter: ColorFilter.mode(
                    Palette.textGrey,
                    BlendMode.srcIn,
                  ),
                ),
                child: Text(
                  context.t.list.empty.button,
                  style: TextStyles.title4.copyWith(color: Palette.textGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
