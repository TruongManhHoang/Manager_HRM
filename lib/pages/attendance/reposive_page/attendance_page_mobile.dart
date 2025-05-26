import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_bloc.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_state.dart';
import 'package:admin_hrm/pages/attendance/table/data_table_attendance.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AttendancePageMobile extends StatelessWidget {
  const AttendancePageMobile({super.key});

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
                const TBreadcrumsWithHeading(
                  heading: 'Chấm Công',
                  breadcrumbItems: [],
                ),
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
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              context.pushNamed(RouterName.addAttendance);
                            },
                            child: Text(
                              'Thêm Chấm Công',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          const Gap(10),
                          BlocBuilder<AttendanceBloc, AttendanceState>(
                            builder: (context, state) {
                              if (state is AttendanceLoaded) {
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    exportDynamicExcel(
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
