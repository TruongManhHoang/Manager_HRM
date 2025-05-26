import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/pages/reward/resposive_page/reward_page_desktop.dart';
import 'package:admin_hrm/pages/reward/resposive_page/reward_page_mobile.dart';
import 'package:admin_hrm/pages/reward/resposive_page/reward_page_table.dart';
import 'package:flutter/material.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: RewardPageDesktop(),
      tablet: RewardPageTable(),
      mobile: RewardPageMobile(),
    );
  }
}
