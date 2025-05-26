import 'package:admin_hrm/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TTextFormField extends StatelessWidget {
  const TTextFormField(
      {super.key,
      required this.hint,
      this.validator,
      this.initialValue,
      this.controller,
      this.keyboardType,
      this.obscureText,
      this.enabled,
      this.textAlign = false,
      this.maxLines = 1,
      this.text});
  final String hint;
  final String? text;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? enabled;
  final int maxLines;

  final bool textAlign;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        textAlign
            ? Text(
                "${text!}: ",
                style: Theme.of(context).textTheme.titleSmall,
              )
            : Text(''),
        const Gap(TSizes.spaceBtwSections),
        Expanded(
          child: TextFormField(
            controller: controller,
            initialValue: initialValue,
            obscureText: obscureText ?? false,
            enabled: enabled,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
