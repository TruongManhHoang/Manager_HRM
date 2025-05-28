import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class DashBoardMobilePage extends StatelessWidget {
  const DashBoardMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final personal = globalStorage.personalManagers;
    final department = globalStorage.departments;
    final position = globalStorage.positions;
    final personalList = personal ?? [];
    final positionList = position ?? [];
    final departmentList = department ?? [];
    int maxCount = 1;
    final counts = positionList.map((pos) {
      final count = personalList.where((p) => p.positionId == pos.id).length;
      if (count > maxCount) maxCount = count;
      return count;
    }).toList();

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // const TBreadcrumsWithHeading(
                      //   heading: 'Tổng quan',
                      //   breadcrumbItems: [],
                      // ),
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.purple[400],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Iconsax.element_3,
                                color: Colors.white,
                                size: 20,
                              )),
                          const Gap(10),
                          Text('Tổng quan hệ thống',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDashboardCard(
                              '${personalList.length}',
                              'Tổng nhân sự',
                              Colors.blue,
                              context,
                              Icons.person,
                              RouterName.employeePage,
                              'Xem danh sách nhân viên'),
                          _buildDashboardCard(
                              '${department?.length ?? 0}',
                              'Phòng ban',
                              Colors.orange,
                              context,
                              Icons.apartment,
                              RouterName.departmentPage,
                              'Xem danh sách phòng ban'),
                          _buildDashboardCard(
                              '${positionList.length}',
                              'Danh sách chức vụ',
                              const Color.fromARGB(255, 170, 158, 46),
                              context,
                              Icons.account_circle,
                              RouterName.positionPage,
                              'Xem danh sách tài khoản'),
                          _buildDashboardCard(
                              '0',
                              'Nhân viên nghỉ việc',
                              Colors.red,
                              context,
                              Icons.exit_to_app,
                              // Hello(),
                              'Xem nhân viên nghỉ việc'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tổng quan hệ thống',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                  height: 30,
                                ),
                                const Gap(TSizes.spaceBtwItems),
                                Center(
                                  child: Container(
                                    height: 350,
                                    width: double.infinity,
                                    child: BarChart(
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        maxY: personalList.isNotEmpty
                                            ? personalList
                                                    .map((p) => departmentList
                                                        .indexWhere((d) =>
                                                            d.id ==
                                                            p.departmentId))
                                                    .fold<double>(0,
                                                        (prev, idx) {
                                                  final dep =
                                                      departmentList[idx];
                                                  final count = personalList
                                                      .where((p) =>
                                                          p.departmentId ==
                                                          dep.id)
                                                      .length;
                                                  return count > prev
                                                      ? count.toDouble()
                                                      : prev;
                                                }) +
                                                2
                                            : 5,
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                          touchTooltipData: BarTouchTooltipData(
                                            getTooltipItem: (group, groupIndex,
                                                rod, rodIndex) {
                                              final dep = departmentList[
                                                  group.x.toInt()];
                                              return BarTooltipItem(
                                                '${dep.name}\n',
                                                const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        'Số lượng: ${rod.toY.toInt()}',
                                                    style: const TextStyle(
                                                        color: Colors.yellow,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        barGroups: [
                                          ...departmentList
                                              .where((dep) => personalList.any(
                                                  (p) =>
                                                      p.departmentId == dep.id))
                                              .map((dep) {
                                            final count = personalList
                                                .where((p) =>
                                                    p.departmentId == dep.id)
                                                .length;
                                            return BarChartGroupData(
                                              x: departmentList.indexOf(dep),
                                              barRods: [
                                                BarChartRodData(
                                                  toY: count.toDouble(),
                                                  color: _getColorForIndex(
                                                      departmentList
                                                          .indexOf(dep)),
                                                  width: 32,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  backDrawRodData:
                                                      BackgroundBarChartRodData(
                                                    show: true,
                                                    toY: personalList.length
                                                        .toDouble(),
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                              ],
                                              showingTooltipIndicators: [0],
                                            );
                                          }).toList(),
                                        ],
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 1,
                                              getTitlesWidget: (value, meta) =>
                                                  Text(value.toInt().toString(),
                                                      style: const TextStyle(
                                                          fontSize: 12)),
                                              reservedSize: 30,
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                final idx = value.toInt();
                                                if (idx < 0 ||
                                                    idx >=
                                                        departmentList.length)
                                                  return const SizedBox
                                                      .shrink();
                                                final dep = departmentList[idx];
                                                if (personalList.any((p) =>
                                                    p.departmentId == dep.id)) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Text(
                                                      dep.name,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blueAccent),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  );
                                                }
                                                return const SizedBox.shrink();
                                              },
                                              reservedSize: 70,
                                            ),
                                          ),
                                          topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                        ),
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: true,
                                          horizontalInterval: 1,
                                          getDrawingHorizontalLine: (value) =>
                                              FlLine(
                                            color: Colors.grey[300],
                                            strokeWidth: 1,
                                          ),
                                          getDrawingVerticalLine: (value) =>
                                              FlLine(
                                            color: Colors.grey[200],
                                            strokeWidth: 1,
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: const Border(
                                            left: BorderSide(
                                                color: Colors.black12),
                                            bottom: BorderSide(
                                                color: Colors.black12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tổng quan hệ thống',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          )),
                                  Divider(
                                    color: Colors.grey[300],
                                    thickness: 1,
                                    height: 30,
                                  ),
                                  const Gap(TSizes.spaceBtwItems),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1D2B53),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    height: 350,
                                    child: BarChart(
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        maxY: (maxCount + 2).toDouble(),
                                        minY: 0,
                                        gridData: const FlGridData(show: false),
                                        borderData: FlBorderData(show: false),
                                        titlesData: FlTitlesData(
                                          topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          leftTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                int index = value.toInt();
                                                if (index < 0 ||
                                                    index >=
                                                        positionList.length)
                                                  return const SizedBox();
                                                return Text(
                                                  positionList[index].name ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: Colors.cyanAccent,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              },
                                              reservedSize: 40,
                                            ),
                                          ),
                                        ),
                                        barGroups: List.generate(
                                            positionList.length, (index) {
                                          return BarChartGroupData(
                                            x: index,
                                            barRods: [
                                              BarChartRodData(
                                                toY: counts[index].toDouble(),
                                                width: 12,
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Colors.cyanAccent,
                                                    Colors.blueAccent
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ],
                                            showingTooltipIndicators: [],
                                          );
                                        }),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const Gap(50)
                      ]),
                    ],
                  ),
                ))));
  }
}

Widget _buildDashboardCard(
    String count, String title, Color color, BuildContext context,
    [IconData? icon, String? router, String? name]) {
  return Expanded(
    child: InkWell(
      onTap: () {
        if (router != null) {
          context.go(router);
        }
      },
      child: Container(
        margin:
            const EdgeInsets.only(top: 15.0, bottom: 15, left: 5, right: 20),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                )),
            const Gap(TSizes.spaceBtwItems),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(fontSize: 24, color: color),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]!),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// Hàm tiện ích để lấy màu cho từng phần
Color _getColorForIndex(int index) {
  const colors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.pink,
  ];
  return colors[index % colors.length];
}
