import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

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
      physics: NeverScrollableScrollPhysics(),
      routes: [ListRoute(), ChatRoute(), ProfileRoute()],
      builder:
          (context, child, tabController) => Scaffold(
            body: child,
            bottomNavigationBar: Container(
              color: Palette.white,
              child: SafeArea(
                child: Stack(
                  children: [
                    Container(
                      height: 0,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Palette.borderGrey2, width: 1),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children:
                            [
                                  BottomNavigationBarItem(
                                    icon: Assets.icons.addPot.svg(),
                                    label: context.t.create.menu_title,
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Assets.icons.search.svg(),
                                    label: context.t.list.title,
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
                                  (e) =>
                                      _buildItem(tabController, e.$1 - 1, e.$2),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Expanded _buildItem(
    TabController tabController,
    int index,
    BottomNavigationBarItem item,
  ) {
    var selected = tabController.index == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          // 검색 탭이 아닌 경우, 로그인 여부 확인이 필요합니다
          if (index != 0) {
            final user = context.read<AuthBloc>().state.user;
            if (user == null) {
              final result = await showOkCancelAlertDialog(
                context: context,
                title: context.t.unauthorized.title,
                message: context.t.unauthorized.description,
              );
              if (!mounted) return;
              if (result != OkCancelResult.ok) return;

              final bloc = context.read<AuthBloc>();
              final waiter = bloc.stream.firstWhere(
                (s) => s is AuthError || s is Authenticated,
              );
              bloc.add(const AuthEvent.login());
              final result2 = await waiter;
              if (!mounted) return;
              if (result2 is! Authenticated) return;
            }
          }
          if (index < 0) {
            context.router.push(CreateRoute());
          } else {
            tabController.animateTo(index);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: selected ? Palette.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  selected ? Palette.primary : Palette.textGrey,
                  BlendMode.srcIn,
                ),
                child: SizedBox(height: 30, width: 30, child: item.icon),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 16,
                child: Text(
                  item.label!,
                  style: TextStyles.caption.copyWith(
                    color: selected ? Palette.primary : Palette.textGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
