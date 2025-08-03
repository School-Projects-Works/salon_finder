import 'package:flutter/material.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';


class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.radius = 1,
    this.icon,
  });
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final EdgeInsets? padding;
  final double radius;
  final IconData? icon;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) {
        setState(() {
          onHover = value;
        });
      },
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color:
              onHover
                  ? Colors.transparent
                  : widget.color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: widget.color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  color: onHover ? widget.color ?? AppColors.primaryColor : Colors.white,
                  size: 18,
                ),
              if (widget.icon != null && widget.text.isNotEmpty)
                const SizedBox(width: 8),
              Text(
                widget.text,
                style: AppTextStyles.body(
                  color: onHover ? widget.color ?? AppColors.primaryColor : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
