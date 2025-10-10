import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_detail_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_list_item.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/core/data/models/pot_detail_model.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.lightGrey,
      appBar: PotAppBar(title: Text(context.t.chat.title)),
      body: BlocBuilder<PotDetailBloc, PotDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return _ChatListView(
            activePots: state.activePotList,
            closedPots: state.archivedPotList,
          );
        },
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
      clipBehavior: Clip.none,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasActivePots) ...[
            ...widget.activePots.expandIndexed(
              (index, e) => [
                if (index != 0) const SizedBox(height: 16),
                ChatListItem(pot: e),
              ],
            ),
            const SizedBox(height: 32),
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
            onTap:
                () => setState(() {
                  _showClosed = !_showClosed;
                  L.c(
                    'expiredRoom',
                    properties: {'toggle': _showClosed ? 'show' : 'hide'},
                  );
                }),
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

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            curve: Curves.easeInOut,
            child:
                _showClosed
                    ? Column(
                      children: [
                        ...widget.closedPots.expand(
                          (e) => [
                            const SizedBox(height: 16),
                            ChatListItem(pot: e),
                          ],
                        ),
                      ],
                    )
                    : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }
}
