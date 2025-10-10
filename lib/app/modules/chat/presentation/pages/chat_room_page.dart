import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_action_button_type.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/chat_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_user_extension.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_bubble.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_room_drawer.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/fofo_bubble.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/system_message.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/error_cover.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/general_dialog.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_detail_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key, required this.pot});

  final PotDetailEntity pot;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ChatBloc>()),
        BlocProvider(
          create: (context) => sl<PotInfoBloc>()..add(PotInfoEvent.init(pot)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PotInfoBloc, PotInfoState>(
            listenWhen:
                (prev, curr) =>
                    prev.pot?.id != curr.pot?.id && curr.pot != null,
            listener:
                (context, state) =>
                    context.read<ChatBloc>().add(ChatInit(state.pot!)),
          ),
        ],
        child: BlocBuilder<PotInfoBloc, PotInfoState>(
          builder: (context, state) {
            if (state.error != null) {
              return ErrorCover(message: state.error!);
            }
            return _Layout();
          },
        ),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PotInfoBloc>().state;
    if (state.error != null) return ErrorCover(message: state.error!);
    if (state.pot == null) return Scaffold();
    final pot = state.pot!;
    return Scaffold(
      appBar: PotAppBar(title: Text(pot.name)),
      endDrawer: ChatRoomDrawer(pot: pot),
      body: Column(
        children: [
          Expanded(child: _ChatList(pot: pot)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  _SetDepartureTimeButton(pot: pot),
                  _AccountingButton(pot: pot),
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
  const _AccountingButton({required this.pot});

  final PotInfoEntity pot;

  static Future<void> setAccounting(
    BuildContext context,
    PotInfoEntity pot,
  ) async {
    if (!pot.meIsHost(context)) {
      context.showToast(context.t.chat_room.accounting.host_only.description);
      return;
    }
    await AccountingRoute(pot: pot).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return PotIconButton(
      icon: Assets.icons.dollar.svg(
        colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
      ),
      onPressed: () async {
        await setAccounting(context, pot);
      },
    );
  }
}

class _SetDepartureTimeButton extends StatelessWidget {
  const _SetDepartureTimeButton({required this.pot});

  final PotInfoEntity pot;

  static Future<void> setDepartureTime(
    BuildContext context,
    PotInfoEntity pot,
  ) async {
    if (!pot.meIsHost(context)) {
      context.showToast(
        context.t.chat_room.set_departure_time.host_only.description,
      );
      return;
    }
    if (pot.departureTime != null) {
      context.showToast(
        context.t.chat_room.set_departure_time.already_set.description,
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
  }

  @override
  Widget build(BuildContext context) {
    return PotIconButton(
      icon: Assets.icons.clock.svg(
        colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
      ),
      onPressed: () async {
        await setDepartureTime(context, pot);
      },
    );
  }
}

class _ChatList extends StatefulWidget {
  const _ChatList({required this.pot});

  final PotInfoEntity pot;

  @override
  State<_ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<_ChatList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
        context.read<ChatBloc>().add(ChatLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        bool isLast(int index) {
          final chat = state.chats[index];
          final nextChat =
              index == state.chats.length - 1 ? null : state.chats[index + 1];
          if (chat is! ChatEntity || nextChat is! ChatEntity) {
            return true;
          }
          return nextChat.user.id != chat.user.id;
        }

        return ListView.separated(
          controller: _controller,
          reverse: true,
          padding: const EdgeInsets.all(12) - EdgeInsets.only(right: 6),
          separatorBuilder:
              (context, index) => SizedBox(height: isLast(index) ? 12 : 6),
          itemBuilder: (context, index) => _buildItem(context, index, state),
          itemCount: state.chats.length + (state.isLoading ? 1 : 0),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index, ChatState state) {
    bool isFirst(int index) {
      final chat = state.chats[index];
      final nextChat =
          index == state.chats.length - 1 ? null : state.chats[index + 1];
      if (chat is! ChatEntity || nextChat is! ChatEntity) {
        return true;
      }
      return nextChat.user.id != chat.user.id;
    }

    if (index == state.chats.length) {
      return const Center(child: CupertinoActivityIndicator());
    }
    final chat = state.chats[index];
    if (chat is! ChatEntity) {
      if (chat is SystemMessageEntity) {
        return SystemMessage(message: chat);
      }
      if (chat is FofoChatEntity) {
        return FofoBubble(
          message: chat,
          onAction: (type) => _onAction(context, type),
        );
      }
      throw StateError('Unknown chat type');
    }
    final isMe = chat.user.id == AuthBloc.userOf(context)?.id;
    return ChatBubble(
      message: chat.message,
      isFirst: isFirst(index),
      user: isMe ? null : chat.user,
      pot: widget.pot,
    );
  }

  void _onAction(BuildContext context, FofoActionButtonType type) {
    switch (type) {
      case FofoActionButtonType.departureConfirm:
        _SetDepartureTimeButton.setDepartureTime(context, widget.pot);
        break;
      case FofoActionButtonType.accountingRequest:
        _AccountingButton.setAccounting(context, widget.pot);
        break;
      case FofoActionButtonType.accountingInfoCheck:
      case FofoActionButtonType.accountingProcess:
      case FofoActionButtonType.taxiCall:
        // TODO: implement these actions
        context.showToast('service is not available yet');
        break;
    }
  }
}

class _ChatInput extends StatefulWidget {
  const _ChatInput();

  @override
  State<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<_ChatInput> {
  final _controller = TextEditingController();
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _filled = _controller.text.isNotEmpty);
    });
  }

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
              colorFilter: ColorFilter.mode(
                _filled ? Palette.primary : Palette.grey,
                BlendMode.srcIn,
              ),
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
