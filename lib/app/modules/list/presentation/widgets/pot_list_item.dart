import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_detail_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/general_dialog.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/modules/core/data/models/pot_detail_model.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/data/models/stop_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_summary_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/join_pot_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/pot_list_bloc.dart';
import 'package:pot_g/app/modules/list/presentation/bloc/pot_overview_bloc.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

class PotListItem extends StatelessWidget {
  const PotListItem({super.key, required this.pot});

  final PotSummaryEntity pot;

  Future<void> _onTap(BuildContext context) async {
    Widget field(String label, String value, {bool column = false}) {
      return Flex(
        direction: column ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment:
            column ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyles.title4.copyWith(color: Palette.dark)),
          const SizedBox(width: 8, height: 8),
          Text(value, style: TextStyles.body.copyWith(color: Palette.dark)),
        ],
      );
    }

    final result = await showGeneralOkCancelAdaptiveDialog(
      context: context,
      title: context.t.list.enter.title,
      child: BlocProvider(
        create:
            (context) =>
                sl<PotOverviewBloc>()..add(PotOverviewEvent.init(pot.id)),
        child: Column(
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
                  state.overview!.usersInfo.users.map((e) => e.name).join(', '),
                  column: true,
                );
              },
            ),
          ],
        ),
      ),
    );
    if (result != OkCancelResult.ok) return;
    if (!context.mounted) return;

    // JoinPotBloc을 사용하여 입장 처리
    await _joinPot(context);
  }

  Future<void> _joinPot(BuildContext context) async {
    final potListBloc = context.read<PotListBloc>();
    final potDetailBloc = context.read<PotDetailBloc>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => BlocProvider(
            create:
                (context) => sl<JoinPotBloc>()..add(JoinPotEvent.join(pot.id)),
            child: BlocListener<JoinPotBloc, JoinPotState>(
              listener: (context, state) {
                state.map(
                  initial: (_) {},
                  loading: (_) {},
                  success: (successState) {
                    potListBloc.add(PotListEvent.search());
                    potDetailBloc.add(const PotDetailEvent.loadMyPots());
                    Navigator.of(context).pop();
                    _navigateToChatRoom(context, successState.potId);
                  },
                  error: (errorState) {
                    Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
                    context.showToast(errorState.message);
                  },
                );
              },
              child: BlocBuilder<JoinPotBloc, JoinPotState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => const SizedBox.shrink(),
                    loading:
                        (_) => const Center(child: CircularProgressIndicator()),
                    success: (_) => const SizedBox.shrink(),
                    error: (_) => const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ),
    );
  }

  void _navigateToChatRoom(BuildContext context, String potId) {
    // PotSummaryEntity를 PotDetailModel로 변환
    final potDetail = PotDetailModel(
      id: pot.id,
      name: pot.name,
      route: RouteModel(
        id: pot.route.id,
        from: StopModel(id: pot.route.from.id, name: pot.route.from.name),
        to: StopModel(id: pot.route.to.id, name: pot.route.to.name),
      ),
      startsAt: pot.startsAt,
      endsAt: pot.endsAt,
      current: pot.current,
      total: pot.total,
      status: PotStatus.beforeConfirmed, // 기본값으로 beforeConfirmed 설정
    );

    // 채팅방으로 이동
    ChatRoomRoute(pot: potDetail).push(context);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = pot.current == pot.total;
    return PotPressable(
      onTap: disabled ? null : () => _onTap(context),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 1),
              blurRadius: 8,
              color: Color(0x14000000),
            ),
            BoxShadow(
              offset: Offset(1, 3),
              blurRadius: 8,
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              decoration: BoxDecoration(
                color: disabled ? Palette.white : Palette.lightGrey,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pot.name.substring(0, 2),
                    style: TextStyles.title3.copyWith(
                      color: disabled ? Palette.grey : Palette.textGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pot.name.substring(2),
                    style: TextStyles.description.copyWith(
                      color: disabled ? Palette.grey : Palette.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            CustomPaint(size: Size(1, 88), painter: _DashedLinePainter()),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.Md().add_E().format(pot.startsAt),
                          style: TextStyles.caption.copyWith(
                            color: disabled ? Palette.grey : Palette.textGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DefaultTextStyle.merge(
                          style: TextStyles.title1.copyWith(
                            color: disabled ? Palette.grey : Palette.dark,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(DateFormat.Hm().format(pot.startsAt)),
                              Text('~'),
                              Text(DateFormat.Hm().format(pot.endsAt)),
                              if (!pot.startsAt.isSameDay(pot.endsAt))
                                Text(
                                  'D+1',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0.66,
                                    letterSpacing: -0.025 * 12,
                                    color:
                                        disabled
                                            ? Palette.grey
                                            : Palette.textGrey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '${pot.current}/${pot.total}',
                      style: TextStyles.title1.copyWith(
                        color: disabled ? Palette.grey : Palette.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8, dashSpace = 8, startY = 0;
    final paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;
    canvas.clipRect(Offset.zero & size);
    canvas.save();
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, min(startY + dashWidth, size.height)),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
