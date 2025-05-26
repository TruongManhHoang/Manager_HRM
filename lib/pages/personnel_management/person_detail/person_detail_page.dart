import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PersonDetailPage extends StatelessWidget {
  const PersonDetailPage({super.key, required this.persionalManagement});

  final PersionalManagement persionalManagement;

  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final position = globalStorage.positions!
        .firstWhere((e) => e.id == persionalManagement.positionId);

    final department = globalStorage.departments!
        .firstWhere((e) => e.id == persionalManagement.departmentId);
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
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quản lý thông tin nhân viên',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20),
                            ),
                            const TBreadcrumsWithHeading(
                              heading: 'Nhân viên',
                              breadcrumbItems: [RouterName.addEmployee],
                            ),
                          ],
                        ),
                        const Gap(20),
                        Container(
                            width: 700,
                            padding: const EdgeInsets.all(TSizes.defaultSpace),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thông tin chi tiết nhân viên',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontSize: 18),
                                ),
                                const Gap(TSizes.spaceBtwSections),
                                Center(
                                    child: Image.network(
                                  persionalManagement.avatar ?? '',
                                  width: 220,
                                  height: 270,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.person, size: 100),
                                )),
                                const Gap(TSizes.spaceBtwSections),
                                buildRow(
                                    label1: 'Mã nhân viên: ',
                                    text1: persionalManagement.code!,
                                    label2: 'Họ và tên: ',
                                    text2: persionalManagement.name),
                                const Gap(TSizes.spaceBtwItems),
                                buildRow(
                                    label1: 'Giới tính: ',
                                    text1: persionalManagement.gender,
                                    label2: 'Ngày sinh: ',
                                    text2: persionalManagement.dateOfBirth),
                                const Gap(TSizes.spaceBtwItems),
                                buildRow(
                                    label1: 'Email: ',
                                    text1: persionalManagement.email,
                                    label2: 'Số điện thoại: ',
                                    text2: persionalManagement.phone),
                                const Gap(TSizes.spaceBtwItems),
                                buildRow(
                                    label1: 'Chức vụ: ',
                                    text1: position.name!,
                                    label2: 'Phòng ban: ',
                                    text2: department.name),
                                const Gap(TSizes.spaceBtwItems),
                                buildRow(
                                    label1: 'Trạng thái: ',
                                    text1: persionalManagement.status!,
                                    label2: 'Ngày tạo: ',
                                    text2: persionalManagement.date),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}

class buildRow extends StatelessWidget {
  const buildRow({
    super.key,
    required this.label1,
    required this.text1,
    required this.label2,
    required this.text2,
  });

  final String label1;
  final String label2;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600], fontSize: 16),
              ),
              const Gap(5),
              Text(text1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 16))
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600], fontSize: 16),
              ),
              const Gap(5),
              Text(text2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 16))
            ],
          ),
        ),
      ],
    );
  }
}
