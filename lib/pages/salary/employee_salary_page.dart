import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_user.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/salary/table_employee/data_table_salary_employee.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EmployeeSalaryPage extends StatelessWidget {
  const EmployeeSalaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            child: SidebarUser(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                const Header(),
                const Gap(TSizes.spaceBtwSections),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(16.0),
                    child: const SingleChildScrollView(
                      child: DataTableSalaryEmployee(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
