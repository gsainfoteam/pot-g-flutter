import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class PathSelect extends StatefulWidget {
  const PathSelect({
    super.key,
    required this.routes,
    this.selectedRoute,
    required this.onSelected,
    required this.isOpen,
    required this.onOpenChanged,
  });

  final List<RouteEntity> routes;
  final RouteEntity? selectedRoute;
  final void Function(RouteEntity?) onSelected;
  final bool isOpen;
  final void Function(bool) onOpenChanged;

  @override
  State<PathSelect> createState() => _PathSelectState();
}

class _PathSelectState extends State<PathSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.white,
        border: Border.all(
          width: 1.5,
          color:
              widget.isOpen
                  ? Palette.primary
                  : widget.selectedRoute == null
                  ? Palette.borderGrey
                  : Palette.dark,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child:
          widget.isOpen
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Selector(
                    title: '전체 노선',
                    onSelected: () {
                      widget.onOpenChanged(false);
                      widget.onSelected(null);
                    },
                  ),
                  ...widget.routes.map(
                    (route) => _Selector(
                      title: route.toString(),
                      selected: widget.selectedRoute == route,
                      onSelected: () {
                        widget.onOpenChanged(false);
                        widget.onSelected(route);
                      },
                    ),
                  ),
                ],
              )
              : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => widget.onOpenChanged(true),
                child: Container(
                  height: 48,
                  padding: EdgeInsets.all(10) + EdgeInsets.only(left: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '전체 노선',
                          style: TextStyles.body.copyWith(
                            color: Palette.textGrey,
                          ),
                        ),
                      ),
                      Assets.icons.navArrowDown.svg(
                        colorFilter: ColorFilter.mode(
                          Palette.dark,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({
    this.selected = false,
    required this.title,
    required this.onSelected,
  });

  final bool selected;
  final String title;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelected,
      child: Container(
        height: 48,
        padding: EdgeInsets.all(10) + EdgeInsets.only(left: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyles.body.copyWith(
                color: selected ? Palette.primary : Palette.textGrey,
              ),
            ),
            if (selected)
              Assets.icons.check.svg(
                colorFilter: ColorFilter.mode(Palette.primary, BlendMode.srcIn),
              ),
          ],
        ),
      ),
    );
  }
}
