import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/pot_list_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/date_select.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/panel_draggable.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/path_select.dart';
import 'package:pot_g/app/modules/list/presentation/widgets/pot_list_item.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PotListBloc>()..add(PotListEvent.search()),
      child: BlocListener<PotListBloc, PotListState>(
        listenWhen:
            (prev, curr) => prev.error != curr.error && curr.error != null,
        listener: (context, state) => context.showToast(state.error!),
        child: _Layout(),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  bool _pathSelectOpened = false;
  bool _dateSelectOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      builder: (context) => _buildSheet(context),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Container _buildSheet(BuildContext context) {
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
            PathSelect(
              routes: [],
              onSelected: (_) {},
              isOpen: _pathSelectOpened,
              onOpenChanged:
                  (value) => setState(() {
                    _pathSelectOpened = value;
                    _dateSelectOpened = false;
                  }),
            ),
            const SizedBox(height: 15),
            DateSelect(
              isOpen: _dateSelectOpened,
              onOpenChanged:
                  (value) => setState(() {
                    _dateSelectOpened = value;
                    _pathSelectOpened = false;
                  }),
              onSelected:
                  (date) => context.read<PotListBloc>().add(
                    PotListEvent.search(date: date),
                  ),
            ),
          ],
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
                onPressed: () => AutoTabsRouter.of(context).setActiveIndex(0),
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
