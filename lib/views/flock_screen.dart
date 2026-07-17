import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultrypro/viewModels/Providers/flock_provider.dart';
import 'package:poultrypro/views/flocks/widgets/flock_card.dart';

class FlocksScreen extends ConsumerStatefulWidget {
  const FlocksScreen({super.key});

  @override
  ConsumerState<FlocksScreen> createState() => _FlocksScreenState();
}

class _FlocksScreenState extends ConsumerState<FlocksScreen> {
  // We need state to track which tab is active (0 = Active, 1 = Archived)
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. WATCH the provider to get ALL flocks
    final allFlocks = ref.watch(flockProvider);

    // 2. Filter the flocks based on the active tab!
    // Active = more than 0 birds. Archived = 0 birds left.
    final displayedFlocks = allFlocks.where((flock) {
      if (_activeTabIndex == 0) {
        return flock.currentCount > 0;
      } else {
        return flock.currentCount <= 0;
      }
    }).toList();

    // Check if we are in dark mode for dynamic text colors
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          // --- FIXED HEADER SECTION ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flock Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // 1. Search Bar Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search batches...',
                            hintStyle: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              LucideIcons.search,
                              color: AppColors.textHint,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Filter Button
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          LucideIcons.slidersHorizontal,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          // Filter functionality
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Segmented Tabs
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFF1F5F9), // Slate 700 or Slate 100
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Active Tab Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTabIndex = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _activeTabIndex == 0
                                  ? Theme.of(context).colorScheme.surface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _activeTabIndex == 0
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                // Update this text to show dynamic count of ONLY active flocks!
                                'Active (${allFlocks.where((f) => f.currentCount > 0).length})',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: _activeTabIndex == 0
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: _activeTabIndex == 0
                                      ? (isDark
                                            ? Colors.white
                                            : AppColors.textPrimary)
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Archived Tab Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTabIndex = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _activeTabIndex == 1
                                  ? Theme.of(context).colorScheme.surface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _activeTabIndex == 1
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                // Update this text to show dynamic count of ONLY archived flocks!
                                'Archived (${allFlocks.where((f) => f.currentCount <= 0).length})',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: _activeTabIndex == 1
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: _activeTabIndex == 1
                                      ? (isDark
                                            ? Colors.white
                                            : AppColors.textPrimary)
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- SCROLLABLE LIST SECTION ---
          Expanded(
            // 3. Use the displayedFlocks variable instead of the full list!
            child: displayedFlocks.isEmpty
                ? Center(
                    child: Text(
                      _activeTabIndex == 0
                          ? "No active flocks."
                          : "No archived flocks.",
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 100,
                      top: 8,
                    ),
                    // Dynamically map our FILTERED data models!
                    children: displayedFlocks.map((flock) {
                      // Calculate age dynamically
                      final days = DateTime.now()
                          .difference(flock.dateAdded)
                          .inDays;
                      final ageString = days > 14
                          ? 'Week ${days ~/ 7}'
                          : 'Day $days';

                      return FlockCard(
                        status: _activeTabIndex == 0
                            ? 'Active'
                            : 'Depleted', // Change status badge text
                        id: '#BATCH-${flock.id.toString().padLeft(3, '0')}',
                        name: flock.name,
                        details:
                            '${flock.breed ?? 'Mixed'} • Housed ${flock.dateAdded.month}/${flock.dateAdded.day}',
                        age: ageString,
                        birdCount: flock.currentCount.toString(),
                        metricText: 'Initial: ${flock.initialCount}',
                        accentColor: AppColors.primary,
                        statusBgColor: AppColors.primaryLight,
                        statusTextColor: AppColors.primaryDark,
                        metricIcon: LucideIcons.barChart2,
                        metricIconColor: AppColors.primary,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
