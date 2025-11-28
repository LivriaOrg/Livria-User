import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TÍTULO "PROFILE"
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            "PROFILE",
            style: TextStyle(
              color: AppColors.softTeal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // IMAGEN DE PERFIL
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              user.icon,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.lightGrey,
                  child: const Icon(Icons.person, size: 60, color: AppColors.softTeal),
                );
              },
            ),
          ),
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
    );
  }
}