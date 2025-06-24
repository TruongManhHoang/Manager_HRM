import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_bloc.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_state.dart';
import 'package:admin_hrm/pages/attendance/table/table_source_attendance.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../constants/sizes.dart';

class DataTableAttendance extends StatelessWidget {
  const DataTableAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        if (state is AttendanceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AttendanceLoaded) {
          if (state.attendances.isEmpty) {
            return Center(
              child: Text(
                'Không có dữ liệu chấm công',
                style: const TextStyle(color: Colors.black),
              ),
            );
          }
          TextStyle baseStyle =
              Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: TColors.dark,
                  );
          return TPaginatedDataTable(
            tableHeight: 500,
            rowsPerPage: 5,
            dataRowHeight: TSizes.xl * 1.45,
            columns: [
              DataColumn2(
                label: Center(
                  child: Text('STT',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
                fixedWidth: 60, // Cố định chiều rộng nếu muốn
              ),
              DataColumn2(
                label: Center(
                  child: Text('Nhân viên',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Ngày',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Giờ vào',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Giờ ra',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Hành động',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
            ],
            source: AttendanceTableRows(
              context,
              state.attendances,
            ),
          );
        } else
          return Center(
            child: Text(
              'Không có dữ liệu',
              style: const TextStyle(color: Colors.red),
            ),
          );
      },
    );
  }
}
