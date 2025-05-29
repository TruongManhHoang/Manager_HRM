import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StaffLineChart extends StatelessWidget {
  StaffLineChart({super.key, required this.personalList});

  final List<PersionalManagement> personalList;

  @override
  Widget build(BuildContext context) {
    // Giả sử mỗi nhân viên có trường: status, joinDate, resignDate (kiểu DateTime)
    // Thống kê theo tháng trong năm hiện tại
    final now = DateTime.now();
    final int year = now.year;

    // Đếm số nhân viên vào và nghỉ theo từng tháng
    List<int> joinedPerMonth = List.filled(12, 0);
    List<int> resignedPerMonth = List.filled(12, 0);

    for (var p in personalList) {
      // Đếm nhân viên vào
      if (p.status == 'đang làm việc' && p.createdAt!.year == year) {
        joinedPerMonth[p.createdAt!.month - 1]++;
      }
      // Đếm nhân viên nghỉ (nếu có trường resignDate)
      if (p.status == 'Nghỉ việc' && p.updatedAt!.year == year) {
        resignedPerMonth[p.updatedAt!.month - 1]++;
      }
    }

    // Tạo FlSpot cho từng tháng
    final joinedSpots = List.generate(
      12,
      (i) => FlSpot((i + 1).toDouble(), joinedPerMonth[i].toDouble()),
    );
    final resignedSpots = List.generate(
      12,
      (i) => FlSpot((i + 1).toDouble(), resignedPerMonth[i].toDouble()),
    );

    // Tìm maxY để biểu đồ đẹp hơn
    final maxY = [
      ...joinedPerMonth,
      ...resignedPerMonth,
    ].fold<int>(0, (prev, e) => e > prev ? e : prev);

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Hiển thị tháng
                if (value >= 1 && value <= 12) {
                  return Text('T${value.toInt()}',
                      style: const TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
              reservedSize: 24,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) => Text(value.toInt().toString(),
                  style: const TextStyle(fontSize: 10)),
              reservedSize: 24,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          // Nhân viên vào - màu xanh
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: true),
            spots: joinedSpots,
            belowBarData: BarAreaData(show: false),
          ),
          // Nhân viên nghỉ - màu đỏ
          LineChartBarData(
            isCurved: true,
            color: Colors.red,
            dotData: FlDotData(show: true),
            spots: resignedSpots,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minX: 1,
        maxX: 12,
        minY: 0,
        maxY: (maxY + 1).toDouble(),
      ),
    );
  }
}
