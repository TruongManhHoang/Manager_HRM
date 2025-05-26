import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DashBoardDesktopPage extends StatelessWidget {
  const DashBoardDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final personal = globalStorage.personalManagers;
    final department = globalStorage.departments;
    final position = globalStorage.positions;
    final personalList = personal ?? [];
    final positionList = position ?? [];
    final departmentList = department ?? [];

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const TBreadcrumsWithHeading(
                heading: 'Tổng quan',
                breadcrumbItems: [],
              ),
              Row(
                children: [
                  _buildDashboardCard(
                      '${personalList.length}',
                      'Nhân viên',
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
              Row(
                children: [
                  _buildDashboardCard('0', 'Nhóm nhân viên', Colors.blue,
                      context, Icons.group, 'Xem danh sách nhóm'),
                  _buildDashboardCard(
                      'EXCEL',
                      'Xuất báo cáo',
                      Colors.green,
                      context,
                      Icons.file_copy_outlined,
                      'Xem danh sách nhân viên'),
                  _buildDashboardCard('EXCEL', 'Xuất báo cáo', Colors.green,
                      context, Icons.file_copy_outlined, 'Xem lương nhân viên'),
                  _buildDashboardCard('EXCEL', 'Xuất báo cáo', Colors.green,
                      context, Icons.file_copy_outlined, 'Xem chấm công'),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 400,
                          width: 550,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: personalList.isNotEmpty
                                  ? personalList
                                          .map((p) => departmentList.indexWhere(
                                              (d) => d.id == p.departmentId))
                                          .fold<double>(0, (prev, idx) {
                                        final dep = departmentList[idx];
                                        final count = personalList
                                            .where(
                                                (p) => p.departmentId == dep.id)
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
                                    final dep = departmentList[group.x.toInt()];
                                    return BarTooltipItem(
                                      '${dep.name}\n',
                                      const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Số lượng: ${rod.toY.toInt()}',
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
                                    .where((dep) => personalList
                                        .any((p) => p.departmentId == dep.id))
                                    .map((dep) {
                                  final count = personalList
                                      .where((p) => p.departmentId == dep.id)
                                      .length;
                                  return BarChartGroupData(
                                    x: departmentList.indexOf(dep),
                                    barRods: [
                                      BarChartRodData(
                                        toY: count.toDouble(),
                                        color: _getColorForIndex(
                                            departmentList.indexOf(dep)),
                                        width: 32,
                                        borderRadius: BorderRadius.circular(8),
                                        backDrawRodData:
                                            BackgroundBarChartRodData(
                                          show: true,
                                          toY: personalList.length.toDouble(),
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
                                    getTitlesWidget: (value, meta) => Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 12)),
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
                                      if (personalList.any(
                                          (p) => p.departmentId == dep.id)) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            dep.name,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                    reservedSize: 70,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                horizontalInterval: 1,
                                getDrawingHorizontalLine: (value) => FlLine(
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
                                  bottom: BorderSide(color: Colors.black12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text('Số lượng chức vụ trong công ty')
                      ],
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 350,
                          width: 500,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                ...positionList.map((pos) {
                                  final count = personalList
                                      .where((p) => p.positionId == pos.id)
                                      .length;
                                  double percent = 0;
                                  if (personalList.isNotEmpty) {
                                    percent =
                                        (count / personalList.length * 100);
                                  }
                                  return PieChartSectionData(
                                    value: count.toDouble(),
                                    color: _getColorForIndex(
                                        positionList.indexOf(pos)),
                                    title:
                                        '${pos.name} \n (${percent.toStringAsFixed(0)}%)',
                                    radius: 100,
                                    titleStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12), // tăng font size
                                  );
                                }).toList(),
                              ],
                              centerSpaceRadius: 65, // tăng khoảng trống ở giữa
                            ),
                          ),
                        ),
                        Gap(10),
                        Text('Số lượng chức vụ trong công ty')
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(50)
            ],
          ),
        ),
      ),
    ));
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
        height: 170,
        margin:
            const EdgeInsets.only(top: 15.0, bottom: 15, left: 5, right: 20),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                if (icon != null)
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 96,
                  ),
              ],
            ),
            // const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 9.0),
              alignment: Alignment.center,
              child: Text(
                name ?? '',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
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
