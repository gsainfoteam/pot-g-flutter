import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/repositories/deep_link_repository.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_accounting_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/bank_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/bank_app_repository.dart';

@Injectable(as: BankAppRepository)
class DeepLinkBankAppRepository
    extends DeepLinkRepository<BankAppType, PotAccountingInfoEntity>
    implements BankAppRepository {
  @override
  Uri getDeepLink(BankAppType type, PotAccountingInfoEntity info) {
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
    }
  }
}
