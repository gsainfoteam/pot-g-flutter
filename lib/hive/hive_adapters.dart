import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pot_g/app/modules/core/data/models/api_channel_settings.dart';
import 'package:pot_g/app/modules/core/domain/enums/api_channel.dart';
import 'package:pot_g/app/modules/core/domain/enums/hidden_menu_level.dart';

@GenerateAdapters([
  AdapterSpec<HiddenMenuLevel>(),
  AdapterSpec<ApiChannel>(),
  AdapterSpec<ApiChannelSettings>(),
])
part 'hive_adapters.g.dart';
