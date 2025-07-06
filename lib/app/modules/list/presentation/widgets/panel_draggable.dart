import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_g_bottom_sheet.dart';

class PanelDraggable extends StatefulWidget {
  const PanelDraggable({super.key, required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  PanelDraggableState createState() => PanelDraggableState();
}

class PanelDraggableState extends State<PanelDraggable> {
  ScrollController scrollController = ScrollController();
  double containerSize = 36;
  late double margin = containerSize;
  double unlockScroll = 0;
  double? previousOffset;
  bool lock = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => scrollController.jumpTo(scrollController.position.maxScrollExtent),
    ); //put the panel in closed position
  }

  Future<void> waitAndUpdate() async {
    //Wait for the ScrollPhysics to stop before updating the scrollarea
    //(I maybe need to change the scrollphysics's speed if some users play around quickly)
    if (lock) return;
    lock = true;
    Future.doWhile(() async {
      if (previousOffset == scrollController.offset) {
        updateScrollArea(null);
        lock = false;
        return false;
      }
      previousOffset = scrollController.offset;
      await Future.delayed(Duration(milliseconds: 40));
      return true;
    });
  }

  void updateScrollArea(double? dimension) {
    if (dimension != null) {
      setState(() {
        containerSize = dimension - 1;
        unlockScroll = 1;
      });
    } else {
      //Lower the view port
      setState(() => containerSize = margin);
      //callback after the frame built
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() {
          containerSize =
              scrollController.position.maxScrollExtent -
              scrollController.offset +
              margin;

          //If it reached max (can't be scrolled since its useless), add 1px and update
          if (containerSize ==
              scrollController.position.maxScrollExtent + margin) {
            unlockScroll = 1;
            containerSize =
                scrollController.position.maxScrollExtent + margin - 1;
          }
        }),
      );
    }
  }

  void notified() {
    updateScrollArea(
      (scrollController.position.maxScrollExtent > 0)
          ? scrollController.position.maxScrollExtent +
              scrollController.position.viewportDimension
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          onPointerUp: (_) => waitAndUpdate(),
          onPointerDown: (_) => setState(() => containerSize = margin),
          child: SizedBox(
            height: containerSize,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              controller: scrollController,
              clipBehavior: Clip.none,
              reverse: true,
              child: Column(
                children: [
                  Container(height: unlockScroll),
                  NotificationListener(
                    onNotification: (
                      SizeChangedLayoutNotification notification,
                    ) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => notified(),
                      );
                      return true;
                    },
                    child: SizeChangedLayoutNotifier(
                      child: PotGBottomSheet(
                        smallPadding: true,
                        child: widget.builder(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
