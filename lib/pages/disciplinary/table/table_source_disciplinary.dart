import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_bloc.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_event.dart';

import 'package:admin_hrm/router/routers_name.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';

import '../../../utils/helpers/helper_functions.dart';

class DisciplinaryTableRows extends DataTableSource {
  final BuildContext context;
  final List<DisciplinaryModel> disciplinarys;

  DisciplinaryTableRows(this.context, this.disciplinarys);

  @override
  DataRow? getRow(int index) {
    final disciplinary = disciplinarys[index];
    final globalStorage = getIt<GlobalStorage>();
    final personal = globalStorage.personalManagers!
        .firstWhere((element) => element.id == disciplinary.employeeId);
    TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: TColors.dark,
          fontWeight: FontWeight.w500,
        );
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
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
        child: Center(child: Text(disciplinary.code, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(personal.name, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(disciplinary.disciplinaryType, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(disciplinary.reason, style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(
            child: Text(currencyFormat.format(disciplinary.disciplinaryValue),
                style: baseStyle)),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Center(child: Text(disciplinary.severity, style: baseStyle)),
      )),
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: TSizes.xs),
            decoration: BoxDecoration(
              color: THelperFunctions.getStatusRewardColor(disciplinary.status)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              disciplinary.status,
              style: baseStyle.copyWith(
                fontSize: 12,
                color:
                    THelperFunctions.getStatusRewardColor(disciplinary.status),
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
                final result = await context.pushNamed(
                  RouterName.editDisciplinary,
                  extra: disciplinary,
                );
                if (result == true) {
                  context.read<DisciplinaryBloc>().add(LoadDisciplinary());
                }
              },
              icon: const Icon(Iconsax.edit),
              color: TColors.primary,
            ),
            const SizedBox(width: TSizes.xs),
            IconButton(
              onPressed: () {
                _confirmDelete(context, disciplinary);
              },
              icon: const Icon(Iconsax.trash),
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
  int get rowCount => disciplinarys.length;

  @override
  int get selectedRowCount => 0;

  void _confirmDelete(BuildContext context, DisciplinaryModel reward) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text(
            'Bạn có chắc chắn muốn xoá kỷ luật của "${reward.code}" không?'),
        actions: [
          TextButton(
            child: const Text('Huỷ'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
            onPressed: () {
              context
                  .read<DisciplinaryBloc>()
                  .add(DeleteDisciplinary(reward.id!));
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
