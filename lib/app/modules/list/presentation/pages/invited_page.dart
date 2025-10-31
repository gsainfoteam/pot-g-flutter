import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_detail_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/general_dialog.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/join_pot_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/pot_list_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/pot_overview_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/extensions/join_pot_exception.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class InvitedPage extends StatefulWidget {
  const InvitedPage({super.key, @PathParam() required this.id});

  final String id;

  @override
  State<InvitedPage> createState() => _InvitedPageState();
}

class _InvitedPageState extends State<InvitedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showAlert(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

  Future<void> _showAlert(BuildContext context) async {
    Widget field(String label, String value, {bool column = false}) {
      final box = FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          style: TextStyles.body.copyWith(color: Palette.dark),
          textAlign: TextAlign.start,
        ),
      );
      return Flex(
        direction: column ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: column
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyles.title4.copyWith(color: Palette.dark)),
          const SizedBox(width: 8, height: 8),
          if (column) box else Expanded(child: box),
        ],
      );
    }

    final result = await showGeneralOkCancelAdaptiveDialog(
      context: context,
      title: context.t.list.enter.title,
      child: BlocProvider(
        create: (context) =>
            sl<PotOverviewBloc>()..add(PotOverviewEvent.init(widget.id)),
        child: BlocBuilder<PotOverviewBloc, PotOverviewState>(
          builder: (context, state) {
            final pot = state.overview;
            if (pot == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                field(context.t.list.enter.route, pot.route.name),
                const SizedBox(height: 12),
                field(
                  context.t.list.enter.date,
                  DateFormat.yMd().add_E().format(pot.startsAt),
                ),
                const SizedBox(height: 12),
                field(
                  context.t.list.enter.departure_time,
                  '${DateFormat.Hm().format(pot.startsAt)}~${DateFormat.Hm().format(pot.endsAt)}',
                ),
                const SizedBox(height: 20),
                BlocBuilder<PotOverviewBloc, PotOverviewState>(
                  builder: (context, state) {
                    if (state.overview == null) return const SizedBox.shrink();
                    return field(
                      context.t.list.enter.passengers,
                      state.overview!.usersInfo.users
                          .map((e) => e.name)
                          .join(', '),
                      column: true,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
    if (result != OkCancelResult.ok) return;
    if (!context.mounted) return;

    await _joinPot(context);
  }

  Future<void> _joinPot(BuildContext context) async {
    final potListBloc = context.read<PotListBloc>();
    final potDetailBloc = context.read<PotDetailBloc>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlocProvider(
        create: (context) =>
            sl<JoinPotBloc>()..add(JoinPotEvent.join(widget.id)),
        child: BlocListener<JoinPotBloc, JoinPotState>(
          listener: (context, state) {
            state.map(
              initial: (_) {},
              loading: (_) {},
              success: (successState) {
                potListBloc.add(PotListEvent.search());
                potDetailBloc.add(const PotDetailEvent.loadMyPots());
                Navigator.of(context).pop();
                ChatRoomRoute(id: successState.potId).push(context);
              },
              error: (errorState) {
                Navigator.of(context).pop();
                context.showToast(errorState.err.getErrorMessage(context));
              },
            );
          },
          child: BlocBuilder<JoinPotBloc, JoinPotState>(
            builder: (context, state) {
              return state.map(
                initial: (_) => const SizedBox.shrink(),
                loading: (_) =>
                    const Center(child: CircularProgressIndicator()),
                success: (_) => const SizedBox.shrink(),
                error: (_) => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
    );
  }
}
