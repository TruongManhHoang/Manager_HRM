import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/reposive/responsive_design.dart';
import 'package:admin_hrm/common/widgets/reposive/screen/desktop_layout.dart';
import 'package:admin_hrm/common/widgets/reposive/screen/mobile_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../reposive/screen/table_layout.dart';

class SiteTemplate extends StatelessWidget {
  const SiteTemplate(
      {super.key,
      this.desktop,
      this.tablet,
      this.mobile,
      this.useLayout = true});

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;

  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveWidget(
        desktop: useLayout
            ? DesktopLayout(
                child: desktop,
              )
            : desktop ?? Container(),
        tablet: useLayout
            ? TableLayout(
                child: tablet ?? desktop,
              )
            : tablet ?? desktop ?? Container(),
        mobile: useLayout
            ? MobileLayout(
                child: mobile ?? desktop,
              )
            : mobile ?? desktop ?? Container(),
      ),
    );
  }
}
