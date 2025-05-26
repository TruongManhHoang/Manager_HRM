import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/service/contract_service.dart';

class ContractRepository {
  final ContractService contractService;
  ContractRepository(this.contractService);
  Future<void> createContract(ContractModel contractModel) async {
    await contractService.addContract(contractModel);
  }

  Future<List<ContractModel>> getContracts() async {
    return await contractService.getContracts();
  }

  Future<void> updateContract(ContractModel contractModel) async {
    await contractService.updateContract(contractModel);
  }

  Future<void> deleteContract(String id) async {
    await contractService.deleteContract(id);
  }
}
