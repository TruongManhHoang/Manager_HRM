import 'dart:async';

import 'package:admin_hrm/common/widgets/animation/hyper_animation.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _size = 20.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final screenWidth = MediaQuery.of(context).size.width;

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _size = screenWidth * 3;
        });
      });
    });
    //Navigator
    Timer(const Duration(seconds: 3), () {
      final storageKey = getIt<GlobalStorage>();
      final userRole = storageKey.role?.toLowerCase().trim() ?? '';

      if (userRole == 'admin') {
        debugPrint('Debug - Navigating to dashboard');
        context.go(RouterName.dashboard);
      } else if (userRole == 'user' || userRole == 'nhân viên') {
        debugPrint('Debug - Navigating to user page');
        context.go(RouterName.employeeDetailUserPage);
      } else if (userRole == 'kế toán') {
        debugPrint('Debug - Navigating to accounting page');
        context.go(RouterName.employeeDetailAccountingPage);
      } else if (userRole == 'quản lý') {
        debugPrint('Debug - Navigating to manager page');
        context.go(RouterName.employeeDetailAccountingPage);
      } else {
        context.go(RouterName.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HyperAnimationLoad(),
          Gap(10),
          Text(
            "H R M",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
