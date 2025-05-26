import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/salary/salary_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';

class TableSourceSalaryEmployee extends DataTableSource {
  final BuildContext context;
  final List<SalaryModel> salaries;

  TableSourceSalaryEmployee(this.context, this.salaries);

  @override
  DataRow? getRow(int index) {
    final salary = salaries[index];
    final format = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
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
        child: Center(child: Text(salary.code ?? '-', style: baseStyle)),
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
        child: Center(child: Text(salary.approvedBy, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(format.format(salary.payDate!), style: baseStyle)),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => salaries.length;

  @override
  int get selectedRowCount => 0;
}
