import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/dash_board/bloc/dash_board_bloc.dart';
import 'package:admin_hrm/pages/dash_board/resposive_page/dash_board_desktop.dart';
import 'package:admin_hrm/pages/dash_board/resposive_page/dash_board_mobile.dart';
import 'package:admin_hrm/pages/dash_board/resposive_page/dash_board_table.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DashboardBloc>().add(const CalculateWeeklySalesEvent());
    context.read<DashboardBloc>().add(const CalculateOrderStatusEvent());
  }

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
      desktop: DashBoardDesktopPage(),
      tablet: DashBoardTable(),
      mobile: DashBoardMobilePage(),
    );
  }
}
