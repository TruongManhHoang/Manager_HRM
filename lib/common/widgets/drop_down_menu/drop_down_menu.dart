import 'package:admin_hrm/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TDropDownMenu extends StatelessWidget {
  const TDropDownMenu(
      {super.key, required this.menus, required this.controller, this.text});
  final List<String> menus;
  final String? text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text ?? '',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Gap(TSizes.spaceBtwSections),
        DropdownMenu(
          initialSelection: controller.text,
          controller: controller,
          width: 200,
          // textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //       fontSize: 20, // ✅ Font size rất to
          //       fontWeight: FontWeight.w600,
          //     ),
          menuStyle: MenuStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.white,
            ),
          ),
          trailingIcon: const Icon(Icons.arrow_drop_down),
          dropdownMenuEntries: menus
              .map((educationLevel) => DropdownMenuEntry<String>(
                    label: educationLevel,
                    value: educationLevel,
                  ))
              .toList(),
          onSelected: (value) {
            print(value);
          },
          hintText: 'Chọn ${text}',
        ),
      ],
    );
  }
}
