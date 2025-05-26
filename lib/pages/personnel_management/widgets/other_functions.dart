// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

// ignore: must_be_immutable
class OtherFunctions extends StatelessWidget {
  void Function()? collaborate;
  void Function()? delete;
  void Function()? edit;
  OtherFunctions({
    super.key,
    this.collaborate,
    this.delete,
    this.edit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: collaborate,
          child: Container(
            padding: const EdgeInsets.all(TSizes.xs),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 127, 147, 247),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: const Text("Quá trình công tác"),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: edit,
          child: Container(
            padding: const EdgeInsets.all(TSizes.xs),
            decoration: BoxDecoration(
              color: TColors.secondary,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: const Text("Sửa thông tin"),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: delete,
          child: Container(
            padding: const EdgeInsets.all(TSizes.xs),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 82, 140, 86),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: const Text("Xoá"),
          ),
        ),
      ],
    );
  }
}
