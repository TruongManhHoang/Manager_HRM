import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/drop_down_menu/drop_down_menu.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/account/bloc/account_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_event.dart';

import 'package:admin_hrm/router/routers_name.dart';
import 'package:admin_hrm/utils/validators/validation.dart';
import 'package:admin_hrm/utils/code_generator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final globalKey = getIt<GlobalStorage>();
  late final personals = globalKey.personalManagers ?? [];

  final _formKey = GlobalKey<FormState>();

  String? selectedPersonalId;
  final personalIdController = TextEditingController();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final roleController = TextEditingController();
  final statusController = TextEditingController();
  bool _obscureOldPassword = true;
  @override
  void initState() {
    super.initState();

    // Tự động generate mã tài khoản
    codeController.text = CodeGenerator.generateCode(
      CodeGenerator.accountPrefix,
      [], // Tạm thời dùng list rỗng, sẽ cập nhật sau khi có storage
    );

    // Nếu có dữ liệu, mặc định chọn nhân viên đầu tiên
    if (personals.isNotEmpty) {
      final first = personals.first;
      selectedPersonalId = first.id;
      personalIdController.text = first.id!;
      emailController.text = first.email;
      nameController.text = first.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thêm tài khoản thành công')),
          );
          context.read<AccountBloc>().add(LoadAccounts());
          context.go(RouterName.accountPage);
        } else if (state is AccountError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm tài khoản thất bại')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Row(
            children: [
              const Expanded(child: Sidebar()),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const Header(),
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const TBreadcrumsWithHeading(
                                heading: 'Tài khoản',
                                breadcrumbItems: [RouterName.addAccount],
                              ),
                              Container(
                                width: 600,
                                padding:
                                    const EdgeInsets.all(TSizes.defaultSpace),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Mã tài khoản',
                                        hint: 'Mã được tạo tự động',
                                        controller: codeController,
                                        enabled: false,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      Row(
                                        children: [
                                          Text(
                                            'Nhân viên',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const Gap(TSizes.spaceBtwItems),
                                          DropdownMenu(
                                            initialSelection:
                                                personalIdController.text,
                                            controller: personalIdController,
                                            width: 200,
                                            trailingIcon: const Icon(
                                                Icons.arrow_drop_down),
                                            dropdownMenuEntries: personals
                                                .map((personal) =>
                                                    DropdownMenuEntry<String>(
                                                      label: personal.name,
                                                      value: personal.id!,
                                                    ))
                                                .toList(),
                                            onSelected: (value) {
                                              setState(() {
                                                selectedPersonalId = value;
                                                final selected =
                                                    personals.firstWhere(
                                                        (e) => e.id == value);
                                                emailController.text =
                                                    selected.email;
                                                nameController.text =
                                                    selected.name;
                                              });
                                            },
                                            hintText: 'Chọn nhân viên',
                                          ),
                                        ],
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Tên tài khoản',
                                        hint: 'Nhập tên tài khoản',
                                        controller: nameController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Email',
                                        hint: 'Nhập email',
                                        controller: emailController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Mật khẩu',
                                        hint: 'Nhập mật khẩu',
                                        controller: passwordController,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureOldPassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureOldPassword =
                                                  !_obscureOldPassword;
                                            });
                                          },
                                        ),
                                        obscureText: _obscureOldPassword,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: TValidator.validatePassword,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      // TTextFormField(
                                      //   textAlign: true,
                                      //   text: 'Role',                                      //   hint: 'Nhập role',
                                      //   controller: roleController,
                                      //   validator: (value) =>
                                      //       TValidator.validateEmptyText(
                                      //           'Role', value),
                                      // ),
                                      TDropDownMenu(
                                        menus: const [
                                          'quản lý',
                                          'kế toán',
                                          'employee',
                                        ],
                                        controller: roleController,
                                        text: 'Vai trò',
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TDropDownMenu(
                                        menus: const [
                                          'Hoạt động',
                                          'Ngừng hoạt động'
                                        ],
                                        controller: statusController,
                                        text: 'Trạng thái',
                                      ),
                                      const Gap(TSizes.spaceBtwSections),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal:
                                                      TSizes.defaultSpace * 2,
                                                  vertical: 16,
                                                ),
                                              ),
                                              onPressed: () => context.pop(),
                                              child: Text(
                                                'Huỷ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const Gap(TSizes.spaceBtwItems),
                                          Expanded(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal:
                                                      TSizes.defaultSpace * 2,
                                                  vertical: 16,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  final account = AccountModel(
                                                    employeeId:
                                                        selectedPersonalId!,
                                                    code: codeController.text,
                                                    name: nameController.text,
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text,
                                                    role: roleController.text,
                                                    status:
                                                        statusController.text,
                                                  );

                                                  context.read<AuthBloc>().add(
                                                        RegisterRequested(
                                                            account),
                                                      );
                                                }
                                              },
                                              child: state is AccountLoading
                                                  ? const CircularProgressIndicator()
                                                  : Text(
                                                      'Thêm tài khoản',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
