import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultrypro/viewModels/Providers/egg_provider.dart';
import 'package:poultrypro/viewModels/Providers/finance_provider.dart';
import 'package:poultrypro/viewModels/Providers/flock_provider.dart';
import 'package:poultrypro/viewModels/Providers/health_provider.dart';
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
    final healthLogs = ref.watch(healthProvider);

    final today = DateTime.now();
    int eggsToday = 0;
    int totalBadEggs = 0;
    int totalNoEggs = 0;
    for (var log in eggLogs) {
      totalBadEggs = log.badEggs;
      // totalNoEggs = (log.totalEggs - log.badEggs);
      totalNoEggs = log.totalEggs;
      if (log.date.year == today.year &&
          log.date.month == today.month &&
          log.date.day == today.day) {
        eggsToday += (log.totalEggs - log.badEggs);
      }
    }
    int totalMortality = 0;
    for (var log in healthLogs) {
      if (log.isMortality && log.birdsLost != null) {
        totalMortality += log.birdsLost!;
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
                          value: '$eggsToday / $totalNoEggs',
                          icon: LucideIcons.egg,
                          iconBgColor: Colors.orange.shade100,
                          iconColor: Colors.orange.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Spacing between rows
                  // --- 3. Top Stats Row 2 (NEW) ---
                  Row(
                    children: [
                      Expanded(
                        child: TopStatCard(
                          title: 'TOTAL BAD EGGS',
                          value: totalBadEggs.toString(),
                          icon: Icons.egg_alt,
                          iconColor: Colors.brown.shade600,
                          iconBgColor: Colors.brown.shade100,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TopStatCard(
                          title: 'TOTAL MORTALITY',
                          value: totalMortality.toString(),
                          icon: LucideIcons.activity,
                          iconColor: AppColors.error,
                          iconBgColor: AppColors.error.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

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

                        if (transactions.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Center(
                              child: Text(
                                'No financial activity logged yet.',
                                style: TextStyle(color: AppColors.textHint),
                              ),
                            ),
                          )
                        else
                          // 2. Loop through transactions, take the latest 3, and display them!
                          ...transactions.take(3).map((tx) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: RecentActivityItem(
                                title: tx.category,
                                date:
                                    '${tx.date.day}/${tx.date.month}/${tx.date.year}', // Format the real date
                                amount:
                                    '${tx.isIncome ? '+' : '-'}₵${tx.amount.toStringAsFixed(2)}',
                                isIncome: tx.isIncome,
                                icon: tx.isIncome
                                    ? LucideIcons.trendingUp
                                    : LucideIcons.shoppingBag,
                              ),
                            );
                          }),

                        // const RecentActivityItem(
                        //   title: 'Egg Sales (Wholesale)',
                        //   date: 'Jul 10, 2026 at 4:19 PM',
                        //   amount: '+₵4,500',
                        //   isIncome: true,
                        //   icon: LucideIcons.trendingUp,
                        // ),
                        // const SizedBox(height: 12),
                        // const RecentActivityItem(
                        //   title: 'Feed Purchase (Mash)',
                        //   date: 'Jul 09, 2026 at 10:15 AM',
                        //   amount: '-₵1,200',
                        //   isIncome: false,
                        //   icon: LucideIcons.shoppingBag,
                        // ),
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
