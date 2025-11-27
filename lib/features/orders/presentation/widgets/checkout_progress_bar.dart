import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../common/theme/app_colors.dart';

class CheckoutProgressBar extends StatelessWidget {
  final int currentStep;

  const CheckoutProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIcon(context, 1, Icons.person), // User (Actual)
        const SizedBox(width: 15),
        _buildStepIcon(context, 2, FontAwesomeIcons.box), // Shipping
        const SizedBox(width: 15),
        _buildStepIcon(context, 3, Icons.credit_card), // Payment
      ],
    );
  }

  Widget _buildStepIcon(BuildContext context, int stepIndex, IconData icon) {
    final bool isActive = stepIndex == currentStep;

    final color = isActive ? AppColors.darkBlue : AppColors.secondaryYellow;
    final iconColor = isActive ? AppColors.white : AppColors.darkBlue;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}