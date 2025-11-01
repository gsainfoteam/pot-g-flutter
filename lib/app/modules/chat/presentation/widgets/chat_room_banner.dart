import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class ChatRoomBanner extends StatefulWidget {
  const ChatRoomBanner({
    super.key,
    this.important = false,
    required this.message,
  });

  final bool important;
  final String message;

  @override
  State<ChatRoomBanner> createState() => _ChatRoomBannerState();
}

class _ChatRoomBannerState extends State<ChatRoomBanner> {
  bool _collapsed = false;

  @override
  void didUpdateWidget(ChatRoomBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.important && _collapsed) {
      _collapsed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_collapsed) {
      return PotPressable(
        onTap: () => setState(() => _collapsed = false),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Palette.borderGrey),
            ),
            child: Assets.icons.bell.svg(
              colorFilter: ColorFilter.mode(
                widget.important ? Palette.warning : Palette.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
    }
    return PotPressable(
      onTap: widget.important ? null : () => setState(() => _collapsed = true),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Palette.borderGrey),
        ),
        child: Row(
          children: [
            Assets.icons.bell.svg(
              colorFilter: ColorFilter.mode(
                widget.important ? Palette.warning : Palette.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.message,
                style: TextStyles.body.copyWith(color: Palette.textGrey),
              ),
            ),
            if (!widget.important) ...[
              const SizedBox(width: 8),
              Assets.icons.navArrowUp.svg(
                colorFilter: ColorFilter.mode(Palette.grey, BlendMode.srcIn),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
