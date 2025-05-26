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

class SalaryPageDesktop extends StatelessWidget {
  const SalaryPageDesktop({super.key});
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              context.push(RouterName.addSalary);
                            },
                            child: Text(
                              'Thêm Lương',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )),
                        const Gap(10),
                        BlocBuilder<SalaryBloc, SalaryState>(
                            builder: (context, state) {
                          if (state is SalaryLoaded) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  exportDynamicExcel(
                                    headers: [
                                      'Mã phòng ban',
                                      'Tên phòng ban',
                                      'Người quản lý',
                                      'Mô tả',
                                      'Trạng thái',
                                      'Số lượng nhân viên',
                                      'Email',
                                      'Số điện thoại',
                                    ],
                                    dataRows: state.salaries
                                        .map((salary) => [
                                              salary.id ?? '',
                                              salary.employeeId ?? '',
                                              salary.attendanceBonus ?? '',
                                              salary.approvedBy ?? '',
                                              salary.disciplinaryDeduction ??
                                                  '',
                                            ])
                                        .toList(),
                                  );
                                },
                                child: Text(
                                  'Xuất danh sách lương',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
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
