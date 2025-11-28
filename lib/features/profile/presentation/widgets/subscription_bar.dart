import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';

class SubscriptionBar extends StatelessWidget {
  final String currentPlan;
  final Function(String) onPlanChanged;

  const SubscriptionBar({
    super.key,
    required this.currentPlan,
    required this.onPlanChanged
  });

  @override
  Widget build(BuildContext context) {
    final String selectedValue = (currentPlan.toLowerCase().contains('community'))
        ? 'communityplan'
        : 'freeplan';

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
          const Flexible(
            child: Text(
              "SUBSCRIPTION",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.secondaryYellow,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(width: 10),

          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.vibrantBlue),
              style: const TextStyle(
                color: AppColors.vibrantBlue,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onPlanChanged(newValue);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: 'freeplan',
                  child: Text("Free Plan"),
                ),
                DropdownMenuItem(
                  value: 'communityplan',
                  child: Text("Community Plan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}