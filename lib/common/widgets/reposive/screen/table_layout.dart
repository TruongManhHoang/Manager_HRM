import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

class TableLayout extends StatelessWidget {
  TableLayout({super.key, this.child});

  final Widget? child;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const Sidebar(),
      appBar: Header(
        scaffoldKey: scaffoldKey,
      ),
      body: child ?? const SizedBox(),
    );
  }
}
