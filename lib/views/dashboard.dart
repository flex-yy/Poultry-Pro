import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultrypro/viewModels/Providers/egg_provider.dart';
import 'package:poultrypro/viewModels/Providers/finance_provider.dart';
import 'package:poultrypro/viewModels/Providers/flock_provider.dart';
import 'package:poultrypro/views/dashboard/widgets/actions_card.dart';
import 'package:poultrypro/views/dashboard/widgets/net_profit_card.dart';
import 'package:poultrypro/views/dashboard/widgets/recent_act_item.dart';
import 'package:poultrypro/views/dashboard/widgets/top_stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(financeProvider);
    final eggLogs = ref.watch(eggProvider);
    final flocks = ref.watch(flockProvider);
    final totalBirds = flocks.fold(0, (sum, flock) => sum + flock.currentCount);

    final today = DateTime.now();
    int eggsToday = 0;
    for (var log in eggLogs) {
      if (log.date.year == today.year &&
          log.date.month == today.month &&
          log.date.day == today.day) {
        eggsToday += (log.totalEggs - log.badEggs);
      }
    }

    // Calculate net profit based on transactions
    double totalIncome = 0;
    double totalExpense = 0;
    for (var tx in transactions) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
      }
    }
    double netProfit = totalIncome - totalExpense;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 24.0,
              bottom: 8.0,
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(LucideIcons.bird, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'PoultryPro',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: Center(
                            child: Icon(LucideIcons.bell, size: 20),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    CircleAvatar(
                      backgroundColor: AppColors.primaryDark,
                      radius: 20,
                      child: Text(
                        'RK',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            // <--- 3. Expanded forces the scroll view to take remaining space below header
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 100.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TopStatCard(
                          title: 'TOTAL BIRDS',
                          value: totalBirds.toString(),
                          icon: LucideIcons.bird,
                          iconBgColor: AppColors.primaryLight,
                          iconColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TopStatCard(
                          title: 'EGGS TODAY',
                          value: eggsToday.toString(),
                          icon: LucideIcons.egg,
                          iconBgColor: Colors.orange.shade100,
                          iconColor: Colors.orange.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  NetProfitCard(netProfit: netProfit),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Action Needed',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ActionCard(
                          title: 'Newcastle Vaccination',
                          subtitle: 'Bravo Broilers • Due Today',
                          icon: LucideIcons.syringe,
                          backgroundColor: const Color(0xFFFFF1F2),
                          iconBackgroundColor: const Color(0xFFFFE4E6),
                          primaryTextColor: const Color(0xFF9F1239),
                          secondaryTextColor: const Color(
                            0xFFBE123C,
                          ).withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 12),
                        ActionCard(
                          title: 'Low Egg Yield Alert',
                          subtitle: 'Alpha Layers dropped 5% yesterday',
                          icon: LucideIcons.droplets,
                          backgroundColor: const Color(0xFFFFFBEB),
                          iconBackgroundColor: const Color(0xFFFEF3C7),
                          primaryTextColor: const Color(0xFF92400E),
                          secondaryTextColor: const Color(
                            0xFFB45309,
                          ).withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Recent Activity',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const RecentActivityItem(
                          title: 'Egg Sales (Wholesale)',
                          date: 'Jul 10, 2026 at 4:19 PM',
                          amount: '+₵4,500',
                          isIncome: true,
                          icon: LucideIcons.trendingUp,
                        ),
                        const SizedBox(height: 12),
                        const RecentActivityItem(
                          title: 'Feed Purchase (Mash)',
                          date: 'Jul 09, 2026 at 10:15 AM',
                          amount: '-₵1,200',
                          isIncome: false,
                          icon: LucideIcons.shoppingBag,
                        ),
                      ],
                    ),
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
