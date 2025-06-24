import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/salary/bloc/salary_bloc.dart';
import 'package:admin_hrm/pages/salary/table/data_table_salary.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SalaryPageMobile extends StatelessWidget {
  const SalaryPageMobile({super.key});
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
                heading: 'Lương',
                breadcrumbItems: [],
              ),
              const Row(
                children: [
                  Text(
                    'Lương',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
              Gap(TSizes.spaceBtwItems),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(150, 50),
                            ),
                            onPressed: () {
                              context.go('/salary-page/add-salary');
                            },
                            child: Text(
                              'Thêm Lương',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white, fontSize: 16),
                            )),
                        const Gap(10),
                        BlocBuilder<SalaryBloc, SalaryState>(
                            builder: (context, state) {
                          if (state is SalaryLoaded) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: const Size(150, 50),
                                ),
                                onPressed: () {
                                  exportDynamicExcel(
                                    fileName: 'Danh_sach_luong',
                                    headers: [
                                      'Mã bảng lương',
                                      'Mã nhân viên',
                                      'Số ngày chấm công',
                                      'số tiền kỷ luật',
                                      'Tiền thưởng KPI',
                                      'Tiền khen thưởng',
                                      'Lương cơ bản',
                                      'Tổng lương thực lĩnh',
                                      'Người duyệt',
                                      'Ngày tạo bảng lương',
                                    ],
                                    dataRows: state.salaries
                                        .map((salary) => [
                                              salary.id ?? '',
                                              salary.employeeId ?? '',
                                              salary.attendanceBonus ?? '',
                                              salary.disciplinaryDeduction ??
                                                  '',
                                              salary.kpiBonus ?? '',
                                              salary.rewardBonus ?? '',
                                              salary.baseSalary ?? '',
                                              salary.totalSalary ?? '',
                                              salary.approvedBy ?? '',
                                              salary.payDate ?? '',
                                            ])
                                        .toList(),
                                  );
                                },
                                child: Text(
                                  'Xuất danh sách lương',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Colors.white, fontSize: 16),
                                ));
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ),
                    Gap(TSizes.spaceBtwItems),
                    const DataTableSalary()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
