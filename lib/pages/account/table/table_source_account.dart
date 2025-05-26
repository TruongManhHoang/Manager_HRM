import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/account/bloc/account_bloc.dart';

import 'package:admin_hrm/router/routers_name.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/colors.dart';

import '../../../utils/helpers/helper_functions.dart';

class TableSourceAccount extends DataTableSource {
  final BuildContext context;
  final List<AccountModel> accounts;

  TableSourceAccount(this.context, this.accounts);

  @override
  DataRow? getRow(int index) {
    final account = accounts[index];

    final globalStorage = getIt<GlobalStorage>();
    final employee = globalStorage.personalManagers!.firstWhere(
      (element) => element.id == account.employeeId,
    );

    TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: TColors.dark,
          fontWeight: FontWeight.w500,
        );

    TextStyle highlightStyle = baseStyle.copyWith(
      color: TColors.primary,
      fontWeight: FontWeight.w600,
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
        child: Center(child: Text(account.code, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(employee.name, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(account.email, style: highlightStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text('${account.password}', style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text('${account.role}', style: baseStyle)),
      )),
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: TSizes.xs),
            decoration: BoxDecoration(
              color: THelperFunctions.getContractStatusColor(account.status)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              account.status,
              style: baseStyle.copyWith(
                fontSize: 12,
                color: THelperFunctions.getStatusRewardColor(account.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                context.push(
                  RouterName.editAccount,
                  extra: account,
                );
              },
              icon: const Icon(Icons.edit),
              color: TColors.primary,
            ),
            const SizedBox(width: TSizes.xs),
            IconButton(
              onPressed: () {
                _confirmDelete(context, account);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => accounts.length;

  @override
  int get selectedRowCount => 0;

  void _confirmDelete(BuildContext context, AccountModel account) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text(
            'Bạn có chắc chắn muốn xoá tài khoản của "${account.id}" không?'),
        actions: [
          TextButton(
            child: const Text('Huỷ'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
            onPressed: () {
              context.read<AccountBloc>().add(DeleteAccount(account.id!));
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
