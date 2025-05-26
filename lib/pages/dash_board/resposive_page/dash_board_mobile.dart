import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashBoardMobilePage extends StatelessWidget {
  const DashBoardMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final personal = globalStorage.personalManagers;
    final department = globalStorage.departments;
    final position = globalStorage.positions;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.grey[200], // Đặt màu nền thành xám nhạt
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
                      '${personal!.length}',
                      'Nhân viên',
                      Colors.blue,
                      context,
                      Icons.person,
                      RouterName.employeePage,
                      'Xem danh sách nhân viên'),
                  _buildDashboardCard(
                      '${department!.length}',
                      'Phòng ban',
                      Colors.orange,
                      context,
                      Icons.apartment,
                      RouterName.departmentPage,
                      'Xem danh sách phòng ban'),
                  _buildDashboardCard(
                      '${position!.length}',
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
              Row(
                children: [
                  _buildDashboardCard(
                      'EXCEL',
                      'Xuất báo cáo',
                      Colors.green,
                      context,
                      Icons.file_copy_outlined,
                      'Xem khen thưởng kỷ luật'),
                  _buildDashboardCard('', '', Colors.grey[200]!, context),
                  _buildDashboardCard('', '', Colors.grey[200]!, context),
                  _buildDashboardCard('', '', Colors.grey[200]!, context),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 300,
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: 10,
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(toY: 5, color: Colors.blue)
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 6, color: Colors.orange)
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 7, color: Colors.green)
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(toY: 3, color: Colors.red)
                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(toY: 4, color: Colors.purple)
                      ]),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                          reservedSize: 30,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                            if (value.toInt() < 0 ||
                                value.toInt() >= days.length) {
                              return const SizedBox.shrink();
                            }
                            return Text(days[value.toInt()]);
                          },
                          reservedSize: 30,
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: Colors.blue,
                      title: '40%',
                      radius: 60,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.orange,
                      title: '30%',
                      radius: 60,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      value: 15,
                      color: Colors.green,
                      title: '15%',
                      radius: 60,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      value: 15,
                      color: Colors.red,
                      title: '15%',
                      radius: 60,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                  sectionsSpace: 4, // khoảng cách giữa các phần
                  centerSpaceRadius: 40, // khoảng trống ở giữa
                ),
              ),
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
