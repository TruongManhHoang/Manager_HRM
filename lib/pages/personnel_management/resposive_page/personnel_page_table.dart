import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/personnel_management/bloc/persional_bloc.dart';
import 'package:admin_hrm/pages/personnel_management/table/data_table_personnel.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EmployeePageTablet extends StatelessWidget {
  const EmployeePageTablet({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedStatus = 'Tất cả';
    final statusOptions = [
      'Tất cả',
      'Đang làm việc',
      'Ngừng làm việc',
      'Nghỉ việc',
    ];
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
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              labelText: 'Tìm kiếm nhân viên',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              context
                                  .read<PersionalBloc>()
                                  .add(SearchPersionalEvent(value));
                            },
                          ),
                        ),
                        const Gap(TSizes.spaceBtwItems),
                        Container(
                          width: 220,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              items: statusOptions.map((status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedStatus = value;
                                  context
                                      .read<PersionalBloc>()
                                      .add(FilterPersionalByStatusEvent(value));
                                }
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(150, 50),
                            ),
                            onPressed: () {
                              context.push(RouterName.addEmployee);
                            },
                            child: Text(
                              'Thêm Nhân Viên',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white, fontSize: 16),
                            )),
                        const Gap(10),
                        BlocBuilder<PersionalBloc, PersionalState>(
                            builder: (context, state) {
                          if (state.personnel != null) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: const Size(150, 50),
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
                                      .copyWith(
                                          color: Colors.white, fontSize: 16),
                                ));
                          } else {
                            return const SizedBox();
                          }
                        }),
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
