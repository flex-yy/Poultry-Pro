import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/views/tasks&health/widgets/day_item.dart';
import 'package:poultrypro/views/tasks&health/widgets/timeline_task_item.dart';
import 'package:poultrypro/views/tasks&health/widgets/urgent_task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // Track which date is currently selected in the calendar
  int _selectedDate = 14;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              // Subtle shadow to lift the header above the scrolling content
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
                // 1. Title Row
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
                    // Circular Calendar Icon Button
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
                        onPressed: () {
                          // Would be added soon
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. Weekly Calendar Strip
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
                  // 1. Action Required Section
                  Row(
                    children: const [
                      Icon(
                        LucideIcons.alertTriangle,
                        size: 16,
                        color: AppColors.error,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'ACTION REQUIRED',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const UrgentTaskCard(
                    title: 'Gumboro (IBD) Vaccine',
                    flockName: 'Batch C - Broilers',
                    dateMissed: 'Monday, Jul 12',
                  ),
                  const SizedBox(height: 32),

                  // 2. Today's Timeline Section
                  const Text(
                    'TODAY, JUL 14',
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
                        left: 23, // Centered behind the 48px icons
                        top: 16,
                        bottom: 32,
                        child: Container(
                          width: 2,
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.border,
                        ),
                      ),

                      // The List of Task Items
                      Column(
                        children: [
                          const TimelineTaskItem(
                            title: 'Morning Feeding',
                            time: '07:00 AM',
                            subtitle: 'All Active Flocks (Added 120kg Mash)',
                            icon: LucideIcons.wheat,
                            iconColor: AppColors.primary,
                            iconBgColor: AppColors.primaryLight,
                            isCompleted: true,
                          ),
                          TimelineTaskItem(
                            title: 'Routine Health Check',
                            time: '10:00 AM',
                            subtitle: 'Batch B - Investigate mortality drop',
                            icon: LucideIcons.activity,
                            iconColor: Colors.amber.shade600,
                            iconBgColor: Colors.amber.shade100,
                          ),
                          TimelineTaskItem(
                            title: 'Water Vitamins (Day 3)',
                            time: '02:00 PM',
                            subtitle: 'Batch A - Layers',
                            icon: LucideIcons.pill,
                            iconColor: Colors.purple.shade600,
                            iconBgColor: Colors.purple.shade100,
                          ),
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
