import 'package:flutter/material.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultrypro/views/dashboard.dart';
import 'package:poultrypro/views/finances_screen.dart';
import 'package:poultrypro/views/flock_screen.dart';
import 'package:poultrypro/views/shared/bottom_sheets/log_collection_sheet.dart';
import 'package:poultrypro/views/shared/bottom_sheets/log_feed_sheet.dart';
import 'package:poultrypro/views/shared/bottom_sheets/log_health_sheet.dart';
import 'package:poultrypro/views/shared/bottom_sheets/new_transaction_sheet.dart';
import 'package:poultrypro/views/shared/bottom_sheets/register_flock_sheet.dart';
import 'package:poultrypro/views/shopscreen.dart';
import 'package:poultrypro/views/tasks_screen.dart';

// Import our individual tab views (We will build these next!)
// import '../dashboard/dashboard_screen.dart';
// import '../flocks/flocks_screen.dart';
// import '../tasks/tasks_screen.dart';
// import '../finances/finances_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  // 1. State variable to track the currently selected tab
  int _currentIndex = 0;

  // 2. A list of widgets representing the body for each tab
  final List<Widget> _pages = [
    // We use placeholder containers until we build the actual screens
    DashboardScreen(),
    FlocksScreen(),
    TasksScreen(),
    FinancesScreen(),
    ShopScreen(),
  ];

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Material(
        // Changed from Container to Material
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          // Added Padding widget
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What would you like to log?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFE492),
                  child: Icon(LucideIcons.egg, color: Color(0xFF9E7C3E)),
                ),
                title: const Text(
                  'Log Egg Collection',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context); // Close menu
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const LogCollectionSheet(),
                  );
                },
              ),

              // Feed (NEW)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.shade100,
                  child: Icon(Icons.grass, color: Colors.amber.shade700),
                ),
                title: const Text(
                  'Log Feed Usage',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const LogFeedSheet(),
                  );
                },
              ),

              // Health / Mortality (NEW)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.error.withValues(alpha: 0.1),
                  child: const Icon(
                    LucideIcons.activity,
                    color: AppColors.error,
                  ),
                ),
                title: const Text(
                  'Log Health / Mortality',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const LogHealthSheet(),
                  );
                },
              ),

              // Finance
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.attach_money, color: Color(0xFF1CB581)),
                ),
                title: const Text(
                  'New Transaction',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const NewTransactionSheet(),
                  );
                },
              ),

              // Register Flock
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryDark,
                  child: Icon(LucideIcons.bird, color: Colors.white),
                ),
                title: const Text(
                  'Register New Flock',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const RegisterFlockSheet(),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body dynamically changes based on _currentIndex
      body: _pages[_currentIndex],

      // Floating Action Button (FAB) positioned above the bottom nav
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showActionMenu(context);
        },
        backgroundColor: AppColors.primaryDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      // Customize FAB location
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // The Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed, // Prevents shifting animation
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primaryDark,
            unselectedItemColor: AppColors.textHint,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            items: [
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(LucideIcons.home),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    LucideIcons.home,
                  ), // Consider filled versions later
                ),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(LucideIcons.layers),
                ),
                label: 'Flocks',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(LucideIcons.calendarCheck),
                ),
                label: 'Tasks',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(LucideIcons.wallet),
                ),
                label: 'Finance',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(LucideIcons.store),
                ),
                label: 'Shop',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
