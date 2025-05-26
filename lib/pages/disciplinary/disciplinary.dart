import 'package:admin_hrm/common/widgets/layouts/templates/site_layout.dart';
import 'package:admin_hrm/pages/disciplinary/resposive_page/disciplinary_page_desktop.dart';
import 'package:admin_hrm/pages/disciplinary/resposive_page/disciplinary_page_mobile.dart';
import 'package:admin_hrm/pages/disciplinary/resposive_page/disciplinary_page_table.dart';
import 'package:flutter/material.dart';

class DisciplinaryPage extends StatefulWidget {
  const DisciplinaryPage({super.key});

  @override
  State<DisciplinaryPage> createState() => _DisciplinaryPageState();
}

class _DisciplinaryPageState extends State<DisciplinaryPage> {
  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: DisciplinaryPageDesktop(),
      tablet: DisciplinaryPageTable(),
      mobile: DisciplinaryPageMobile(),
    );
  }
}
