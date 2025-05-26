import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_event.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_state.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordView extends StatefulWidget {
  ForgetPasswordView({super.key, required this.width});
  final double width;

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final emailController = TextEditingController();
  String? emailError;
  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() => emailError = 'Email không được để trống');
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      setState(() => emailError = 'Email không hợp lệ');
    } else {
      setState(() => emailError = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSent) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Email khôi phục mật khẩu đã được gửi.")),
              );
              context.go(RouterName.login);
            });
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
                  TextFormField(
                      controller: emailController,
                      onChanged: (value) {
                        validateEmail(value);
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        errorText: emailError,
                        border: const OutlineInputBorder(),
                      )),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                          ForgotPasswordRequested(emailController.text.trim()));
                    },
                    child: const Text("Gửi liên kết đặt lại mật khẩu"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
