import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_accounting.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_manager.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_user.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.child});

  final Widget? child;

  Widget _buildSidebar() {
    final globalStorage = getIt<GlobalStorage>();
    final userRole = globalStorage.role?.toLowerCase().trim() ??
        'employee'; // ✅ Thêm .trim()

    switch (userRole) {
      case 'admin':
        return const Sidebar();
      case 'kế toán':
        return const SidebarAccounting();
      case 'quản lý':
        return const SidebarManager();
      case 'nhân viên':
      default:
        return const SidebarUser();
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
