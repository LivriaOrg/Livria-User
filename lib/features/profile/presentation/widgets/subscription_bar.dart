import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';

class SubscriptionBar extends StatelessWidget {
  final String planName;

  const SubscriptionBar({super.key, required this.planName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
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
          // ETIQUETA "SUBSCRIPTION"
          const Text(
            "SUBSCRIPTION",
            style: TextStyle(
              color: AppColors.secondaryYellow,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),

          // NOMBRE DEL PLAN
          Text(
            planName,
            style: const TextStyle(
              color: AppColors.vibrantBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}