import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/department/resposive_page/department_page_desktop.dart';
import 'package:admin_hrm/pages/department/resposive_page/department_page_mobile.dart';
import 'package:admin_hrm/pages/department/resposive_page/department_page_table.dart';
import 'package:admin_hrm/pages/report/resposive_page/report_page_desktop.dart';
import 'package:admin_hrm/pages/report/resposive_page/report_page_mobile.dart';
import 'package:admin_hrm/pages/report/resposive_page/report_page_table.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final role = globalStorage.role ?? 'user';
    if (role != 'admin' && role != 'kế toán' && role != 'quản lý') {
      return Scaffold(
        body: Center(
          child: AlertDialog(
            title: const Text('Cảnh báo'),
            content: Text(
                'Bạn không có quyền truy cập trang này! Role hiện tại: $role'),
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
      desktop: ReportPageDesktop(),
      tablet: ReportPageTable(),
      mobile: ReportPageMobile(),
    );
  }
}
