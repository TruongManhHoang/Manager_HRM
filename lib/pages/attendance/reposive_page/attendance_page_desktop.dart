import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_bloc.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_event.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_state.dart';
import 'package:admin_hrm/pages/attendance/table/data_table_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AttendancePageDesktop extends StatefulWidget {
  const AttendancePageDesktop({super.key});

  @override
  State<AttendancePageDesktop> createState() => _AttendancePageDesktopState();
}

class _AttendancePageDesktopState extends State<AttendancePageDesktop> {
  String? selectedMonth = "all";

  List<DropdownMenuEntry<String>> _buildMonthEntries() {
    final currentYear = DateTime.now().year;
    final List<DropdownMenuEntry<String>> entries = [];

    entries.add(const DropdownMenuEntry<String>(
      value: "all",
      label: "Tất cả tháng",
    ));

    for (int month = 1; month <= 12; month++) {
      final monthKey = "$currentYear-${month.toString().padLeft(2, '0')}";
      entries.add(DropdownMenuEntry<String>(
        value: monthKey,
        label: "Tháng $month/$currentYear",
      ));
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'Chấm công',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ],
                ),
                const Gap(TSizes.spaceBtwItems),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  labelText: 'Tìm kiếm nhân viên',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (value) {
                                  context
                                      .read<AttendanceBloc>()
                                      .add(SearchAttendance(value));
                                }),
                          ),
                          const Gap(TSizes.spaceBtwItems),
                          DropdownMenu<String>(
                            width: 200,
                            initialSelection: selectedMonth,
                            hintText: 'Chọn tháng',
                            trailingIcon: const Icon(Icons.arrow_drop_down),
                            dropdownMenuEntries: _buildMonthEntries(),
                            onSelected: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedMonth = value;
                                });

                                if (value == "all") {
                                  context
                                      .read<AttendanceBloc>()
                                      .add(LoadAttendances());
                                } else {
                                  final parts =
                                      value.split('-'); // value dạng "2025-07"
                                  final year = int.parse(parts[0]);
                                  final month = int.parse(parts[1]);
                                  context.read<AttendanceBloc>().add(
                                        FilterAttendance(
                                            month: month, year: year),
                                      );
                                }
                              }
                            },
                          ),
                          const Spacer(),
                          BlocBuilder<AttendanceBloc, AttendanceState>(
                            builder: (context, state) {
                              if (state is AttendanceLoaded) {
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    exportDynamicExcel(
                                      fileName: 'Danh sách chấm công',
                                      headers: [
                                        'Mã chấm công',
                                        'Mã nhân viên',
                                        'Ngày',
                                        'Giờ vào',
                                        'Giờ ra',
                                        'Địa điểm làm việc',
                                        'Ghi chú',
                                        'Đi muộn',
                                        'Vắng mặt',
                                      ],
                                      dataRows: state.attendances
                                          .map((att) => [
                                                att.id,
                                                att.userId,
                                                att.date.toString(),
                                                att.checkInTime?.toString() ??
                                                    '',
                                                att.checkOutTime?.toString() ??
                                                    '',
                                                att.workLocation ?? '',
                                                att.notes ?? '',
                                                att.isLate ? 'Có' : 'Không',
                                                att.isAbsent ? 'Có' : 'Không',
                                              ])
                                          .toList(),
                                    );
                                  },
                                  child: Text(
                                    'Xuất danh sách chấm công',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                      const Gap(TSizes.spaceBtwItems),
                      const DataTableAttendance()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
