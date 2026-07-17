import 'package:flutter/material.dart';
import 'package:poultrypro/core/theme/app_theme.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final String? helperText;
  final VoidCallback? onTogglePassword;
  final TextInputType keyboardType;
  final Widget? actionWidget;
  final TextEditingController? controller; // 1. Add controller
  final String? Function(String?)? validator; // 2. Add validator

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.helperText,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
    this.actionWidget,
    this.controller, // 3. Add to constructor
    this.validator, // 4. Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 3. Wrap the label in a Row to accommodate the action widget
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            // Show the action widget if one was provided
            ?actionWidget,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, // 5. Pass it to the TextFormField
          validator: validator, // 6. Pass it to the TextFormField
          obscureText: obscureText,
          keyboardType: keyboardType, // Ensure keyboard type is passed
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(prefixIcon, color: AppColors.textHint, size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
