import 'package:admin_hrm/pages/auth/login/resposive_page/login_view.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        if (width >= 1100) {
          return const LoginView(
            width: 0.4,
          );
        } else if (width >= 600) {
          return const LoginView(
            width: 0.6,
          );
        } else {
          return const LoginView(
            width: 0.78,
          );
        }
      },
    );
  }
}
