import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import 'smart_profile_image.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TÍTULO "PROFILE"
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Text(
              "PROFILE",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.softTeal,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      
          const SizedBox(height: 20),
      
          // IMAGEN DE PERFIL
          SmartProfileImage(
            imageData: user.icon,
            size: 120,
          ),
      
          const SizedBox(height: 16),
      
          // NOMBRE DE DISPLAY
          Text(
            user.display.toUpperCase(),
            style: const TextStyle(
              color: AppColors.vibrantBlue,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
      
          const SizedBox(height: 4),
      
          // USERNAME
          Text(
            "@${user.username}",
            style: const TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
      
          const SizedBox(height: 4),
      
          // EMAIL
          Text(
            user.email,
            style: const TextStyle(
              color: AppColors.secondaryYellow, // O accentGold
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
      
          const SizedBox(height: 12),
      
          // FRASE / BIO
          Text(
            '"${user.phrase}"',
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 13,
              height: 1.4, 
            ),
          ),
        ],
      ),
    );
  }
}