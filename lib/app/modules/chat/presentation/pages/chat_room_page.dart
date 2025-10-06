import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/chat_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_bubble.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/modules/core/data/models/pot_model.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/data/models/stop_model.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

/// 연속된 요소만 그룹화하는 함수
/// [list]: 그룹화할 리스트
/// [keySelector]: 그룹화 기준이 되는 키를 추출하는 함수
///
/// 예시: [1, 2, 13, 14, 4, 3, 23, 12]를 (x) => x % 10으로 그룹화하면
/// [[1, 2], [13, 14], [4, 3], [23], [12]]가 됩니다.
List<List<T>> groupConsecutiveBy<T, K>(
  List<T> list,
  K Function(T) keySelector,
) {
  if (list.isEmpty) return [];

  final result = <List<T>>[];
  List<T> currentGroup = [list.first];

  for (int i = 1; i < list.length; i++) {
    final currentItem = list[i];
    final previousItem = list[i - 1];

    // 현재 아이템과 이전 아이템의 키가 같으면 같은 그룹에 추가
    if (keySelector(currentItem) == keySelector(previousItem)) {
      currentGroup.add(currentItem);
    } else {
      // 키가 다르면 현재 그룹을 결과에 추가하고 새 그룹 시작
      result.add(List.from(currentGroup));
      currentGroup = [currentItem];
    }
  }

  // 마지막 그룹 추가
  result.add(currentGroup);

  return result;
}

@RoutePage()
class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<ChatBloc>()..add(
                ChatInit(
                  PotModel(
                    id: id,
                    current: 1,
                    endsAt: DateTime.now(),
                    startsAt: DateTime.now(),
                    route: RouteModel(
                      id: id,
                      from: StopModel(id: id, name: ''),
                      to: StopModel(id: id, name: ''),
                    ),
                    total: 4,
                  ),
                ),
              ),
      child: Scaffold(
        appBar: PotAppBar(title: Text('지송 003')),
        endDrawer: Drawer(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12) - EdgeInsets.only(right: 6),
                  child: _ChatList(),
                ),
              ),
            ),
            SafeArea(child: _ChatInput()),
          ],
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final chats = groupConsecutiveBy(state.chats, (chat) => chat.user.id);
        return Column(
          children:
              chats
                  .expandIndexed(
                    (index, chats) => [
                      if (index != 0) const SizedBox(height: 12),
                      _buildChatGroup(index, chats),
                    ],
                  )
                  .toList(),
        );
      },
    );
  }

  Column _buildChatGroup(int index, List<ChatEntity> chats) {
    return Column(
      children:
          chats
              .expandIndexed(
                (i, chat) => [
                  if (i != 0) const SizedBox(height: 6),
                  _buildChat(chat, i == 0),
                ],
              )
              .toList(),
    );
  }

  Widget _buildChat(ChatEntity chat, bool isFirst) {
    return Builder(
      builder:
          (context) => ChatBubble(
            message: chat.message,
            user:
                chat.user.id == AuthBloc.userOf(context)?.id ? null : chat.user,
            isFirst: isFirst,
          ),
    );
  }
}

class _ChatInput extends StatefulWidget {
  const _ChatInput();

  @override
  State<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<_ChatInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Assets.icons.clock.svg(
            colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Assets.icons.dollar.svg(
            colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyles.description.copyWith(
                height: 19 / 16,
                color: Palette.textGrey,
              ),
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                fillColor: Palette.lightGrey,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 24,
            height: 24,
            child: PotIconButton(
              icon: Assets.icons.sendDiagonal.svg(
                colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
              ),
              onPressed: () {
                context.read<ChatBloc>().add(ChatSendChat(_controller.text));
                _controller.clear();
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
