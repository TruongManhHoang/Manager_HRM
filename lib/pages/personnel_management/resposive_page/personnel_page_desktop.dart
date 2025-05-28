import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/pages/department/bloc/department_bloc.dart';
import 'package:admin_hrm/pages/personnel_management/bloc/persional_bloc.dart';
import 'package:admin_hrm/pages/personnel_management/table/data_table_personnel.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EmployeePageDesktop extends StatelessWidget {
  const EmployeePageDesktop({super.key});

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
                heading: 'Nhân viên',
                breadcrumbItems: [],
              ),
              const Row(
                children: [
                  Text(
                    'Nhân Viên',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
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
                              context.push(RouterName.addEmployee);
                            },
                            child: Text(
                              'Thêm Nhân Viên',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )),
                        const Gap(10),
                        BlocBuilder<PersionalBloc, PersionalState>(
                            builder: (context, state) {
                          if (state.personnel != null) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  exportDynamicExcel(
                                    fileName: 'Danh_sach_nhan_vien',
                                    headers: [
                                      'ID',
                                      'Mã nhân viên',
                                      'Tên nhân viên',
                                      'Avatar',
                                      'Ngày sinh',
                                      'Số điện thoại',
                                      'Địa chỉ',
                                      'Email',
                                      'Giới tính',
                                      'ID phòng ban',
                                      'ID chức vụ',
                                      'Trạng thái',
                                      'Cập nhật lần cuối',
                                    ],
                                    dataRows: state.personnel!
                                        .map((dept) => [
                                              dept.id ?? '',
                                              dept.code ?? '',
                                              dept.name ?? '',
                                              dept.avatar ?? '',
                                              dept.dateOfBirth ?? '',
                                              dept.phone ?? '',
                                              dept.address ?? '',
                                              dept.email ?? '',
                                              dept.gender ?? '',
                                              dept.departmentId ?? '',
                                              dept.positionId ?? '',
                                              dept.status ?? '',
                                              dept.updatedAt ?? '',
                                            ])
                                        .toList(),
                                  );
                                },
                                child: Text(
                                  'Xuất danh sách nhân viên',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                ));
                          } else {
                            return const SizedBox();
                          }
                        }),
                        const Gap(10),
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {},
                            child: Text(
                              'Hiện nhân viên đã ngừng hoạt động',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )),
                        const Gap(10),
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {},
                            child: Text('Nhân viên thôi việc',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white))),
                      ],
                    ),
                    const Gap(20),
                    const DataTableEmployee()
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
