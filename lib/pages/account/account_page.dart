import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/pages/account/resposive_page/account_page_desktop.dart';
import 'package:admin_hrm/pages/account/resposive_page/account_page_mobile.dart';
import 'package:admin_hrm/pages/account/resposive_page/account_page_table.dart';

import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: AccountPageDesktop(),
      tablet: AccountPageTable(),
      mobile: AccountPageMobile(),
    );
  }
}
