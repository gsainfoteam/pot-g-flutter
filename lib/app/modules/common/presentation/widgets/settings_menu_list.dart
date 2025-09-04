import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

class SettingsMenuList extends StatelessWidget {
  const SettingsMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _SettingsMenuItem(
            title: '정산 계좌 설정',
            onTap: () {
              // TODO: 정산 계좌 설정 페이지로 이동
            },
          ),
          _Divider(),
          _SettingsMenuItem(
            title: '알림 설정',
            onTap: () {
              // TODO: 알림 설정 페이지로 이동
            },
          ),
          _Divider(),
          _SettingsMenuItem(
            title: '계정 설정',
            onTap: () {
              // TODO: 계정 설정 페이지로 이동
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _SettingsMenuItem extends StatelessWidget {
  const _SettingsMenuItem({
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyles.title4.copyWith(color: Palette.dark)),
            SvgPicture.asset(
              'assets/icons/nav_arrow_right.svg',
              width: 28,
              height: 28,
              colorFilter: const ColorFilter.mode(
                Palette.dark,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Palette.borderGrey,
    );
  }
}
