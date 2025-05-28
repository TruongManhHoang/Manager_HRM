import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_desktop.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_mobile.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_table.dart';
import 'package:admin_hrm/router/routers_name.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final role = globalStorage.role ?? 'user';
    if (role != 'admin') {
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
      desktop: ContractPageDesktop(),
      tablet: ContractPageTablet(),
      mobile: ContractPageMobile(),
    );
  }
}
