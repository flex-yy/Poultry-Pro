import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/viewModels/Providers/feed_provider.dart';
import 'package:poultrypro/viewModels/Providers/flock_provider.dart';
import 'package:poultrypro/viewModels/Providers/health_provider.dart';
import 'package:poultrypro/views/tasks&health/widgets/day_item.dart';
import 'package:poultrypro/views/tasks&health/widgets/timeline_task_item.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  // Track which date is currently selected in the calendar
  int _selectedDate = 14;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final healthLogs = ref.watch(healthProvider);
    final feedLogs = ref.watch(feedProvider);
    final flocks = ref.watch(flockProvider);

    return SafeArea(
      child: Column(
        children: [
          // --- HEADER & CALENDAR STRIP ---
          Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasks & Health',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: IconButton(
                        icon: const Icon(LucideIcons.calendarDays, size: 20),
                        color: AppColors.textSecondary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DayItem(
                      dayName: 'Mo',
                      date: 12,
                      isActive: false,
                      onTap: () => setState(() => _selectedDate = 12),
                    ),
                    DayItem(
                      dayName: 'Tu',
                      date: 13,
                      isActive: false,
                      onTap: () => setState(() => _selectedDate = 13),
                    ),
                    DayItem(
                      dayName: 'We',
                      date: 14,
                      isActive: _selectedDate == 14,
                      onTap: () => setState(() => _selectedDate = 14),
                    ),
                    DayItem(
                      dayName: 'Th',
                      date: 15,
                      isActive: _selectedDate == 15,
                      dotColor: Colors.purple.shade400,
                      onTap: () => setState(() => _selectedDate = 15),
                    ),
                    DayItem(
                      dayName: 'Fr',
                      date: 16,
                      isActive: _selectedDate == 16,
                      dotColor: AppColors.primary,
                      onTap: () => setState(() => _selectedDate = 16),
                    ),
                    DayItem(
                      dayName: 'Sa',
                      date: 17,
                      isActive: false,
                      onTap: () => setState(() => _selectedDate = 17),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- SCROLLABLE TASKS LIST ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RECENT LOGS & TASKS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHint,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // The Timeline Stack
                  Stack(
                    children: [
                      // The continuous vertical background line
                      Positioned(
                        left: 23,
                        top: 16,
                        bottom: 32,
                        child: Container(
                          width: 2,
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.border,
                        ),
                      ),

                      // Dynamic List of Database Items
                      Column(
                        children: [
                          if (healthLogs.isEmpty && feedLogs.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(
                                child: Text(
                                  'No recent activity logged.',
                                  style: TextStyle(color: AppColors.textHint),
                                ),
                              ),
                            ),

                          // Map over the Health Logs from SQLite
                          ...healthLogs.map((log) {
                            // Find the flock name, or default to generic text if not found
                            final flockName = flocks.isNotEmpty
                                ? flocks
                                      .firstWhere(
                                        (f) => f.id == log.flockId,
                                        orElse: () => flocks.first,
                                      )
                                      .name
                                : 'Unknown Batch';

                            return TimelineTaskItem(
                              title: log.isMortality
                                  ? 'Mortality Recorded'
                                  : 'Vaccination / Meds',
                              time:
                                  '${log.date.hour}:${log.date.minute.toString().padLeft(2, '0')}',
                              subtitle: log.isMortality
                                  ? '$flockName - Lost ${log.birdsLost} birds (${log.details})'
                                  : '$flockName - ${log.details}',
                              icon: log.isMortality
                                  ? LucideIcons.alertTriangle
                                  : LucideIcons.pill,
                              iconColor: log.isMortality
                                  ? AppColors.error
                                  : Colors.purple.shade600,
                              iconBgColor: log.isMortality
                                  ? AppColors.error.withValues(alpha: 0.1)
                                  : Colors.purple.shade100,
                              isCompleted: true,
                            );
                          }),

                          // Map over the Feed Logs from SQLite
                          ...feedLogs.map((log) {
                            final flockName = flocks.isNotEmpty
                                ? flocks
                                      .firstWhere(
                                        (f) => f.id == log.flockId,
                                        orElse: () => flocks.first,
                                      )
                                      .name
                                : 'Unknown Batch';

                            return TimelineTaskItem(
                              title: 'Feed Logged',
                              time:
                                  '${log.date.hour}:${log.date.minute.toString().padLeft(2, '0')}',
                              subtitle:
                                  '$flockName - ${log.quantityKg}kg of ${log.feedType}',
                              icon: LucideIcons.wheat,
                              iconColor: AppColors.primary,
                              iconBgColor: AppColors.primaryLight,
                              isCompleted: true,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
