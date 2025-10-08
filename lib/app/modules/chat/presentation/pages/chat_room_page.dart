import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/chat_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_bubble.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_info.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_users.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>()..add(ChatInit(pot)),
      child: Scaffold(
        appBar: PotAppBar(title: Text(pot.name)),
        endDrawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PotInfo(pot: pot),
                  const SizedBox(height: 20),
                  Container(height: 1, color: Palette.borderGrey2),
                  const SizedBox(height: 20),
                  PotUsers(pot: pot),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PotPressable(
                        onTap: () {},
                        child: Text(
                          context.t.chat_room.drawer.actions.leave,
                          style: TextStyles.caption.copyWith(
                            color: Palette.grey,
                            decoration: TextDecoration.underline,
                            decorationColor: Palette.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      PotPressable(
                        onTap: () {},
                        child: Text(
                          context.t.chat_room.drawer.actions.report,
                          style: TextStyles.caption.copyWith(
                            color: Palette.grey,
                            decoration: TextDecoration.underline,
                            decorationColor: Palette.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder:
                    (context, state) => ListView.separated(
                      reverse: true,
                      padding:
                          const EdgeInsets.all(12) - EdgeInsets.only(right: 6),
                      separatorBuilder: (context, index) {
                        final chat = state.chats[index];
                        final nextChat =
                            index == state.chats.length - 1
                                ? null
                                : state.chats[index + 1];
                        if (nextChat?.user.id == chat.user.id) {
                          return const SizedBox(height: 6);
                        }
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        final nextChat =
                            index == state.chats.length - 1
                                ? null
                                : state.chats[index + 1];
                        final isMe =
                            chat.user.id == AuthBloc.userOf(context)?.id;
                        return ChatBubble(
                          message: chat.message,
                          isFirst: nextChat?.user.id != chat.user.id,
                          user: isMe ? null : chat.user,
                          pot: pot,
                        );
                      },
                      itemCount: state.chats.length,
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
