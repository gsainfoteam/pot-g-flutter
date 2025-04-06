import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/modules/main/domain/entities/pot_entity.dart';
import 'package:pot_g/app/modules/main/presentation/bloc/pot_list_bloc.dart';
import 'package:pot_g/app/modules/main/presentation/widgets/date_select.dart';
import 'package:pot_g/app/modules/main/presentation/widgets/path_select.dart';
import 'package:pot_g/app/modules/main/presentation/widgets/pot_list_item.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

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

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(
        actions: [
          PotIconButton(icon: Assets.icons.addPot.svg(), onPressed: () {}),
          PotIconButton(icon: Assets.icons.userCircle.svg(), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              color: Palette.white,
              child: Column(
                children: [
                  PathSelect(routes: [], onSelected: (_) {}),
                  const SizedBox(height: 15),
                  DateSelect(
                    onSelected:
                        (date) => context.read<PotListBloc>().add(
                          PotListEvent.search(date: date),
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children:
              pots.indexed
                  .expand(
                    (element) => [
                      if (element.$1 != 0) const SizedBox(height: 15),
                      PotListItem(pot: element.$2),
                    ],
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _EmptyScreen extends StatelessWidget {
  const _EmptyScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.icons.fofoSad.svg(
          colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
        ),
        const SizedBox(height: 16),
        Text(
          '해당 조건의 택시 팟이\n존재하지 않습니다',
          style: TextStyles.description.copyWith(color: Palette.textGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PotButton(
              onPressed: () {},
              size: PotButtonSize.medium,
              prefixIcon: Assets.icons.addPot.svg(
                colorFilter: ColorFilter.mode(
                  Palette.textGrey,
                  BlendMode.srcIn,
                ),
              ),
              child: Text(
                '새 팟 만들기',
                style: TextStyles.title4.copyWith(color: Palette.textGrey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
