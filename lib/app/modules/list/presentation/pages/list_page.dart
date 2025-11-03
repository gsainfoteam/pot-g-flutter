import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_logo.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_summary_entity.dart';
import 'package:pot_g/app/modules/core/presentation/widgets/hidden_menu_button.dart';
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
      providers: [BlocProvider(create: (_) => sl<ListCubit>())],
      child: BlocListener<PotListBloc, PotListState>(
        listenWhen: (prev, curr) =>
            prev.error != curr.error && curr.error != null,
        listener: (context, state) => context.showToast(state.error!),
        child: BlocListener<ListCubit, ListState>(
          listenWhen: (prev, curr) =>
              prev.date != curr.date || prev.route != curr.route,
          listener: (context, state) => context.read<PotListBloc>().add(
            PotListEvent.search(date: state.date, route: state.route),
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
      appBar: PotAppBar(actions: [HiddenMenuButton()], leading: PotLogo()),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Palette.lightGrey,
                  child: BlocBuilder<PotListBloc, PotListState>(
                    builder: (context, state) => state.pots.isEmpty
                        ? state.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : _Refresh(
                                  child: CustomScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    slivers: [
                                      SliverFillRemaining(
                                        child: _EmptyScreen(),
                                      ),
                                    ],
                                  ),
                                )
                        : _ListView(pots: state.pots),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PanelDraggable(builder: (context) => const ListFilter()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListView extends StatefulWidget {
  const _ListView({required this.pots});
  final List<PotSummaryEntity> pots;

  @override
  State<_ListView> createState() => _ListViewState();
}

class _ListViewState extends State<_ListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<PotListBloc>();
      if (!bloc.state.endReached && !bloc.state.isLoading) {
        bloc.add(PotListEvent.loadMore());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Refresh(
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16,
          20,
          16,
          MediaQuery.of(context).size.height * 0.4,
        ),
        itemCount: widget.pots.length + 1, // +1 for loading indicator
        itemBuilder: (context, index) {
          if (index < widget.pots.length) {
            return Column(
              children: [
                PotListItem(pot: widget.pots[index]),
                const SizedBox(height: 15),
              ],
            );
          } else {
            return BlocBuilder<PotListBloc, PotListState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }
                if (state.endReached) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    child: Text(
                      context.t.list.reached_all,
                      style: TextStyles.description.copyWith(
                        color: Palette.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          }
        },
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
                onPressed: () {
                  final state = context.read<ListCubit>().state;
                  context.router.push(
                    CreateRoute(date: state.date, route: state.route),
                  );
                },
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

class _Refresh extends StatelessWidget {
  const _Refresh({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        final listCubit = context.read<ListCubit>();
        final potListBloc = context.read<PotListBloc>();

        potListBloc.add(
          PotListEvent.search(
            date: listCubit.state.date,
            route: listCubit.state.route,
          ),
        );

        await potListBloc.stream
            .firstWhere((state) => !state.isLoading)
            .timeout(const Duration(seconds: 10));
      },
      child: child,
    );
  }
}
