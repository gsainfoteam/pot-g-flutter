import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/bank_app_cubit.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/chat_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_accounting_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_action_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_detail_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/taxi_app_cubit.dart';
import 'package:pot_g/app/modules/chat/presentation/extensions/pot_action_exception.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/accounting_button.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_input.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_list.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_room_banner.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/chat_room_drawer.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/set_departure_time_button.dart';
import 'package:pot_g/app/modules/chat/presentation/widgets/status_banner.dart';
import 'package:pot_g/app/modules/common/presentation/bloc/tooltip_cubit.dart';
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

  @override
  Map<String, Object> get pageProperties => {'potId': id};

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
        BlocProvider(create: (context) => sl<TaxiAppCubit>()),
        BlocProvider(create: (context) => sl<BankAppCubit>()),
        BlocProvider(create: (context) => sl<TooltipCubit>()),
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
                success: (_) => context.read<PotDetailBloc>().add(
                  const PotDetailEvent.loadMyPots(),
                ),
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
          BlocListener<BankAppCubit, BankAppState>(
            listener: (context, state) {
              state.mapOrNull(
                error: (e) => context.showToast(
                  '${t.common.unknown_error} (${e.errorId})',
                ),
              );
            },
          ),
          BlocListener<TaxiAppCubit, TaxiAppState>(
            listener: (context, state) {
              state.mapOrNull(
                error: (e) => context.showToast(
                  '${t.common.unknown_error} (${e.errorId})',
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<PotInfoBloc, PotInfoState>(
          builder: (context, state) {
            if (state.error != null) {
              return ErrorCover(
                message: state.error!,
                onRefresh: () {
                  context.read<PotInfoBloc>().add(
                    PotInfoEvent.init(_PotId(id: id)),
                  );
                },
              );
            }
            if (state.pot == null) {
              return Scaffold(
                body: const Center(child: CircularProgressIndicator()),
              );
            }
            return _Layout(pot: state.pot!);
          },
        ),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout({required this.pot});

  final PotInfoEntity pot;

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!context.read<SocketAuthBloc>().state.isConnected) {
      context.read<SocketAuthBloc>().add(const SocketAuthEvent.connect());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final chatState = context.read<ChatBloc>().state;
      if (!chatState.isLoading) {
        context.read<ChatBloc>().add(ChatEvent.init(widget.pot));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.pot.isArchived;
    final banner = _buildBanner(context, widget.pot);
    return Scaffold(
      backgroundColor: disabled ? const Color(0xfff0f0f0) : null,
      appBar: PotAppBar(title: Text(widget.pot.name)),
      onEndDrawerChanged: (value) {
        if (value) {
          L.c(
            'sidebar',
            properties: {'potId': widget.pot.id, 'potName': widget.pot.name},
          );
        }
      },
      endDrawer: ChatRoomDrawer(pot: widget.pot),
      body: Column(
        children: [
          BlocBuilder<SocketAuthBloc, SocketAuthState>(
            builder: (context, socketState) {
              return _buildConnectionBanner(context, socketState);
            },
          ),
          Expanded(
            child: Stack(
              children: [
                ChatList(pot: widget.pot),
                if (banner != null)
                  Positioned(top: 20, left: 20, right: 20, child: banner),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  SetDepartureTimeButton(pot: widget.pot),
                  AccountingButton(pot: widget.pot),
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
    return switch (state) {
      SocketDisconnected() || SocketFailed() => StatusBanner(
        icon: const Icon(Icons.wifi_off, color: Colors.white, size: 16),
        color: Palette.warning,
        action: TextButton(
          onPressed: () {
            context.read<SocketAuthBloc>().add(const SocketAuthEvent.retry());
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(t.chat_room.connection.retry),
        ),
        child: Text(
          state is SocketFailed
              ? t.chat_room.connection.failed
              : t.chat_room.connection.disconnected,
        ),
      ),
      SocketReconnecting() => StatusBanner(
        color: Colors.orange,
        child: Text(t.chat_room.connection.reconnecting),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget? _buildBanner(BuildContext context, PotInfoEntity pot) {
    if (pot.status > PotStatus.waitAccounting) return null;
    if (pot.status == PotStatus.waitAccounting) {
      return ChatRoomBanner(
        important: true,
        message: context.t.chat_room.banner.notAccountingDone,
      );
    }
    final departureTime = pot.departureTime;
    if (departureTime == null) return null;
    final tenMinutesAfterDeparture = departureTime.add(
      const Duration(minutes: 10),
    );
    if (DateTime.now().isAfter(tenMinutesAfterDeparture)) {
      return ChatRoomBanner(
        important: true,
        message: context.t.chat_room.banner.notAccountingStarted,
      );
    }
    return ChatRoomBanner(
      message: context.t.chat_room.banner.confirmed(
        time: DateFormat.jm().format(departureTime),
      ),
    );
  }
}
