import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';


class CustomDropDown<TResult extends Object> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.value,
    required this.items,
    this.validator,
    this.hintText,
    this.onChanged,
    this.radius,
    this.color,
    this.onSaved,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
    this.iconData,
  });

  final TResult? value;
  final List<DropdownMenuItem<TResult>> items;
  final String? Function(TResult?)? validator;
  final String? hintText;
  final String? label;
  final Function(TResult?)? onChanged;
  final Function(TResult?)? onSaved;
  final double? radius;
  final Color? color;
  final IconData? iconData;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        borderRadius: BorderRadius.circular(5),
        style: AppTextStyles.body(
          color: Theme.of(context).textTheme.labelLarge!.color!,
        ),
        
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 5),
            borderSide: BorderSide(color: color ?? Colors.black54, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 5),
            borderSide: BorderSide(color: color ?? Colors.black38, width: 1),
          ),
          fillColor: Colors.transparent,
          filled: false,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 5),
            borderSide: BorderSide(color: color ?? AppColors.primaryColor),
          ),
          prefixIconColor: Theme.of(context).colorScheme.secondary,
          suffixIconColor: Theme.of(context).colorScheme.secondary,
          suffixIcon: suffixIcon,
          prefixIcon:
              prefixIcon != null
                  ? Icon(
                    prefixIcon,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 3,
          ),
          labelStyle: AppTextStyles.body(
            color: isRequired ? Theme.of(context).colorScheme.error : null,
          ),
          labelText: isRequired ? '$label *' : label,
          hintText: hintText,
          focusColor: AppColors.primaryColor,
          iconColor: Theme.of(context).colorScheme.secondary,
          hintStyle: AppTextStyles.body(),
        ),
        onChanged: onChanged,
        onSaved: onSaved,
        items: items,
        validator: validator,
        value: value,
        isExpanded: true,
        icon: Icon(iconData ?? Icons.arrow_drop_down, color: Colors.black54),
      ),
    );
  }
}
