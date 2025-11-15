import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_pressable.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';
import 'package:pot_g/gen/strings.g.dart';

class Bubble extends StatelessWidget {
  const Bubble({
    super.key,
    required this.child,
    required this.isFirst,
    required this.isMe,
    required this.profileImage,
    required this.name,
    required this.sentAt,
    this.error,
    this.isPending = false,
    this.onResend,
  }) : assert(
         isMe || profileImage != null && name != null,
         'profileImage and name must be provided if not me',
       );

  final Widget child;
  final bool isFirst;
  final bool isMe;
  final Widget? profileImage;
  final String? name;
  final DateTime sentAt;
  final String? error;
  final bool isPending;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe && profileImage != null)
            isFirst ? profileImage! : const SizedBox(width: 40),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 240),
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe && isFirst) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      name ?? '',
                      style: TextStyles.description.copyWith(
                        color: Palette.textGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Stack(
                  children: [
                    if (isFirst)
                      Positioned(
                        left: isMe ? null : 0,
                        right: isMe ? 0 : null,
                        bottom: 0,
                        child: Transform.flip(
                          flipX: isMe,
                          child: Assets.icons.chatTip.svg(
                            colorFilter: ColorFilter.mode(
                              isMe ? Palette.primary : Palette.borderGrey,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Palette.primary : Palette.borderGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            child,
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.jm().format(sentAt),
                              style: TextStyles.description.copyWith(
                                color: Palette.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isPending) ...[
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                Icon(Icons.send, color: Palette.grey, size: 8),
              ],
            ),
          ],
          if (error != null) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PotPressable(
                  onTap: () async {
                    final result = await showOkCancelAlertDialog(
                      context: context,
                      title: context.t.chat_room.error.failed_to_send.title,
                      message:
                          context.t.chat_room.error.failed_to_send.description,
                      okLabel: context.t.chat_room.error.failed_to_send.resend,
                    );
                    if (result == OkCancelResult.ok) {
                      onResend?.call();
                    }
                  },
                  child: Icon(Icons.error, color: Palette.warning, size: 20),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
