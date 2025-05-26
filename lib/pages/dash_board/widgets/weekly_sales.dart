// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';

// import '../../../common/widgets/containers/rounded_container.dart';
// import '../../../constants/colors.dart';
// import '../../../constants/device_utility.dart';
// import '../../../constants/sizes.dart';
// import '../bloc/dash_board_bloc.dart';

// class TWeeklySalesGraph extends StatelessWidget {
//   const TWeeklySalesGraph({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return   TRoundedContainer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Weekly Sales',
//               style:
//               Theme
//                   .of(context)
//                   .textTheme
//                   .headlineLarge),
//           const Gap(TSizes.spaceBtwSections),

//           //Graph
//           BlocBuilder<DashboardBloc, DashboardState>(
//             builder: (context, state) {
//               return SizedBox(
//                 height: 400,
//                 child: BarChart(
//                     BarChartData(
//                         titlesData: buildFlTitlesData(),
//                         borderData: FlBorderData(
//                             show: true,
//                             border: const Border(
//                                 top: BorderSide.none,
//                                 right: BorderSide.none)),
//                         gridData: const FlGridData(
//                           show: true,
//                           drawHorizontalLine: true,
//                           drawVerticalLine: true,
//                           horizontalInterval: 200,
//                         ),
//                         barGroups: state.weeklySales
//                             .asMap()
//                             .entries
//                             .map((entry) =>
//                             BarChartGroupData(
//                                 x: entry.key,
//                                 barRods: [
//                                   BarChartRodData(
//                                       toY: entry.value,
//                                       width: 30,
//                                       color: TColors.primary,
//                                       borderRadius:
//                                       BorderRadius
//                                           .circular(
//                                           TSizes.sm))
//                                 ]))
//                             .toList(),
//                         groupsSpace: TSizes.spaceBtwItems,
//                         barTouchData: BarTouchData(
//                             touchTooltipData: BarTouchTooltipData(
//                                 getTooltipColor: (
//                                     _) => TColors.secondary
//                             ),
//                             touchCallback: TDeviceUtils
//                                 .isDesktopScreen(context) ? (
//                                 barTouchEvent,
//                                 barTouchResponse) {} : null
//                         )
//                     )),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
//   FlTitlesData buildFlTitlesData() {
//     return FlTitlesData(
//       show: true,
//       bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 //Map index to the desired day of the week
//                 const days = [
//                   'Mon',
//                   'Tue',
//                   'Wed',
//                   'Thu',
//                   'Fri',
//                   'Sat',
//                   'Sun'
//                 ];

//                 //Calculate the index and ensure it wraps around for the correct day
//                 int index = value.toInt() % days.length;

//                 //Get the day corresponding to the calculated index
//                 final day = days[index];
//                 return SideTitleWidget(
//                   axisSide: AxisSide.bottom, space: 0, child: Text(day),);
//               }
//           )
//       ),
//       leftTitles: const AxisTitles(
//         sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 50,
//             interval: 200
//         ),
//       ),
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//     );
//   }
// }
