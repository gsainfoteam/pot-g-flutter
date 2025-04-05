import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_app_bar.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/modules/main/presentation/widgets/date_select.dart';
import 'package:pot_g/app/modules/main/presentation/widgets/path_select.dart';
import 'package:pot_g/app/modules/main/presentation/widgets/pot_list_item.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/gen/assets.gen.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PotAppBar(
        actions: [
          PotIconButton(icon: Assets.icons.addPot.svg(), onPressed: () {}),
          PotIconButton(icon: Assets.icons.userCircle.svg(), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              color: Palette.white,
              child: Column(
                children: [
                  PathSelect(routes: [], onSelected: (_) {}),
                  const SizedBox(height: 15),
                  _Date(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Palette.lightGrey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      children: [
                        PotListItem(),
                        const SizedBox(height: 15),
                        PotListItem(),
                        const SizedBox(height: 15),
                        PotListItem(),
                        const SizedBox(height: 15),
                        PotListItem(),
                        const SizedBox(height: 15),
                        PotListItem(),
                        const SizedBox(height: 15),
                        PotListItem(),
                        const SizedBox(height: 15),
                        PotListItem(),
                        const SizedBox(height: 15),
                        PotListItem(),
                        const SizedBox(height: 15),
                        PotListItem(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Date extends StatefulWidget {
  const _Date();

  @override
  State<_Date> createState() => _DateState();
}

class _DateState extends State<_Date> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return DateSelect(
      selectedDate: _selectedDate,
      onSelected: (date) => setState(() => _selectedDate = date),
    );
  }
}
