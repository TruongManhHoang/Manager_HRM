import 'package:admin_hrm/common/widgets/containers/rounded_container.dart';
import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/contract/bloc/contract_bloc.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class TableContractRows extends DataTableSource {
  final BuildContext context;
  TableContractRows({required this.context, required this.contracts});
  List<ContractModel> contracts;

  @override
  DataRow? getRow(int index) {
    final globalStorage = getIt<GlobalStorage>();

    final contract = contracts[index];
    final personalManagers = globalStorage.personalManagers!;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    // 🔍 Tìm user theo employeeId
    final personal = personalManagers.firstWhere(
      (p) => p.id == contract.employeeId,
    );

    TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: TColors.dark,
          fontWeight: FontWeight.w500,
        );

    return DataRow2(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
          child: Text(
            '${index + 1}',
            style: baseStyle,
          ),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
          child: Text(contract.contractCode!, style: baseStyle),
        ),
      )),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(child: Text(personal.name, style: baseStyle)),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(child: Text(contract.contractType, style: baseStyle)),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(
              child: Text(currencyFormat.format(contract.salary),
                  style: baseStyle)),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(child: Text(contract.description, style: baseStyle)),
        ),
      ),
      DataCell(
        Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Center(
              child: Text(
                  THelperFunctions.getFormattedDate(contract.startDate!),
                  style: baseStyle),
            )),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(
            child: Text(THelperFunctions.getFormattedDate(contract.endDate!),
                style: baseStyle),
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: TSizes.xs),
            decoration: BoxDecoration(
              color: THelperFunctions.getContractStatusColor(contract.status!)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              contract.status!,
              style: baseStyle.copyWith(
                color:
                    THelperFunctions.getContractStatusColor(contract.status!),
              ),
            ),
          ),
        ),
      ),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  context.go(RouterName.editContract, extra: contract);
                },
                icon: const Icon(Icons.edit),
                color: TColors.primary,
              ),
              const SizedBox(width: TSizes.xs),
              IconButton(
                onPressed: () {
                  _confirmDelete(context, contract);
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ))
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => contracts.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  void _confirmDelete(BuildContext context, ContractModel contractModel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text(
            'Bạn có chắc chắn muốn xoá hợp đồng "${contractModel.contractCode}" không?'),
        actions: [
          TextButton(
            child: const Text('Huỷ'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<ContractBloc>()
                  .add(DeleteContract(contractModel.id!));
            },
          ),
        ],
      ),
    );
  }
}
