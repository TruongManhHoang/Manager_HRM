import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/pages/attendance/reposive_page/attendance_page_desktop.dart';
import 'package:admin_hrm/pages/attendance/reposive_page/attendance_page_mobile.dart';
import 'package:admin_hrm/pages/attendance/reposive_page/attendance_page_table.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: AttendancePageDesktop(),
      tablet: AttendancePageTable(),
      mobile: AttendancePageMobile(),
    );
  }
}
