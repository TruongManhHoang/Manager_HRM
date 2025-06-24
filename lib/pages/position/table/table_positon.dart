import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/position/bloc/position_bloc.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class TablePositionRows extends DataTableSource {
  final BuildContext context;
  TablePositionRows({required this.context, required this.positions});
  List<PositionModel> positions;
  @override
  DataRow? getRow(int index) {
    TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: TColors.dark,
          fontWeight: FontWeight.w500,
        );
    final globalStorage = getIt<GlobalStorage>();
    final position = positions[index];
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
          child: Text(position.code!, style: baseStyle),
        ),
      )),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(child: Text(position.positionType!, style: baseStyle)),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(child: Text(position.name!, style: baseStyle)),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(
              child: Text('${position.positionSalary}', style: baseStyle)),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child:
              Center(child: Text('${position.description}', style: baseStyle)),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(
            child: Text(
              THelperFunctions.getFormattedDate(position.createdAt!),
              style: baseStyle,
            ),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Center(
            child: Text(
              THelperFunctions.getFormattedDate(position.updatedAt!),
              style: baseStyle,
            ),
          ),
        ),
      ),
      DataCell(Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                context.go('/position-page/edit-position', extra: position);
              },
              icon: const Icon(Iconsax.edit),
              color: TColors.primary,
            ),
            const SizedBox(width: TSizes.xs),
            if (globalStorage.role?.toLowerCase().trim() == 'admin') ...[
              const Gap(10),
              GestureDetector(
                onTap: () {
                  _confirmDelete(context, position);
                },
                child: const Icon(
                  Iconsax.trash,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ))
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => positions.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  void _confirmDelete(BuildContext context, PositionModel positionModel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text(
            'Bạn có chắc chắn muốn xoá chức vụ "${positionModel.code}" không?'),
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
                  .read<PositionBloc>()
                  .add(DeletePosition(positionModel.id!));
            },
          ),
        ],
      ),
    );
  }
}
