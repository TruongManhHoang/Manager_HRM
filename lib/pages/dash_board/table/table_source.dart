import 'package:admin_hrm/pages/dash_board/data/model/order_data.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/containers/rounded_container.dart';
import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class DashboardOrderRows extends DataTableSource {
  final BuildContext context;
  DashboardOrderRows(this.context);
  @override
  DataRow? getRow(int index) {
    final order = DashBoardOrderData.orders[index];
    return DataRow2(cells: [
      DataCell(Text(
        order.id,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: TColors.primary),
      )),
      DataCell(Text(order.formattedOrderDate)),
      const DataCell(Text('5 item')),
      DataCell(TRoundedContainer(
        radius: TSizes.cardRadiusSm,
        padding: const EdgeInsets.symmetric(
            vertical: TSizes.xs, horizontal: TSizes.md),
        backgroundColor:
            THelperFunctions.getOrderStatusColor(order.status).withOpacity(0.1),
        child: Text(
          order.status.name.toString(),
          style: TextStyle(
              color: THelperFunctions.getOrderStatusColor(order.status)),
        ),
      )),
      DataCell(Text('\$ ${order.totalAmount.toStringAsFixed(2)}')),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => DashBoardOrderData.orders.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
