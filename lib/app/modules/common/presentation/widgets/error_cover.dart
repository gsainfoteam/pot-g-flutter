import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/strings.g.dart';

class ErrorCover extends StatelessWidget {
  const ErrorCover({super.key, required this.message, this.onRefresh});

  final String message;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Palette.warning.withAlpha(10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Palette.warning.withAlpha(30), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/caution_fofo.svg',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Palette.warning,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRefresh != null) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: Text(context.t.common.refresh),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Palette.warning,
                    side: BorderSide(color: Palette.warning.withAlpha(100)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
