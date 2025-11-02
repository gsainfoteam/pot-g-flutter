import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_accounting_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/bank_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/bank_app_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

@injectable
class BankAppCubit extends Cubit<void> {
  final BankAppRepository _repository;
  BankAppCubit(this._repository) : super(null);

  Future<void> sendMoney(
    BankAppType type,
    PotAccountingInfoEntity account,
  ) async {
    try {
      await _repository.sendMoney(type, account);
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
    }
  }
}
