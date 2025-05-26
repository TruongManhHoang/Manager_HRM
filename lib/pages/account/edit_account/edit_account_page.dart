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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditAccountPage extends StatelessWidget {
  const EditAccountPage({super.key, this.accountModel});
  final AccountModel? accountModel;
  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final employee = globalStorage.personalManagers!.firstWhere(
      (element) => element.id == accountModel?.employeeId,
    );

    TextEditingController codeController = TextEditingController(
      text: accountModel?.code ?? '',
    );
    TextEditingController nameController = TextEditingController(
      text: employee.name,
    );
    TextEditingController emailController = TextEditingController(
      text: accountModel?.email ?? '',
    );
    TextEditingController passwordController = TextEditingController(
      text: accountModel?.password ?? '',
    );
    TextEditingController roleController = TextEditingController(
      text: accountModel?.role ?? '',
    );
    TextEditingController statusController = TextEditingController(
      text: accountModel?.status ?? '',
    );

    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<AccountBloc, AccountState>(listener: (context, state) {
      if (state is AccountSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm tài khoản thành công'),
          ),
        );
        context.go(RouterName.accountPage);
      } else if (state is AccountError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm tài khoản thất bại: ${state.message}'),
          ),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        body: Row(
          children: [
            const Expanded(
              child: Sidebar(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Header(),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const TBreadcrumsWithHeading(
                              heading: 'Thêm tài khoản',
                              breadcrumbItems: [
                                RouterName.addAccount,
                              ],
                            ),
                            Container(
                                width: 600,
                                padding:
                                    const EdgeInsets.all(TSizes.defaultSpace),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Mã tài khoản',
                                              hint: 'Nhập mã tài khoản',
                                              controller: codeController,
                                            ),
                                            const Gap(
                                              TSizes.spaceBtwItems,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Nhân viên',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                const Gap(
                                                  TSizes.spaceBtwItems,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Nhân viên:',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                    const Gap(
                                                        TSizes.spaceBtwItems),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300)),
                                                      child: Text(
                                                        employee.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Gap(
                                              TSizes.spaceBtwItems,
                                            ),
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
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Role',
                                              hint: 'Nhập role',
                                              controller: roleController,
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
                                                          backgroundColor:
                                                              Colors.red,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: TSizes
                                                                      .defaultSpace *
                                                                  2,
                                                              vertical: 16)),
                                                      onPressed: () {
                                                        context.pop();
                                                      },
                                                      child: Text(
                                                        'Huỷ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                ),
                                                const Gap(TSizes.spaceBtwItems),
                                                Expanded(
                                                  child: TextButton(
                                                      style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: TSizes
                                                                      .defaultSpace *
                                                                  2,
                                                              vertical: 16)),
                                                      onPressed: () {
                                                        // Handle form submissio
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          final account =
                                                              AccountModel(
                                                            id: accountModel
                                                                ?.id,
                                                            employeeId:
                                                                accountModel!
                                                                    .employeeId,
                                                            code: codeController
                                                                .text,
                                                            name: nameController
                                                                .text,
                                                            email:
                                                                emailController
                                                                    .text,
                                                            password:
                                                                passwordController
                                                                    .text,
                                                            role: roleController
                                                                .text,
                                                            status:
                                                                statusController
                                                                    .text,
                                                            updatedAt:
                                                                DateTime.now(),
                                                          );

                                                          context
                                                              .read<
                                                                  AccountBloc>()
                                                              .add(
                                                                  UpdateAccount(
                                                                      account));
                                                          context
                                                              .read<AuthBloc>()
                                                              .add(ChangePasswordRequested(
                                                                  passwordController
                                                                      .text));
                                                          context.go(RouterName
                                                              .accountPage);
                                                        }
                                                      },
                                                      child: state
                                                              is AccountLoading
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white)
                                                          : Text(
                                                              'Thêm tài khoản',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))
                                  ],
                                )),
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
    });
  }
}
