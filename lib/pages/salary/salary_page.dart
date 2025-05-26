import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/pages/salary/resposive_page/salary_page_desktop.dart';
import 'package:admin_hrm/pages/salary/resposive_page/salary_page_mobile.dart';
import 'package:admin_hrm/pages/salary/resposive_page/salary_page_table.dart';
import 'package:flutter/material.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: SalaryPageDesktop(),
      tablet: SalaryPageTable(),
      mobile: SalaryPageMobile(),
    );
  }
}
