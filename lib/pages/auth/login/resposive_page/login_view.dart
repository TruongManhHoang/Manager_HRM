import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_event.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/routers_name.dart';

class LoginView extends StatefulWidget {
  final double width;
  const LoginView({super.key, required this.width});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();

  String? emailError;
  String? passwordError;

  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() => emailError = 'Email không được để trống');
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      setState(() => emailError = 'Email không hợp lệ');
    } else {
      setState(() => emailError = null);
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      setState(() => passwordError = 'Mật khẩu không được để trống');
    } else if (value.length < 6) {
      setState(() => passwordError = 'Mật khẩu phải ít nhất 6 ký tự');
    } else {
      setState(() => passwordError = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(RouterName.splashScreen);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('HRM',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      label: const Text('Email'),
                      errorText: emailError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: validateEmail,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: passWordController,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      errorText: passwordError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    obscureText: true,
                    onChanged: validatePassword,
                  ),
                  //forgot password
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.go(RouterName.forgotPassword);
                      },
                      child: const Text("Quên mật khẩu?"),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 47, 141, 212),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(307, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9)),
                    ),
                    onPressed: () {
                      validateEmail(emailController.text.trim());
                      validatePassword(passWordController.text.trim());

                      if (emailError == null && passwordError == null) {
                        context.read<AuthBloc>().add(LoginRequested(
                              emailController.text.trim(),
                              passWordController.text.trim(),
                            ));
                      }
                    },
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : const Text("Đăng nhập"),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
