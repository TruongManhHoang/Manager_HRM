import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/salary/salary_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/salary/bloc/salary_bloc.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';

class TableSourceSalary extends DataTableSource {
  final BuildContext context;
  final List<SalaryModel> salaries;

  TableSourceSalary(this.context, this.salaries);

  @override
  DataRow? getRow(int index) {
    final salary = salaries[index];
    final globalStorage = getIt<GlobalStorage>();
    final employee = globalStorage.personalManagers!.firstWhere(
      (e) => e.id == salary.employeeId,
    );
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final formatDate = DateFormat('dd/MM/yyyy');
    TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: TColors.dark,
          fontSize: 16,
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
        child: Center(child: Text(salary.code ?? '-', style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(employee.name, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(currencyFormat.format(salary.baseSalary),
                style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(salary.attendanceBonus.toString(), style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(currencyFormat.format(salary.rewardBonus),
                style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(currencyFormat.format(salary.disciplinaryDeduction),
                style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child:
                Text(currencyFormat.format(salary.kpiBonus), style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(currencyFormat.format(salary.totalSalary),
                style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(formatDate.format(salary.payDate!), style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                context.pushNamed(
                  RouterName.editSalary,
                  extra: salary,
                );
              },
              icon: const Icon(Iconsax.edit),
              color: TColors.primary,
            ),
            const SizedBox(width: TSizes.xs),
            if (globalStorage.role?.toLowerCase().trim() == 'admin') ...[
              const Gap(10),
              GestureDetector(
                onTap: () {
                  _confirmDelete(context, salary);
                },
                child: const Icon(
                  Iconsax.trash,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => salaries.length;

  @override
  int get selectedRowCount => 0;

  void _confirmDelete(BuildContext context, SalaryModel salary) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content:
            Text('Bạn có chắc chắn muốn xoá phòng ban "${salary.code}" không?'),
        actions: [
          TextButton(
            child: const Text('Huỷ'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<SalaryBloc>().add(DeleteSalary(salary.id!));
            },
          ),
        ],
      ),
    );
  }
}
