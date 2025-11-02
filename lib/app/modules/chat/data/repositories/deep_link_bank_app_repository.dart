import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_accounting_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/bank_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/bank_app_repository.dart';
import 'package:url_launcher/url_launcher.dart';

@Injectable(as: BankAppRepository)
class DeepLinkBankAppRepository implements BankAppRepository {
  @override
  Future<void> sendMoney(
    BankAppType type,
    PotAccountingInfoEntity account,
  ) async {
    final deepLink = _getDeepLink(type, account);
    if (await canLaunchUrl(deepLink)) {
      await launchUrl(deepLink);
    } else {
      await launchUrl(_getStoreUrl(type));
    }
  }

  Uri _getDeepLink(BankAppType type, PotAccountingInfoEntity info) {
    switch (type) {
      case BankAppType.toss:
        return Uri(
          scheme: 'supertoss',
          host: 'send',
          queryParameters: {
            'amount': info.costPerUser.toString(),
            'accountNo': info.bankAccount,
            'bank': info.bankName,
          },
        );
      case BankAppType.clipboard:
        throw StateError('Clipboard is not supported');
    }
  }

  Uri _getStoreUrl(BankAppType type) {
    if (Platform.isAndroid) return Uri.parse(type.androidStoreUrl);
    return Uri.parse(type.iOSStoreUrl);
  }
}
