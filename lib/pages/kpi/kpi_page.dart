import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/pages/kpi/reposive_page/kpi_page_desktop.dart';
import 'package:admin_hrm/pages/kpi/reposive_page/kpi_page_mobile.dart';
import 'package:admin_hrm/pages/kpi/reposive_page/kpi_page_table.dart';
import 'package:flutter/material.dart';

class KPIPage extends StatefulWidget {
  const KPIPage({super.key});

  @override
  State<KPIPage> createState() => _KPIPageState();
}

class _KPIPageState extends State<KPIPage> {
  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: KPIPageDesktop(),
      tablet: KPIPageTable(),
      mobile: KPIPageMobile(),
    );
  }
}
