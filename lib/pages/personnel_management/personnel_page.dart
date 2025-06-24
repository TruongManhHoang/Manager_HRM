import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/department/resposive_page/department_page_mobile.dart';
import 'package:admin_hrm/pages/personnel_management/resposive_page/personnel_page_desktop.dart';
import 'package:admin_hrm/pages/personnel_management/resposive_page/personnel_page_table.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    // final role = globalStorage.role ?? 'user';
    final userRole = globalStorage.role ?? 'user';
    if (userRole != 'admin' && userRole != 'quản lý') {
      return Scaffold(
        body: Center(
          child: AlertDialog(
            title: const Text('Cảnh báo'),
            content: const Text('Bạn không có quyền truy cập trang này!'),
            actions: [
              TextButton(
                onPressed: () {
                  context.go(RouterName.splashScreen);
                },
                child: const Text('Quay lại trang chính'),
              ),
            ],
          ),
        ),
      );
    }
    return const SiteTemplate(
      desktop: EmployeePageDesktop(),
      tablet: EmployeePageTablet(),
      mobile: DepartmentPageMobile(),
    );
  }
}
