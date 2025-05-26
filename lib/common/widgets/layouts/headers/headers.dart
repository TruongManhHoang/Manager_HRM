import 'package:admin_hrm/common/widgets/images/t_circular_image.dart';
import 'package:admin_hrm/common/widgets/images/t_rounded_image.dart';
import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/constants/device_utility.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_state.dart';
import 'package:admin_hrm/utils/enum/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key, this.scaffoldKey});
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final storageKey = getIt<GlobalStorage>();
    final personal = storageKey.personalModel;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: TColors.grey, width: 1))),
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
          leading: !TDeviceUtils.isDesktopScreen(context)
              ? IconButton(
                  onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                  icon: const Icon(Iconsax.menu))
              : null,
          title: TDeviceUtils.isDesktopScreen(context)
              ? SizedBox(
                  width: 400,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: 'Search anything...',
                    ),
                  ),
                )
              : null,
          actions: [
            //Search bar for mobile and tablet
            if (!TDeviceUtils.isDesktopScreen(context))
              IconButton(
                  onPressed: () {}, icon: const Icon(Iconsax.search_normal)),
            //Notification icon
            IconButton(
                onPressed: () {}, icon: const Icon(Iconsax.notification)),
            const SizedBox(
              width: TSizes.spaceBtwItems / 2,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                    child: Image.network(
                  personal!.avatar ?? '',
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, size: 100),
                )),
                const SizedBox(
                  width: TSizes.sm,
                ),
                if (!TDeviceUtils.isMobileScreen(context))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        personal.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        personal.email,
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  )
              ],
            )
          ]),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
