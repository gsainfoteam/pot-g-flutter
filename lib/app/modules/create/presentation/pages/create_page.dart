import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';
import 'package:pot_g/app/modules/create/presentation/widgets/time_interval_selector.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(title: Text(context.t.create.title)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    _buildInfo(context),
                    const SizedBox(height: 32),
                    _buildCapacity(context),
                    const SizedBox(height: 32),
                    _buildTimeInterval(context),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: PotButton(
                onPressed: () {},
                variant: PotButtonVariant.emphasized,
                child: Text(context.t.create.action),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTimeInterval(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.t.create.time_interval.title, style: TextStyles.title4),
        const SizedBox(height: 4),
        Text(
          context.t.create.time_interval.description,
          style: TextStyles.caption,
        ),
        const SizedBox(height: 12),
        TimeIntervalSelector(),
      ],
    );
  }

  Column _buildCapacity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.t.create.capacity.title, style: TextStyles.title4),
        const SizedBox(height: 4),
        Text(context.t.create.capacity.description, style: TextStyles.caption),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 2; i <= 4; i++) ...[
              Expanded(
                child: PotButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  onPressed: () {},
                  size: PotButtonSize.medium,
                  child: Text(
                    context.t.create.capacity.fields.max_capacity.item(n: i),
                  ),
                ),
              ),
              if (i < 4) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }

  Column _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.t.create.info.title, style: TextStyles.title4),
        const SizedBox(height: 12),
        Text(
          context.t.create.info.fields.route.label,
          style: TextStyles.caption,
        ),
        const SizedBox(height: 4),
        const SizedBox(height: 12),
        Text(
          context.t.create.info.fields.date.label,
          style: TextStyles.caption,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
