import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';

import '../theme/text_styles.dart';


class CustomTextFields extends ConsumerWidget {
  const CustomTextFields({
    super.key,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.keyboardType,
    this.onChanged,
    this.onSaved,
    this.maxLines,
    this.hintText,
    this.radius,
    this.onTap,
    this.helperText,
    this.isCapitalized = false,
    this.isDigitOnly = false,
    this.min = 0,
    this.max = 999999,
    this.color,
    this.isReadOnly = false,
    this.validator,
    this.controller,
    this.isPhoneInput = false,
    this.onSubmitted,
    this.focusNode,
    this.initialValue,
    this.isRequired = false,
    this.isAutoComplete = false,
    this.onChangedCountry,
    this.showPhone = false,
  });

  final String? label;
  final String? helperText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String?)? onSubmitted;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final int? maxLines;
  final double? radius;
  final bool? isCapitalized;
  final bool? isDigitOnly;
  final bool? isReadOnly;
  final Color? color;
  final int? max, min;
  final TextEditingController? controller;
  final bool? isPhoneInput;
  final String? initialValue;
  final bool isRequired;
  final bool isAutoComplete;
  final bool showPhone;
  final Function(CountryCode)? onChangedCountry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var responsive = MediaQuery.of(context).size;
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText ?? false,
      onTap: onTap,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted,
      initialValue: initialValue,
      inputFormatters: [
        if (isCapitalized!) UpperCaseTextFormatter(),
        if (isDigitOnly ?? false)
          FilteringTextInputFormatter.allow(RegExp(r'^[-+]?\d*\.?\d{0,200}')),
        PreventDeleteFormatter(max!, min!),
      ],
      textCapitalization:
          isCapitalized!
              ? TextCapitalization.characters
              : TextCapitalization.none,
      style: AppTextStyles.body(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: color ?? Colors.black45,
      ),
      onChanged: onChanged,
      onSaved: onSaved,
      maxLines: maxLines ?? 1,
      readOnly: isReadOnly ?? false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(color: color ?? Colors.black38, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(color: color ?? Colors.black38, width: 1),
        ),
        fillColor: Colors.transparent,
        filled: true,
        errorStyle: AppTextStyles.subtitle1(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(color: color ?? AppColors.primaryColor),
        ),
        prefixIconColor: AppColors.primaryColor,
        suffixIconColor: AppColors.primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        labelStyle: AppTextStyles.subtitle1(
          fontWeight: FontWeight.w300,
          color:
              isRequired ? Theme.of(context).colorScheme.error : Colors.black45,
        ),
        labelText: isRequired && label != null ? '$label *' : label,
        hintText: hintText,
        focusColor: AppColors.primaryColor,
        helperText: helperText,
        helperStyle: const TextStyle(fontWeight: FontWeight.w500),
        iconColor: AppColors.primaryColor,
        hintStyle: AppTextStyles.body(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          color: Colors.grey,
        ),
        prefixIcon:
            prefixIcon == null
                ? showPhone
                    ? SizedBox(
                      width: 80,
                      child: CountryCodePicker(
                        flagWidth: 28,
                        padding: EdgeInsets.zero,
                        dialogSize: Size(400, responsive.height * 0.8),
                        onChanged: onChangedCountry,
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'GH',
                        favorite: ['+233', 'GH'],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: true,
                        // optional. aligns the flag and the Text left
                        alignLeft: true,
                      ),
                    )
                    : null
                : Icon(prefixIcon, size: 18, color: AppColors.primaryColor),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (RegExp("[a-zA-Z,]").hasMatch(newValue.text)) {
      return TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
    } else if (!RegExp(r'^[a-zA-Z0-9_\-=@+,\.;]+$').hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class PreventDeleteFormatter extends TextInputFormatter {
  final int max, min;

  PreventDeleteFormatter(this.max, this.min);
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > min - 1 && newValue.text.length < max + 1) {
      return newValue;
    }
    return oldValue;
  }
}
