import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuildRowItem extends StatelessWidget {
  const BuildRowItem({
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
