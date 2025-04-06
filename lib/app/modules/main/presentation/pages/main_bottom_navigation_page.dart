import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

@RoutePage()
class MainBottomNavigationPage extends StatefulWidget {
  const MainBottomNavigationPage({super.key});

  @override
  State<MainBottomNavigationPage> createState() =>
      _MainBottomNavigationPageState();
}

class _MainBottomNavigationPageState extends State<MainBottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: [MainRoute(), MainRoute(), MainRoute(), MainRoute()],
      builder:
          (context, child, tabController) => Scaffold(
            body: child,
            appBar: PotAppBar(),
            bottomNavigationBar: Container(
              color: Palette.white,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Palette.borderGrey2, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children:
                        [
                              BottomNavigationBarItem(
                                icon: Assets.icons.addPot.svg(),
                                label: '팟 생성',
                              ),
                              BottomNavigationBarItem(
                                icon: Assets.icons.search.svg(),
                                label: '팟 검색',
                              ),
                              BottomNavigationBarItem(
                                icon: Assets.icons.chatBubble.svg(),
                                label: '채팅방',
                              ),
                              BottomNavigationBarItem(
                                icon: Assets.icons.userCircle.svg(),
                                label: '내 정보',
                              ),
                            ].indexed
                            .map(
                              (e) => Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => tabController.animateTo(e.$1),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Palette.primary,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            tabController.index == e.$1
                                                ? Palette.primary
                                                : Palette.textGrey,
                                            BlendMode.srcIn,
                                          ),
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: e.$2.icon,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          height: 16,
                                          child: Text(
                                            e.$2.label!,
                                            style: TextStyles.caption.copyWith(
                                              color:
                                                  tabController.index == e.$1
                                                      ? Palette.primary
                                                      : Palette.textGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
