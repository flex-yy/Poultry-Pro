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
    // 1. WATCH the provider. Whenever the data changes, this screen automatically rebuilds!
    final flocksList = ref.watch(flockProvider);
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
                          // would be implemented soon
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
                        ? AppColors.darkBorder
                        : AppColors.lightBorder, // Slate 700 or Slate 100
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
                                'Active (${flocksList.length})',
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
                                'Archived',
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

          // --- SCROLLABLE LIST SECTION (Placeholder) ---
          Expanded(
            child: flocksList.isEmpty
                ? Center(child: Text('No flocks available.'))
                : ListView(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 100,
                      top: 8,
                    ),
                    children: flocksList.map((flock) {
                      final days = DateTime.now()
                          .difference(flock.dateAdded)
                          .inDays;
                      final ageString = days > 14
                          ? 'Week ${days ~/ 7}'
                          : 'Day $days';
                      return FlockCard(
                        status: 'Active',
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

            // children: [
            //   FlockCard(
            //     status: 'Active',
            //     id: '#LAY-2023-A',
            //     name: 'Batch A - Layers',
            //     details: 'Isa Brown • Housed Oct 12',
            //     age: 'Week 32',
            //     birdCount: '2,450',
            //     metricText: 'Production: 92% today',
            //     accentColor: AppColors.primary,
            //     statusBgColor: AppColors.primaryLight,
            //     statusTextColor: AppColors.primaryDark,
            //     metricIcon: LucideIcons.trendingUp,
            //     metricIconColor: AppColors.primary,
            //   ),
            //   FlockCard(
            //     status: 'Active',
            //     id: '#BRO-2024-C',
            //     name: 'Batch C - Broilers',
            //     details: 'Cobb 500 • Housed Jan 05',
            //     age: 'Day 28',
            //     birdCount: '1,000',
            //     metricText: 'Target Weight: 1.8 kg avg',
            //     accentColor: Colors.blue.shade500,
            //     statusBgColor: Colors.blue.shade50,
            //     statusTextColor: Colors.blue.shade700,
            //     metricIcon: LucideIcons.scale,
            //     metricIconColor: Colors.blue.shade500,
            //   ),
            //   FlockCard(
            //     status: 'Needs Review',
            //     id: '#LAY-2022-B',
            //     name: 'Batch B - Older Layers',
            //     details: 'Lohmann Brown • Housed Mar 20',
            //     age: 'Week 72',
            //     birdCount: '840',
            //     metricText: 'Production dropped below 60%',
            //     accentColor: Colors.amber.shade500,
            //     statusBgColor: Colors.amber.shade50,
            //     statusTextColor: Colors.amber.shade800,
            //     metricIcon: LucideIcons.alertCircle,
            //     metricIconColor: Colors.amber.shade600,
            //   ),
            // ],
          ),
        ],
      ),
    );
  }
}
