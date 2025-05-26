import 'package:admin_hrm/common/widgets/layouts/sidebars/bloc/sidebar_bloc.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class TBreadcrumsWithHeading extends StatelessWidget {
  const TBreadcrumsWithHeading(
      {super.key,
      required this.heading,
      required this.breadcrumbItems,
      this.returnToPreviousPage = false,
      this.rouderName});

  final String heading;

  final List<String> breadcrumbItems;

  final bool returnToPreviousPage;

  final String? rouderName;

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) {
      return s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
    }

    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                context.push(rouderName!);
              },
              child: Padding(
                padding: const EdgeInsets.all(TSizes.xs),
                child: Text(
                  heading,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(letterSpacingDelta: 1.2),
                ),
              ),
            ),
            for (int i = 0; i < breadcrumbItems.length; i++)
              Row(
                children: [
                  InkWell(
                    onTap: i == breadcrumbItems.length - 1
                        ? null
                        : () => context.push(breadcrumbItems[i]),
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.xs),
                      child: Text(
                        i == breadcrumbItems.length - 1
                            ? breadcrumbItems[i].toString()
                            : capitalize(breadcrumbItems[i].substring(1)),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2),
                      ),
                    ),
                  )
                ],
              )
          ],
        ),
        const SizedBox(
          height: TSizes.sm,
        ),
        Row(
          children: [
            if (returnToPreviousPage)
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Iconsax.arrow_left),
              )
          ],
        )
      ],
    );
  }
}
