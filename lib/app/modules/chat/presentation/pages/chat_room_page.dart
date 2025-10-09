import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/chat_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_bubble.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_info.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/pot_users.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/general_dialog.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ChatBloc>()..add(ChatInit(pot))),
        BlocProvider(
          create: (context) => sl<PotInfoBloc>()..add(PotInfoEvent.init(pot)),
        ),
      ],
      child: _Layout(),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    final pot = context.select((PotInfoBloc bloc) => bloc.state.pot);
    if (pot == null) return const SizedBox.shrink();
    return Scaffold(
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
          Expanded(child: _ChatList(pot: pot)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  _SetDepartureTimeButton(pot: pot),
                  _AccountingButton(),
                  Expanded(child: _ChatInput()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountingButton extends StatelessWidget {
  const _AccountingButton();

  @override
  Widget build(BuildContext context) {
    return PotIconButton(
      icon: Assets.icons.dollar.svg(
        colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
      ),
      onPressed: () {},
    );
  }
}

class _SetDepartureTimeButton extends StatelessWidget {
  const _SetDepartureTimeButton({required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return PotIconButton(
      icon: Assets.icons.clock.svg(
        colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
      ),
      onPressed: () async {
        if (!pot.meIsHost(context)) {
          context.showToast(
            context.t.chat_room.set_departure_time.host_only.description,
          );
          return;
        }
        DateTime date = DateTime.now();
        final result = await showGeneralOkCancelAdaptiveDialog(
          context: context,
          title: context.t.chat_room.set_departure_time.clock.title,
          child: SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              initialDateTime: date,
              onDateTimeChanged: (value) => date = value,
              mode: CupertinoDatePickerMode.time,
            ),
          ),
          okLabel: context.t.common.confirm,
        );
        if (result != OkCancelResult.ok) return;
        if (!context.mounted) return;
        final result2 = await showOkCancelAlertDialog(
          context: context,
          title: context.t.chat_room.set_departure_time.confirm.title,
          message: context.t.chat_room.set_departure_time.confirm.description(
            route: pot.route.name,
            time: DateFormat.jm().format(date),
          ),
        );
        if (result2 != OkCancelResult.ok) return;
        if (!context.mounted) return;
        context.read<PotInfoBloc>().add(PotInfoEvent.setDepartureTime(date));
      },
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList({required this.pot});

  final PotInfoEntity pot;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder:
          (context, state) => ListView.separated(
            reverse: true,
            padding: const EdgeInsets.all(12) - EdgeInsets.only(right: 6),
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
              final isMe = chat.user.id == AuthBloc.userOf(context)?.id;
              return ChatBubble(
                message: chat.message,
                isFirst: nextChat?.user.id != chat.user.id,
                user: isMe ? null : chat.user,
                pot: pot,
              );
            },
            itemCount: state.chats.length,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
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
          const SizedBox(width: 6),
          PotIconButton(
            icon: Assets.icons.sendDiagonal.svg(
              colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
            ),
            onPressed: () {
              context.read<ChatBloc>().add(ChatSendChat(_controller.text));
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
