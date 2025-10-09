import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_list_item.dart';
import 'package:pot_g/app/modules/core/data/models/pot_detail_model.dart';
import 'package:pot_g/app/modules/core/data/models/pot_model.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/data/models/stop_model.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/assets.gen.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyStop = StopModel(id: '', name: '송정역');
    final dummyStart = StopModel(id: '', name: '지스트');
    final dummyRoute = RouteModel(id: '', from: dummyStart, to: dummyStop);

    final dummy_pots1 = [
      PotDetailModel(
        id: '1',
        name: '팟 1',
        route: dummyRoute,
        startsAt: DateTime(2025, 12, 22, 12, 0),
        endsAt: DateTime(2025, 12, 22, 14, 30),
        departureTime: DateTime(2025, 12, 22, 11, 50),
        current: 2,
        total: 4,
        status: PotStatus.confirmed,
        accountingRequested: 12360,
      ),
      PotDetailModel(
        id: '2',
        name: '팟 2',
        route: dummyRoute,
        startsAt: DateTime(2025, 12, 24, 11, 30),
        endsAt: DateTime(2025, 12, 24, 14, 30),
        departureTime: DateTime(2025, 12, 24, 11, 20),
        current: 3,
        total: 4,
        status: PotStatus.beforeConfirmed,
        accountingRequested: 12360,
      ),
      PotDetailModel(
        id: '3',
        name: '팟 3',
        route: dummyRoute,
        startsAt: DateTime(2025, 12, 24, 12, 0),
        endsAt: DateTime(2025, 12, 24, 14, 30),
        departureTime: DateTime(2025, 12, 24, 11, 20),
        current: 3,
        total: 4,
        status: PotStatus.waitAccounting,
        accountingRequested: 12360,
      ),
    ];

    final dummy_pots2 = [
      PotDetailModel(
        id: '4',
        name: '팟 4',
        route: dummyRoute,
        startsAt: DateTime(2025, 12, 22, 12, 0),
        endsAt: DateTime(2025, 12, 22, 14, 30),
        departureTime: DateTime(2025, 12, 22, 11, 50),
        current: 2,
        total: 4,
        status: PotStatus.archived,
        accountingRequested: 12360,
      ),
      PotDetailModel(
        id: '5',
        name: '팟 5',
        route: dummyRoute,
        startsAt: DateTime(2025, 12, 24, 11, 30),
        endsAt: DateTime(2025, 12, 24, 14, 30),
        departureTime: DateTime(2025, 12, 24, 11, 20),
        current: 3,
        total: 4,
        status: PotStatus.archived,
        accountingRequested: 12360,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Palette.lightGrey,
                    child: _ChatListView(
                      activePots: dummy_pots1,
                      closedPots: dummy_pots2,
                    ),
                    // TO DO : connect bloc and show list
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChatListView extends StatefulWidget {
  const _ChatListView({required this.activePots, required this.closedPots});
  final List<PotDetailModel> activePots;
  final List<PotDetailModel> closedPots;

  @override
  State<_ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<_ChatListView> {
  bool _showClosed = false;

  @override
  Widget build(BuildContext context) {
    final hasActivePots = widget.activePots.isNotEmpty;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        20,
        16,
        MediaQuery.of(context).size.height * 0.3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasActivePots) ...[
            ...widget.activePots.indexed.expand(
              (e) => [ChatListItem(pot: e.$2), const SizedBox(height: 15)],
            ),
          ] else ...[
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                height:
                    _showClosed ? 0 : MediaQuery.of(context).size.height * 0.65,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.fofoSad.svg(
                        colorFilter: ColorFilter.mode(
                          Palette.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "참여 중인 팟이 없습니다",
                        style: TextStyle(fontSize: 16, color: Palette.textGrey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          GestureDetector(
            onTap: () => setState(() => _showClosed = !_showClosed),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _showClosed ? "해산된 팟 접기" : "해산된 팟 보기",
                    style: const TextStyle(fontSize: 16, color: Palette.grey),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _showClosed
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Palette.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                axis: Axis.vertical,
                child: child,
              );
            },
            child:
                _showClosed
                    ? Column(
                      key: const ValueKey('closedList'),
                      children: [
                        ...widget.closedPots.indexed.expand(
                          (e) => [
                            ChatListItem(pot: e.$2),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ],
                    )
                    : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}
