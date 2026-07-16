import 'package:flutter/material.dart';
import 'package:poultrypro/core/theme/app_theme.dart';

class RecentActivityItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool isIncome;
  final IconData icon;

  const RecentActivityItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Check theme brightness to adjust text colors
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        // Subtle shadow to lift the card off the background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Icon Box
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              // Light green for income, light red for expenses
              color: isIncome
                  ? AppColors.primaryLight.withValues(alpha: isDark ? 0.1 : 0.6)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isIncome ? AppColors.primaryDark : AppColors.error,
            ),
          ),

          const SizedBox(width: 16),

          // 2. Title and Date (Expanded to push amount to the right)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),

          // 3. Amount Text
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // Green for positive income, standard text color for negative expenses
              color: isIncome
                  ? AppColors.primaryDark
                  : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
