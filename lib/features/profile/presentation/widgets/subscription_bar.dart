import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../common/theme/app_colors.dart';
import '../providers/profile_provider.dart';

class SubscriptionBar extends StatelessWidget {
  final String currentPlan;

  const SubscriptionBar({super.key, required this.currentPlan});

  @override
  Widget build(BuildContext context) {
    final isCommunity = currentPlan.toLowerCase().contains('community');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.lightGrey, width: 1),
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TEXTO DEL PLAN ACTUAL
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("SUBSCRIPTION", style: TextStyle(color: AppColors.secondaryYellow, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(
                isCommunity ? "Community Plan" : "Free Plan",
                style: const TextStyle(color: AppColors.vibrantBlue, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ],
          ),

          // BOTÓN DE ACCIÓN
          if (isCommunity)
          // CASO 2: ESTÁS EN COMUNIDAD -> LEAVE
            TextButton(
              onPressed: () => _showLeaveDialog(context),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("LEAVE PLAN", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          else
          // CASO 1: ESTÁS EN FREE -> UPGRADE (Ir a pago)
            ElevatedButton(
              onPressed: () => context.push('/profile/subscription'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softTeal,
                foregroundColor: AppColors.darkBlue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text("UPGRADE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Leave Community Plan?"),
        content: const Text(
          "Are you sure? Your membership will remain active for 2 more weeks and then terminate. You will lose access to premium features.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final success = await context.read<ProfileProvider>().changeSubscriptionPlan("freeplan");

              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You have canceled your subscription."), backgroundColor: Colors.grey),
                );
              }
            },
            child: const Text("Confirm Leave", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}