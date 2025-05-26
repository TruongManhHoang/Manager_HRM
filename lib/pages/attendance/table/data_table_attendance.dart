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
          return TPaginatedDataTable(
            minWidth: 700,
            tableHeight: 500,
            dataRowHeight: TSizes.xl * 1.45,
            columns: const [
              DataColumn2(
                label: Center(
                  child: Text(
                    'Nhân viên',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Ngày',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Giờ vào',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Giờ ra',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // DataColumn2(
              //   label: Center(
              //     child: Text(
              //       'Vị trí',
              //       maxLines: 2,
              //       softWrap: true,
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 13,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              // DataColumn2(
              //   label: Center(
              //     child: Text(
              //       'Ghi chú',
              //       maxLines: 2,
              //       softWrap: true,
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 13,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              // DataColumn2(
              //   label: Center(
              //     child: Text(
              //       'Đi trễ',
              //       maxLines: 2,
              //       softWrap: true,
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 13,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              // DataColumn2(
              //   label: Center(
              //     child: Text(
              //       'Vắng',
              //       maxLines: 2,
              //       softWrap: true,
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 13,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Hành động',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
