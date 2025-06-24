import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/kpi/kpi_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/department/bloc/department_bloc.dart';
import 'package:admin_hrm/pages/department/bloc/department_event.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_bloc.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_event.dart';
import 'package:admin_hrm/router/routers_name.dart';

import 'package:data_table_2/data_table_2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';

class KPITableRows extends DataTableSource {
  final BuildContext context;
  final List<KPIModel> kpis;

  KPITableRows(this.context, this.kpis);

  @override
  DataRow? getRow(int index) {
    final kpi = kpis[index];

    TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: TColors.dark,
          fontWeight: FontWeight.w500,
        );
    final formattedDate = DateFormat('dd/MM/yyyy').format(kpi.createdAt);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final globalStorage = getIt<GlobalStorage>();
    final user = globalStorage.personalManagers!.firstWhere(
      (u) => u.id == kpi.userId,
    );
    final department = globalStorage.departments!.firstWhere(
      (d) => d.id == kpi.departmentId,
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
        child: Center(child: Text(user.name, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child:
            Center(child: Text(kpi.metrics[0].name ?? '-', style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(department.name, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child:
                Text(currencyFormat.format(kpi.totalScore), style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(kpi.evaluatorId ?? '-', style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(kpi.notes ?? '-', style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(formattedDate, style: baseStyle)),
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              context.go(
                '/kpi-page/edit-kpi',
                extra: kpi,
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
                _confirmDelete(context, kpi);
              },
              child: const Icon(
                Iconsax.trash,
                color: Colors.red,
              ),
            ),
          ],
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => kpis.length;

  @override
  int get selectedRowCount => 0;

  void _confirmDelete(BuildContext context, KPIModel kpi) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content:
            Text('Bạn có chắc chắn muốn xoá kpi của "${kpi.userId}" không?'),
        actions: [
          TextButton(
            child: const Text('Huỷ'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<KPIBloc>().add(DeleteKPI(kpi.id));
            },
          ),
        ],
      ),
    );
  }
}
