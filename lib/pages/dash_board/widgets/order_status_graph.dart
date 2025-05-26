import 'package:admin_hrm/common/widgets/containers/circular_container.dart';
import 'package:admin_hrm/common/widgets/containers/rounded_container.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/dash_board/bloc/dash_board_bloc.dart';
import 'package:admin_hrm/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
      return TRoundedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders Status',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Gap(TSizes.spaceBtwSections),

            //Graph
            SizedBox(
              height: 400,
              child: PieChart(PieChartData(
                sections: state.orderStatusData.entries.map((entry) {
                  final status = entry.key;
                  final count = entry.value;
                  return PieChartSectionData(
                    title: count.toString(),
                    value: count.toDouble(),
                    radius: 100,
                    color: THelperFunctions.getOrderStatusColor(status),
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                  enabled: true,
                ),
              )),
            ),

            //Show Status and Color Meta
            SizedBox(
              width: double.infinity,
              child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Order')),
                    DataColumn(label: Text('Total')),
                  ],
                  rows: state.orderStatusData.entries.map((entry) {
                    final status = entry.key;
                    final count = entry.value;
                    final totalAmount = state.totalAmounts[status] ?? 0.0;

                    return DataRow(cells: [
                      DataCell(
                        Row(
                          children: [
                            TCircularContainer(
                              width: 20,
                              height: 20,
                              backgroundColor:
                                  THelperFunctions.getOrderStatusColor(status),
                            ),
                            const Gap(TSizes.spaceBtwItems),
                            Expanded(child: Text(status.name)),
                          ],
                        ),
                      ),
                      DataCell(Text(count.toString())),
                      DataCell(Text('\$${totalAmount.toStringAsFixed(2)}')),
                    ]);
                  }).toList()),
            )
          ],
        ),
      );
    });
  }
}
