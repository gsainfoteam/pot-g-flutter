import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_logo.dart';
import 'package:pot_g/app/modules/core/data/models/pot_model.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/data/models/stop_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_summary_entity.dart';
import 'package:pot_g/app/modules/core/presentation/widgets/hidden_menu_button.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/list_cubit.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/pot_list_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/pages/list_filter.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/banner_carousel.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/panel_draggable.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/pot_list_item.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _listBannerEntries = [
  BannerEntry(
    asset: Assets.images.bannerZiggle,
    onTap: () =>
        launchUrlString('https://ziggle.gistory.me/app?redirect=/home'),
  ),
  BannerEntry(
    asset: Assets.images.bannerInfoteam,
    onTap: () => launchUrlString(
      'https://infoteam-rulrudino.notion.site/2fb365ea27df8061ae1cdd7067d31580?pvs=105',
    ),
  ),
];

/// 디버그 모드에서만 사용하는 목업 팟 리스트.
List<PotSummaryEntity> get _mockPotsForDebug {
  final now = DateTime.now();
  const uSquare = StopModel(id: '1', name: '유스퀘어', lat: 0, lng: 0);
  const gist = StopModel(id: '2', name: '지스트', lat: 0, lng: 0);
  const station = StopModel(id: '3', name: '송정역', lat: 0, lng: 0);
  const giToU = RouteModel(id: '1', from: gist, to: uSquare);
  const uToGi = RouteModel(id: '2', from: uSquare, to: gist);
  const songToGi = RouteModel(id: '3', from: station, to: gist);

  return [
    PotModel(
      id: 'm1',
      name: '목업 팟 1',
      route: giToU,
      startsAt: now.copyWith(hour: 8, minute: 0),
      endsAt: now.copyWith(hour: 9, minute: 30),
      current: 2,
      total: 4,
    ),
    PotModel(
      id: 'm2',
      name: '목업 팟 2',
      route: giToU,
      startsAt: now.copyWith(hour: 10, minute: 0),
      endsAt: now.copyWith(hour: 11, minute: 0),
      current: 4,
      total: 4,
    ),
    PotModel(
      id: 'm3',
      name: '목업 팟 3',
      route: uToGi,
      startsAt: now.copyWith(hour: 13, minute: 10),
      endsAt: now.copyWith(hour: 14, minute: 0),
      current: 1,
      total: 4,
    ),
    PotModel(
      id: 'm4',
      name: '목업 팟 4',
      route: uToGi,
      startsAt: now.copyWith(hour: 18, minute: 0),
      endsAt: now.copyWith(hour: 19, minute: 30),
      current: 3,
      total: 4,
    ),
    PotModel(
      id: 'm5',
      name: '목업 팟 5',
      route: songToGi,
      startsAt: now.add(const Duration(days: 1)).copyWith(hour: 8, minute: 0),
      endsAt: now.add(const Duration(days: 1)).copyWith(hour: 9, minute: 0),
      current: 2,
      total: 4,
    ),
    PotModel(
      id: 'm6',
      name: '목업 팟 6',
      route: songToGi,
      startsAt: now.add(const Duration(days: 1)).copyWith(hour: 12, minute: 0),
      endsAt: now.add(const Duration(days: 1)).copyWith(hour: 13, minute: 30),
      current: 4,
      total: 4,
    ),
    PotModel(
      id: 'm7',
      name: '목업 팟 7',
      route: giToU,
      startsAt: now.add(const Duration(days: 2)).copyWith(hour: 9, minute: 0),
      endsAt: now.add(const Duration(days: 2)).copyWith(hour: 10, minute: 0),
      current: 3,
      total: 4,
    ),
  ];
}

@RoutePage()
class ListPage extends StatelessWidget with LogPage {
  const ListPage({super.key});

  @override
  String get pageName => 'searchPot';

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
                    builder: (context, state) {
                      final pots = kDebugMode ? _mockPotsForDebug : state.pots;
                      if (pots.isEmpty) {
                        if (state.isLoading && !kDebugMode) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return _Refresh(
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: BannerCarousel(
                                  banners: _listBannerEntries,
                                ),
                              ),
                              const SliverFillRemaining(child: _EmptyScreen()),
                            ],
                          ),
                        );
                      }
                      return _ListView(pots: pots);
                    },
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
    final bottomPadding = MediaQuery.of(context).size.height * 0.4;
    return _Refresh(
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: BannerCarousel(banners: _listBannerEntries),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
            sliver: SliverList.builder(
              itemCount: widget.pots.length + 1,
              itemBuilder: (context, index) {
                if (index < widget.pots.length) {
                  final pot = widget.pots[index];
                  final previousPot = index > 0 ? widget.pots[index - 1] : null;
                  final isSameDay = previousPot == null
                      ? false
                      : pot.startsAt.isSameDay(previousPot.startsAt);
                  final version = kDebugMode ? 2 : 1;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isSameDay && version >= 2) ...[
                        Row(
                          children: [
                            Text(
                              DateFormat.yMd().add_E().format(pot.startsAt),
                              style: TextStyles.caption.copyWith(
                                color: Palette.textGrey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Palette.textGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      PotListItem(pot: pot),
                      const SizedBox(height: 15),
                    ],
                  );
                }
                return BlocBuilder<PotListBloc, PotListState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
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
              },
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
