import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/pages/personnel_management/table/data_table_personnel.dart';
import 'package:flutter/material.dart';

class EmployeePageMobile extends StatelessWidget {
  const EmployeePageMobile({super.key});

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
                            onPressed: () {},
                            child: Text('Thêm Nhân Viên',
                                style: Theme.of(context).textTheme.bodyMedium)),
                        TextButton(
                            onPressed: () {},
                            child: Text('Xuất danh sách nhân viên',
                                style: Theme.of(context).textTheme.bodyMedium)),
                        TextButton(
                            onPressed: () {},
                            child: Text('Hiện nhân viên đã ngừng hoạt động',
                                style: Theme.of(context).textTheme.bodyMedium)),
                        TextButton(
                            onPressed: () {},
                            child: Text('Nhân viên thôi việc',
                                style: Theme.of(context).textTheme.bodyMedium)),
                      ],
                    ),
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
