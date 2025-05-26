import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/account/bloc/account_bloc.dart';
import 'package:admin_hrm/pages/account/table/data_table_account.dart';

import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AccountPageMobile extends StatelessWidget {
  const AccountPageMobile({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const TBreadcrumsWithHeading(
                heading: 'Tài Khoản',
                breadcrumbItems: [],
              ),
              const Row(
                children: [
                  Text(
                    'Tài Khoản',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
              const Gap(TSizes.spaceBtwItems),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () async {
                              final result =
                                  await context.push(RouterName.addReward);
                              if (result == true) {
                                context.read<AccountBloc>().add(LoadAccounts());
                              }
                            },
                            child: Text(
                              'Thêm tài khoản',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )),
                        const Gap(10),
                        BlocBuilder<AccountBloc, AccountState>(
                            builder: (context, state) {
                          if (state is AccountLoaded) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  exportDynamicExcel(
                                    fileName: 'Danh sách tài khoản',
                                    headers: [
                                      'Mã tài khoản',
                                      'Mã nhân viên',
                                      'Tên tài khoản',
                                      'Mật khẩu',
                                      'Trạng thái',
                                      'Loại tài khoản',
                                      'Ngày tạo',
                                      'Ngày cập nhật',
                                    ],
                                    dataRows: state.accounts
                                        .map((account) => [
                                              account.id,
                                              account.employeeId,
                                              account.name,
                                              account.password,
                                              account.status,
                                              account.role,
                                              account.createdAt,
                                              account.updatedAt
                                            ])
                                        .toList(),
                                  );
                                },
                                child: Text(
                                  'Xuất danh sách tài khoản',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                ));
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ),
                    const Gap(TSizes.spaceBtwItems),
                    const DataTableAccount()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
