import 'package:admin_hrm/common/widgets/images/t_circular_image.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/menu/menu_item.dart';
import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_event.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:admin_hrm/utils/enum/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class SidebarUser extends StatelessWidget {
  const SidebarUser({super.key});

  @override
  Widget build(BuildContext context) {
    final storageKey = getIt<GlobalStorage>();
    final personal = storageKey.personalModel;
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(color: TColors.grey, width: 1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(TSizes.spaceBtwSections),
              TCircularImage(
                width: 100,
                height: 100,
                image: personal!.avatar,
                fit: BoxFit.cover,
                backgroundColor: Colors.transparent,
                imageType: ImageType.network,
              ),
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Danh sách',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),

                    // Menu items

                    const MenuItem(
                        icon: Iconsax.profile,
                        title: 'Thông tin nhân viên',
                        router: RouterName.employeeDetailUserPage),
                    const MenuItem(
                        icon: Iconsax.profile,
                        title: 'Bảng lương',
                        router: RouterName.employeeSalaryPage),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Iconsax.logout_1),
                          const Gap(TSizes.sm),
                          GestureDetector(
                            onTap: () {
                              _confirmDelete(context);
                            },
                            child: const Text(
                              'Đăng xuất',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _confirmDelete(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Xác nhận xoá'),
      content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
      actions: [
        TextButton(
          child: const Text('Không'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
        TextButton(
          child: const Text('Có', style: TextStyle(color: Colors.red)),
          onPressed: () {
            context.read<AuthBloc>().add(LogoutRequested());
            context.go(RouterName.login);
          },
        ),
      ],
    ),
  );
}
