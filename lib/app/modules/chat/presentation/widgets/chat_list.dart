import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_action_button_type.dart';
import 'package:pot_g/app/modules/chat/domain/enums/taxi_app_type.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/chat_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/taxi_app_cubit.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/accounting_button.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/bubble.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_bubble.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/fofo_bubble.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/set_departure_time_button.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/system_message.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/gen/strings.g.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.pot});

  final PotInfoEntity pot;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      context.read<ChatBloc>().add(ChatLoadMore());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (!state.endReached && !state.isLoading) {
          _onScroll();
        }
      },
      builder: (context, state) {
        bool isLast(int index) {
          final chat = state.chats[index];
          final nextChat = index == state.chats.length - 1
              ? null
              : state.chats[index + 1];
          if (chat is! ChatEntity || nextChat is! ChatEntity) {
            return true;
          }
          return nextChat.user.id != chat.user.id;
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          reverse: true,
          padding: const EdgeInsets.all(12) - EdgeInsets.only(right: 6),
          separatorBuilder: (context, index) =>
              SizedBox(height: isLast(index) ? 12 : 6),
          itemBuilder: (context, index) => _buildItem(context, index, state),
          itemCount: state.chats.length + (state.isLoading ? 1 : 0),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index, ChatState state) {
    bool isFirst(int index) {
      final chat = state.chats[index];
      final nextChat = index == state.chats.length - 1
          ? null
          : state.chats[index + 1];
      if (chat is! ChatEntity || nextChat is! ChatEntity) {
        return true;
      }
      return nextChat.user.id != chat.user.id;
    }

    if (index == state.chats.length) {
      return const Center(child: CircularProgressIndicator.adaptive());
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
      if (chat is ChatEntityError) {
        return Bubble(
          isFirst: true,
          isMe: false,
          profileImage: SizedBox(),
          name: context.t.chat_room.error.header,
          child: Text('${chat.message}\n${context.t.chat_room.error.update}'),
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

  void _onAction(BuildContext context, FofoActionButtonType type) async {
    switch (type) {
      case FofoActionButtonType.departureConfirm:
        SetDepartureTimeButton.setDepartureTime(context, widget.pot);
        break;
      case FofoActionButtonType.accountingRequest:
        AccountingButton.setAccounting(context, widget.pot);
        break;
      case FofoActionButtonType.accountingInfoCheck:
        Scaffold.of(context).openEndDrawer();
        break;
      case FofoActionButtonType.taxiCall:
        final result = await showAlertDialog(
          context: context,
          title: context.t.chat_room.taxi_call.title,
          message: context.t.chat_room.taxi_call.description(
            route: widget.pot.route.name,
          ),
          actions: [
            for (var type in TaxiAppType.values)
              AlertDialogAction(
                key: type,
                label: context.t.chat_room.taxi_call.actions(context: type),
              ),
          ],
        );
        if (result == null || !context.mounted) return;
        context.read<TaxiAppCubit>().callTaxi(result, widget.pot.route);
        break;
      case FofoActionButtonType.accountingProcess:
        final accountingInfo = widget.pot.accountingInfo;
        if (!accountingInfo.accountingResults
            .map((e) => e.userPk)
            .contains(AuthBloc.userOf(context)?.id)) {
          showOkAlertDialog(
            context: context,
            title: context.t.chat_room.fofo.accounting.not_requested.title,
            message:
                context.t.chat_room.fofo.accounting.not_requested.description,
          );
          return;
        }
        final bank = '${accountingInfo.bankName} ${accountingInfo.bankAccount}';
        final result = await showAlertDialog(
          context: context,
          title: context.t.chat_room.send_money.title,
          message: context.t.chat_room.send_money.description(
            n: NumberFormat.decimalPattern().format(
              accountingInfo.totalCost ?? 0,
            ),
            account: bank,
          ),
          actions: [
            // AlertDialogAction(
            //   key: 'toss',
            //   label: context.t.chat_room.send_money.actions.toss,
            // ),
            // AlertDialogAction(
            //   key: 'kakao',
            //   label: context.t.chat_room.send_money.actions.kakao,
            // ),
            AlertDialogAction(
              key: 'clipboard',
              label: context.t.chat_room.send_money.actions.clipboard,
            ),
          ],
        );
        if (result == null) return;
        switch (result) {
          case 'toss':
          case 'kakao':
            break;
          case 'clipboard':
            Clipboard.setData(ClipboardData(text: bank));
            break;
        }
        break;
    }
  }
}
