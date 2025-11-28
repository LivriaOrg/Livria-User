import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../orders/domain/entities/order.dart';
import '../providers/profile_provider.dart';

class MyOrdersTab extends StatelessWidget {
  const MyOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final orders = provider.orders;

    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.shopping_bag_outlined, size: 60, color: AppColors.darkBlue.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            "No orders yet",
            style: TextStyle(color: AppColors.darkBlue, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Go explore our books and make your first purchase!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final dateStr = "${order.date.day}/${order.date.month}/${order.date.year}";

    Color statusColor = AppColors.secondaryYellow;
    if (order.status.toLowerCase() == 'delivered') statusColor = Colors.green;
    if (order.status.toLowerCase() == 'cancelled') statusColor = AppColors.errorRed;
    if (order.status.toLowerCase() == 'pending') statusColor = AppColors.primaryOrange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CODE: ${order.code.isNotEmpty ? order.code : '#${order.id}'}",
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          const Divider(height: 24, thickness: 1, color: AppColors.lightGrey),

          // DETALLES
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(dateStr, style: const TextStyle(color: Colors.grey, fontSize: 13)),

              const Spacer(),

              Text(
                  "${order.items.length} Items",
                  style: const TextStyle(color: AppColors.darkBlue, fontSize: 13, fontWeight: FontWeight.w500)
              ),
            ],
          ),

          const SizedBox(height: 12),

          // PRECIO Y ACCIÓN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("TOTAL", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(
                    "S/ ${order.total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: AppColors.vibrantBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Icon(Icons.chevron_right, color: AppColors.softTeal),
            ],
          ),
        ],
      ),
    );
  }
}