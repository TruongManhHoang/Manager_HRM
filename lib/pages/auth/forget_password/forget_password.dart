import 'package:admin_hrm/pages/auth/forget_password/resposive_page/forget_password_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        if (width >= 1100) {
          return ForgetPasswordView(
            width: 0.4,
          );
        } else if (width >= 600) {
          return ForgetPasswordView(
            width: 0.6,
          );
        } else {
          return ForgetPasswordView(
            width: 0.78,
          );
        }
      },
    );
  }
}
