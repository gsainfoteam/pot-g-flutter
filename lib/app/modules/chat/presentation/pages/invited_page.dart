import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_detail_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/error_cover.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/list/domain/entities/pot_overview_entity.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/join_pot_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/pot_overview_bloc.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class InvitedPage extends StatelessWidget {
  const InvitedPage({super.key, @PathParam() required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<PotOverviewBloc>()..add(PotOverviewEvent.init(id)),
        ),
        BlocProvider(create: (context) => sl<JoinPotBloc>()),
      ],
      child: BlocListener<JoinPotBloc, JoinPotState>(
        listener: (context, state) {
          state.map(
            initial: (_) {},
            loading: (_) {},
            success: (successState) {
              context.router.popAndPush(ChatRoomRoute(id: successState.potId));
              context.read<PotDetailBloc>().add(PotDetailEvent.loadMyPots());
            },
            error: (errorState) {
              context.showToast(errorState.message);
            },
          );
        },
        child: _Layout(),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(title: Text(context.t.invited.title)),
      body: BlocBuilder<PotOverviewBloc, PotOverviewState>(
        builder: (context, state) {
          if (state.error != null) {
            return ErrorCover(message: state.error!);
          }
          if (state.overview == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _InvitedPageContent(pot: state.overview!);
        },
      ),
    );
  }
}

class _InvitedPageContent extends StatelessWidget {
  const _InvitedPageContent({required this.pot});

  final PotOverviewEntity pot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pot.name,
                    style: TextStyles.description.copyWith(
                      color: Palette.dark,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: context.t.list.enter.route,
                    value: pot.route.name,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: context.t.list.enter.date,
                    value: DateFormat.yMd().add_E().format(pot.startsAt),
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: context.t.list.enter.departure_time,
                    value:
                        '${DateFormat.Hm().format(pot.startsAt)}~${DateFormat.Hm().format(pot.endsAt)}',
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: context.t.list.enter.passengers,
                    value: pot.usersInfo.users
                        .where((u) => u.isInPot)
                        .map((u) => u.name)
                        .join(', '),
                  ),
                ],
              ),
            ),
            Spacer(),
            const SizedBox(height: 24),
            BlocBuilder<JoinPotBloc, JoinPotState>(
              builder: (context, state) {
                final isLoading = state.map(
                  initial: (_) => false,
                  loading: (_) => true,
                  success: (_) => false,
                  error: (_) => false,
                );
                final canJoin =
                    pot.usersInfo.users.where((u) => u.isInPot).length <
                    pot.usersInfo.total;

                return PotPressable(
                  onTap: isLoading || !canJoin
                      ? null
                      : () {
                          context.read<JoinPotBloc>().add(
                            JoinPotEvent.join(pot.id),
                          );
                        },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: canJoin && !isLoading
                          ? Palette.primary
                          : Palette.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading) ...[
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Palette.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          isLoading
                              ? context.t.invited.loading
                              : canJoin
                              ? context.t.invited.button
                              : context.t.invited.fulled,
                          style: TextStyles.description.copyWith(
                            color: Palette.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.caption.copyWith(color: Palette.textGrey),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyles.description.copyWith(color: Palette.dark),
        ),
      ],
    );
  }
}
