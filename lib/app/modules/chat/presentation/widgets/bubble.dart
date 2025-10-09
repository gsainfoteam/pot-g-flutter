import 'package:flutter/material.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class Bubble extends StatelessWidget {
  const Bubble({
    super.key,
    required this.child,
    required this.isFirst,
    required this.isMe,
    required this.profileImage,
    required this.name,
  }) : assert(
         isMe || profileImage != null && name != null,
         'profileImage and name must be provided if not me',
       );

  final Widget child;
  final bool isFirst;
  final bool isMe;
  final Widget? profileImage;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe && profileImage != null)
          isFirst ? profileImage! : const SizedBox(width: 40),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 240),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                      child: child,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
