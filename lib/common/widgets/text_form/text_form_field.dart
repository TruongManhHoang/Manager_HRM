import 'package:admin_hrm/common/widgets/formatter/input_format.dart';
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
      this.text,
      this.suffixIcon,
      this.isFormatted = false});
  final String hint;
  final String? text;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? enabled;
  final int maxLines;
  final bool isFormatted;
  final Widget? suffixIcon;

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
              inputFormatters: isFormatted ? [CurrencyInputFormatter()] : [],
              decoration: InputDecoration(
                hintText: hint,
                suffixIcon: suffixIcon,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              validator: validator),
        ),
      ],
    );
  }
}
