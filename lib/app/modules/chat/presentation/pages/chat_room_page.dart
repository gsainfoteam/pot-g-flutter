import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/chat_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_accounting_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_action_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_action_exception.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/accounting_button.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_input.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_list.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_room_drawer.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/set_departure_time_button.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/status_banner.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/error_cover.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_id_entity.dart';
import 'package:pot_g/app/modules/socket/presentation/bloc/socket_auth_bloc.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/strings.g.dart';

class _PotId implements PotIdEntity {
  _PotId({required this.id});
  @override
  final String id;
}

@RoutePage()
class ChatRoomPage extends StatelessWidget with LogPage {
  const ChatRoomPage({super.key, @PathParam() required this.id});

  @override
  String get pageName => 'chatRoom';

  final String id;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ChatBloc>()),
        BlocProvider(
          create: (context) =>
              sl<PotInfoBloc>()..add(PotInfoEvent.init(_PotId(id: id))),
        ),
        BlocProvider(create: (context) => sl<PotActionBloc>()),
        BlocProvider(create: (context) => sl<PotAccountingBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PotInfoBloc, PotInfoState>(
            listenWhen: (prev, curr) =>
                prev.pot?.id != curr.pot?.id && curr.pot != null,
            listener: (context, state) =>
                context.read<ChatBloc>().add(ChatInit(state.pot!)),
          ),
          BlocListener<ChatBloc, ChatState>(
            listenWhen: (prev, curr) =>
                prev.error != curr.error && curr.error != null,
            listener: (context, state) => context.showToast(state.error!),
          ),
          BlocListener<PotActionBloc, PotActionState>(
            listener: (context, state) {
              state.mapOrNull(
                departureTimeError: (e) => context.showToast(
                  '${e.err.getErrorMessage(context)} (${e.errorId})',
                ),
                leavePotError: (e) => context.showToast(
                  '${e.err.getErrorMessage(context)} (${e.errorId})',
                ),
                kickUserError: (e) => context.showToast(
                  '${e.err.getErrorMessage(context)} (${e.errorId})',
                ),
              );
            },
          ),
          BlocListener<SocketAuthBloc, SocketAuthState>(
            listenWhen: (prev, curr) =>
                prev.mapOrNull(reconnecting: (_) => true) == true &&
                curr.mapOrNull(connected: (_) => true) == true,
            listener: (context, state) {
              final pot = context.read<PotInfoBloc>().state.pot;
              if (pot == null) return;
              context.read<ChatBloc>().add(ChatEvent.init(pot));
            },
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
    final disabled = state.isArchived;
    return Scaffold(
      backgroundColor: disabled ? const Color(0xfff0f0f0) : null,
      appBar: PotAppBar(title: Text(pot.name)),
      onEndDrawerChanged: (value) {
        if (value) {
          L.c('sidebar');
        }
      },
      endDrawer: ChatRoomDrawer(pot: pot),
      body: Column(
        children: [
          BlocBuilder<SocketAuthBloc, SocketAuthState>(
            builder: (context, socketState) {
              return _buildConnectionBanner(context, socketState);
            },
          ),
          Expanded(child: ChatList(pot: pot)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  SetDepartureTimeButton(pot: pot),
                  AccountingButton(pot: pot),
                  Expanded(child: ChatInput()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionBanner(BuildContext context, SocketAuthState state) {
    return state.mapOrNull(
          reconnecting: (_) => StatusBanner(
            color: Colors.orange,
            child: Text(t.chat_room.connection.reconnecting),
          ),
          failed: (_) => StatusBanner(
            icon: const Icon(Icons.wifi_off, color: Colors.white, size: 16),
            color: Palette.warning,
            action: TextButton(
              onPressed: () {
                context.read<SocketAuthBloc>().add(
                  const SocketAuthEvent.retry(),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(t.chat_room.connection.retry),
            ),
            child: Text(t.chat_room.connection.failed),
          ),
        ) ??
        const SizedBox.shrink();
  }
}
