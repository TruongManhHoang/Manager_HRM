import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_desktop.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_mobile.dart';
import 'package:admin_hrm/pages/contract/resposive_page/contract_page_table.dart';

import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: ContractPageDesktop(),
      tablet: ContractPageTablet(),
      mobile: ContractPageMobile(),
    );
  }
}
