import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_desktop.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_mobile.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_table.dart';
import 'package:admin_hrm/pages/position/resposive_page/position_page_desktop.dart';
import 'package:admin_hrm/pages/position/resposive_page/position_page_mobile.dart';
import 'package:admin_hrm/pages/position/resposive_page/position_page_table.dart';

import 'package:flutter/material.dart';

class PositionPage extends StatefulWidget {
  const PositionPage({super.key});

  @override
  State<PositionPage> createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> {
  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: PositionPageDesktop(),
      tablet: PositionPageTablet(),
      mobile: PositionPageMobile(),
    );
  }
}
