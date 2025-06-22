import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/dash_board/resposive_page/dash_board_desktop.dart';
import 'package:admin_hrm/pages/dash_board/widgets/staff_line_chart.dart';
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
    final contractList = globalStorage.contracts ?? [];
    int maxCount = 1;
    final int femaleCount = personalList.where((p) => p.gender == 'Nữ').length;
    final int maleCount = personalList.where((p) => p.gender == 'Nam').length;
    final int total = femaleCount + maleCount;
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(children: [
                    // const TBreadcrumsWithHeading(
                    //   heading: 'Tổng quan',
                    //   breadcrumbItems: [],
                    // ),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.purple[400],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Iconsax.element_3,
                              color: Colors.white,
                              size: 20,
                            )),
                        const Gap(10),
                        Text('Tổng quan hệ thống',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
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
                                height: 200,
                                width: double.infinity,
                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: personalList.isNotEmpty
                                        ? personalList
                                                .map((p) => departmentList
                                                    .indexWhere((d) =>
                                                        d.id == p.departmentId))
                                                .fold<double>(0, (prev, idx) {
                                              final dep = departmentList[idx];
                                              final count = personalList
                                                  .where((p) =>
                                                      p.departmentId == dep.id)
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
                                        getTooltipItem:
                                            (group, groupIndex, rod, rodIndex) {
                                          final dep =
                                              departmentList[group.x.toInt()];
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
                                              (p) => p.departmentId == dep.id))
                                          .map((dep) {
                                        final count = personalList
                                            .where(
                                                (p) => p.departmentId == dep.id)
                                            .length;
                                        return BarChartGroupData(
                                          x: departmentList.indexOf(dep),
                                          barRods: [
                                            BarChartRodData(
                                              toY: count.toDouble(),
                                              color: _getColorForIndex(
                                                  departmentList.indexOf(dep)),
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
                                                idx >= departmentList.length)
                                              return const SizedBox.shrink();
                                            final dep = departmentList[idx];
                                            if (personalList.any((p) =>
                                                p.departmentId == dep.id)) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  dep.name,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueAccent),
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
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
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
                                      getDrawingVerticalLine: (value) => FlLine(
                                        color: Colors.grey[200],
                                        strokeWidth: 1,
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: const Border(
                                        left: BorderSide(color: Colors.black12),
                                        bottom:
                                            BorderSide(color: Colors.black12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(TSizes.spaceBtwSections),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Biến động nhân sự',
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    height: 200,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                            height: 150,
                                            child: StaffLineChart(
                                              personalList: personalList,
                                            )),
                                        const SizedBox(height: 20),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      width: 10,
                                                      height: 10,
                                                      color: Colors.blue),
                                                  const SizedBox(width: 4),
                                                  Text('Nhân viên vào'),
                                                ],
                                              ),
                                              SizedBox(width: 20),
                                              Row(
                                                children: [
                                                  Container(
                                                      width: 10,
                                                      height: 10,
                                                      color: Colors.red),
                                                  const SizedBox(width: 4),
                                                  Text('Nhân viên nghỉ việc'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))
                              ]),
                        ),
                      ),
                    ]),
                    const Gap(TSizes.spaceBtwSections),
                    Row(children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Thống kê giới tính',
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
                                  height: 180,
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: PieChart(
                                          PieChartData(
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 60,
                                            sections: [
                                              PieChartSectionData(
                                                color: Colors.pink,
                                                value: femaleCount.toDouble(),
                                                title: '',
                                                radius: 40,
                                              ),
                                              PieChartSectionData(
                                                color: Colors.blue,
                                                value: maleCount.toDouble(),
                                                title: '',
                                                radius: 40,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '$total',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text('Tổng số'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 10,
                                        child: Column(
                                          children: [
                                            LegendItem(
                                              color: Colors.pink,
                                              label: 'Nữ',
                                              value:
                                                  '$femaleCount (${total > 0 ? ((femaleCount / total * 100).round()) : 0}%)',
                                            ),
                                            SizedBox(width: 20),
                                            LegendItem(
                                              color: Colors.blue,
                                              label: 'Nam',
                                              value:
                                                  '$maleCount (${total > 0 ? ((maleCount / total * 100).round()) : 0}%)',
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),
                      const Gap(TSizes.spaceBtwSections),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Thống kê chức vụ',
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
                                    height: 180,
                                    width: double.infinity,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          ...positionList.map((posi) {
                                            final count = personalList
                                                .where((p) =>
                                                    p.positionId == posi.id)
                                                .length;
                                            final percent = maxCount > 0
                                                ? count / maxCount
                                                : 0.0;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width: 120,
                                                      child: Text(posi.name!)),
                                                  Expanded(
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        FractionallySizedBox(
                                                          widthFactor: percent,
                                                          child: Container(
                                                            height: 24,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: _getColorForIndex(
                                                                  positionList
                                                                      .indexOf(
                                                                          posi)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              count.toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ])),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(TSizes.spaceBtwSections),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Thống kê hợp đồng',
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
                                    height: 180,
                                    width: double.infinity,
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                height: 200,
                                                width: 200,
                                                child: PieChart(
                                                  PieChartData(
                                                    sectionsSpace: 0,
                                                    centerSpaceRadius: 60,
                                                    sections: [
                                                      ..._buildContractPieSections(
                                                          contractList),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned.fill(
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '${contractList.length}',
                                                        style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Text(
                                                          'Tổng hợp đồng'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children:
                                                      _buildContractLegend(
                                                          contractList),
                                                ),
                                              ),
                                            ],
                                          )
                                        ]))
                              ]),
                        ),
                      ),
                    ]),
                  ]),
                ))));
  }
}

List<PieChartSectionData> _buildContractPieSections(List contracts) {
  // Đếm số lượng từng loại hợp đồng
  final Map<String, int> typeCounts = {};
  for (var c in contracts) {
    final type = c.contractType ?? 'Khác'; // SỬA LẠI DÒNG NÀY
    typeCounts[type] = (typeCounts[type] ?? 0) + 1;
  }
  final total = contracts.length;
  int colorIdx = 0;
  return typeCounts.entries.map((e) {
    final percent = total > 0 ? e.value / total * 100 : 0;
    return PieChartSectionData(
      color: _getColorForIndex(colorIdx++),
      value: e.value.toDouble(),
      title: '',
      radius: 40,
      badgeWidget: null,
      titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
    );
  }).toList();
}

List<Widget> _buildContractLegend(List contracts) {
  final Map<String, int> typeCounts = {};
  for (var c in contracts) {
    final type = c.contractType ?? 'Khác';
    typeCounts[type] = (typeCounts[type] ?? 0) + 1;
  }
  final total = contracts.length;
  int colorIdx = 0;
  return typeCounts.entries.map((e) {
    final percent = total > 0 ? (e.value / total * 100).round() : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: LegendItem(
        color: _getColorForIndex(colorIdx++),
        label: e.key,
        value: '${e.value} (${percent}%)',
      ),
    );
  }).toList();
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 10,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
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

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const LegendItem(
      {required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(
          '$label  $value',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
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
