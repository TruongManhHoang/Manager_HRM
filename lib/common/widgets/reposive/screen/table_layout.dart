import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_accounting.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_user.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:flutter/material.dart';

class TableLayout extends StatelessWidget {
  TableLayout({super.key, this.child});

  final Widget? child;

  Widget _buildSidebar() {
    final globalStorage = getIt<GlobalStorage>();
    final userRole = globalStorage.role?.toLowerCase() ?? 'employee';

    print('Debug - DesktopLayout role: "$userRole"'); // Debug log

    switch (userRole) {
      case 'admin':
        print('Debug - Using Sidebar (admin)');
        return const Sidebar(); // Admin sidebar với full quyền
      case 'accounting':
        print('Debug - Using SidebarAccounting');
        return const SidebarAccounting(); // Accounting sidebar
      case 'employee':
      default:
        print('Debug - Using SidebarUser');
        return const SidebarUser(); // User sidebar với quyền hạn chế
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: _buildSidebar(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                const Header(),
                Expanded(
                  child: child ?? const SizedBox(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
