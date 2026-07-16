import 'package:flutter/material.dart';
import 'package:poultrypro/core/theme/app_theme.dart';

class DayItem extends StatelessWidget {
  final String dayName;
  final int date;
  final bool isActive;
  final Color? dotColor;
  final VoidCallback onTap;

  const DayItem({
    super.key,
    required this.dayName,
    required this.date,
    required this.isActive,
    this.dotColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? Colors.white.withValues(alpha: 0.9)
                    : AppColors.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? Colors.white
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
              ),
            ),
            const SizedBox(height: 4),
            // The tiny indicator dot for days that have pending tasks
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : (dotColor ?? Colors.transparent),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
