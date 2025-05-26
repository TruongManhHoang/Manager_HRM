// import 'package:admin_hrm/pages/auth/login/resposive_page/login_view.dart';
// import 'package:admin_hrm/router/routers_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
// import 'package:admin_hrm/pages/auth/bloc/auth_event.dart';
// import 'package:admin_hrm/pages/auth/bloc/auth_state.dart';
// import 'package:go_router/go_router.dart';

// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key, required this.width});
//   final double width;

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController fullNameController = TextEditingController();
//   String? emailError;
//   String? passwordError;
//   String? fullNameError;
//   void validateEmail(String value) {
//     if (value.isEmpty) {
//       setState(() => emailError = 'Email không được để trống');
//     } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
//       setState(() => emailError = 'Email không hợp lệ');
//     } else {
//       setState(() => emailError = null);
//     }
//   }

//   void validatePassword(String value) {
//     if (value.isEmpty) {
//       setState(() => passwordError = 'Mật khẩu không được để trống');
//     } else if (value.length < 6) {
//       setState(() => passwordError = 'Mật khẩu phải ít nhất 6 ký tự');
//     } else {
//       setState(() => passwordError = null);
//     }
//   }

//   void validateFullName(String value) {
//     if (value.isEmpty) {
//       setState(() => fullNameError = 'Họ và tên không được để trống');
//     } else {
//       setState(() => fullNameError = null);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content: Text("Đăng ký thành công. Vui lòng đăng nhập.")),
//             );
//             context.go(RouterName.login);
//           } else if (state is AuthFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Center(
//             child: SingleChildScrollView(
//               child: Container(
//                 width: 300,
//                 margin: const EdgeInsets.symmetric(horizontal: 24),
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const Text(
//                       "Đăng ký tài khoản",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     TextFormField(
//                       controller: fullNameController,
//                       onChanged: validateFullName,
//                       decoration: InputDecoration(
//                         labelText: "Họ và tên",
//                         errorText: fullNameError,
//                         border: const OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       onChanged: validateEmail,
//                       controller: emailController,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         errorText: emailError,
//                         border: const OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       onChanged: validatePassword,
//                       controller: passwordController,
//                       decoration: InputDecoration(
//                         labelText: "Mật khẩu",
//                         errorText: passwordError,
//                         border: const OutlineInputBorder(),
//                       ),
//                       obscureText: true,
//                     ),
//                     const SizedBox(height: 24),
//                     ElevatedButton(
//                       onPressed: state is AuthLoading
//                           ? null
//                           : () {
//                               context.read<AuthBloc>().add(
//                                     RegisterRequested(
//                                       emailController.text.trim(),
//                                       passwordController.text.trim(),
//                                       fullNameController.text.trim(),
//                                     ),
//                                   );
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         minimumSize: const Size(double.infinity, 48),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: state is AuthLoading
//                           ? const CircularProgressIndicator()
//                           : const Text("Đăng ký"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
