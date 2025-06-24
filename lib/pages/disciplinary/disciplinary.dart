import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/disciplinary/resposive_page/disciplinary_page_desktop.dart';
import 'package:admin_hrm/pages/disciplinary/resposive_page/disciplinary_page_mobile.dart';
import 'package:admin_hrm/pages/disciplinary/resposive_page/disciplinary_page_table.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DisciplinaryPage extends StatefulWidget {
  const DisciplinaryPage({super.key});

  @override
  State<DisciplinaryPage> createState() => _DisciplinaryPageState();
}

class _DisciplinaryPageState extends State<DisciplinaryPage> {
  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final role = globalStorage.role ?? 'user';
    if (role != 'admin' && role != 'quản lý') {
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
      desktop: DisciplinaryPageDesktop(),
      tablet: DisciplinaryPageTable(),
      mobile: DisciplinaryPageMobile(),
    );
  }
}
