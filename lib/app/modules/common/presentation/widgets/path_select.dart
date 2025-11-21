import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/select.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class PathSelect extends StatelessWidget {
  const PathSelect({
    super.key,
    required this.routes,
    this.selectedRoute,
    required this.onSelected,
    required this.isOpen,
    required this.onOpenChanged,
    this.showAll = true,
  });

  final List<RouteEntity> routes;
  final RouteEntity? selectedRoute;
  final void Function(RouteEntity?) onSelected;
  final bool isOpen;
  final void Function(bool) onOpenChanged;
  final bool showAll;

  @override
  Widget build(BuildContext context) {
    final allOptionTitle = showAll ? context.t.list.filters.route.all : null;
    return Select<RouteEntity>(
      items: routes,
      selectedItem: selectedRoute,
      onSelected: onSelected,
      isOpen: isOpen,
      onOpenChanged: onOpenChanged,
      placeholder: Text(context.t.list.filters.route.all),
      itemBuilder: (context, route, selected) {
        if (route == null) {
          return _Selector(title: allOptionTitle!, selected: selected);
        }
        return _Selector(title: route.name, selected: selected);
      },
      selectedItemBuilder: (context, route) =>
          _Selector(title: route.name, selected: false),
      onCleared: showAll
          ? () {
              onOpenChanged(false);
              onSelected(null);
            }
          : null,
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({required this.title, this.selected = false});

  final String title;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
