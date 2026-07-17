import 'package:flutter/material.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/models/app_model.dart';

class FlockCard extends StatelessWidget {
  final Flock flock;
  final String lastFed; // We can wire this up to the Feed database later!

  const FlockCard({
    super.key,
    required this.flock,
    this.lastFed = '2 hours ago', // Defaulting to match your design
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Dynamic Calculations
    // Calculate Age in weeks/days
    final days = DateTime.now().difference(flock.dateAdded).inDays;
    final ageString = days > 14 ? '${days ~/ 7} Weeks' : '$days Days';

    // Calculate Health Score (Current vs Initial)
    final int healthScore = flock.initialCount > 0
        ? ((flock.currentCount / flock.initialCount) * 100)
              .clamp(0, 100)
              .toInt()
        : 100;

    // Design Colors based on the image
    const Color brandGreen = Color(0xFF10B981);
    final Color textDark = isDark ? Colors.white : const Color(0xFF1E293B);
    final Color cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final Color greyBoxBg = isDark
        ? AppColors.darkBackground
        : const Color(0xFFF8FAFC);
    final Color greyBoxBorder = isDark
        ? AppColors.darkBorder
        : const Color(0xFFF1F5F9);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ROW (Name, Breed, and Active Bird Count) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flock.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${flock.breed ?? 'Mixed'} • ${flock.birdType}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: greyBoxBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: greyBoxBorder),
                ),
                child: Column(
                  children: [
                    Text(
                      '${flock.currentCount}', // TIES DIRECTLY TO DATABASE
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ACTIVE BIRDS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // --- HEALTH SCORE SECTION ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health Score',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey.shade700,
                ),
              ),
              Text(
                '$healthScore%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: brandGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: healthScore / 100,
              backgroundColor: isDark
                  ? AppColors.darkBackground
                  : Colors.grey.shade200,
              color: brandGreen,
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 24),

          // --- STATS BOXES (Age & Last Fed) ---
          Row(
            children: [
              _buildStatBox(
                'AGE',
                ageString,
                greyBoxBg,
                greyBoxBorder,
                textDark,
              ),
              const SizedBox(width: 12),
              _buildStatBox(
                'LAST FED',
                lastFed,
                greyBoxBg,
                greyBoxBorder,
                textDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget to build the grey info boxes at the bottom
  Widget _buildStatBox(
    String title,
    String value,
    Color bg,
    Color border,
    Color textCol,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textCol,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
