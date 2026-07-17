import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/views/shop/checkout_sheet.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define our catalog of farm products
    final List<Map<String, dynamic>> products = [
      {
        'name': 'Large Eggs (Tray)',
        'price': 45.00,
        'icon': Icons.egg_alt,
        'color': Colors.amber.shade600,
      },
      {
        'name': 'Medium Eggs (Tray)',
        'price': 40.00,
        'icon': Icons.egg,
        'color': Colors.orange.shade500,
      },
      {
        'name': 'Live Broiler (Big)',
        'price': 120.00,
        'icon': LucideIcons.bird,
        'color': Colors.red.shade500,
      },
      {
        'name': 'Live Broiler (Med)',
        'price': 90.00,
        'icon': LucideIcons.layers,
        'color': Colors.red.shade400,
      },
      {
        'name': 'Spent Layer (Old)',
        'price': 60.00,
        'icon': LucideIcons.feather,
        'color': Colors.purple.shade500,
      },
      {
        'name': 'Manure (50kg Bag)',
        'price': 25.00,
        'icon': LucideIcons.shovel,
        'color': Colors.brown.shade500,
      },
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farm Shop (PoS)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap an item to log a quick sale.',
                  style: TextStyle(color: AppColors.textHint, fontSize: 14),
                ),
              ],
            ),
          ),

          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    // Open the checkout bottom sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CheckoutSheet(
                        productName: product['name'],
                        basePrice: product['price'],
                        icon: product['icon'],
                        color: product['color'],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.04,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: product['color'].withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            product['icon'],
                            color: product['color'],
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₵${product['price'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
