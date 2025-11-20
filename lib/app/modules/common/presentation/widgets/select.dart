import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class Select<T> extends StatefulWidget {
  const Select({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onSelected,
    required this.isOpen,
    required this.onOpenChanged,
    required this.itemTitle,
    required this.placeholder,
    required this.openItemBuilder,
    required this.closedItemBuilder,
    this.onCleared,
  });

  final List<T> items;
  final T? selectedItem;
  final void Function(T?) onSelected;
  final bool isOpen;
  final void Function(bool) onOpenChanged;
  final String Function(T) itemTitle;
  final String placeholder;
  final Widget Function(BuildContext, T?, bool) openItemBuilder;
  final Widget Function(BuildContext, T) closedItemBuilder;
  final VoidCallback? onCleared;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.white,
        border: Border.all(width: 1, color: Palette.borderGrey),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: AnimatedCrossFade(
        crossFadeState: widget.isOpen
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 200),
        firstChild: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              [
                    if (widget.onCleared != null)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          widget.onOpenChanged(false);
                          widget.onCleared?.call();
                        },
                        child: widget.openItemBuilder(
                          context,
                          null,
                          widget.selectedItem == null,
                        ),
                      ),
                    ...widget.items.map((item) {
                      final selected = widget.selectedItem == item;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          widget.onOpenChanged(false);
                          widget.onSelected(item);
                        },
                        child: widget.openItemBuilder(context, item, selected),
                      );
                    }),
                  ]
                  .expandIndexed(
                    (index, child) => [
                      if (index != 0)
                        Container(height: 1, color: Palette.borderGrey),
                      child,
                    ],
                  )
                  .toList(),
        ),
        secondChild: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.onOpenChanged(true),
          child: widget.selectedItem != null
              ? Row(
                  children: [
                    Expanded(
                      child: widget.closedItemBuilder(
                        context,
                        widget.selectedItem as T,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Assets.icons.navArrowDown.svg(
                        colorFilter: ColorFilter.mode(
                          Palette.dark,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.placeholder,
                          style: TextStyles.description.copyWith(
                            color: Palette.grey,
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
      ),
    );
  }
}
