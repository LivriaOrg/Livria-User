import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';
import '../../domain/entities/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final Color usernameColor = AppColors.primaryOrange;
    final Color contentColor = AppColors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: Column(
        children: [
          // Tarjeta de Contenido de la Reseña
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.lightGrey)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila Superior: Avatar, Usuario y Estrellas
                Row(
                  children: [
                    // Avatar
                    const CircleAvatar(
                      radius: 18,
                      // TODO: Conectar con el usuario loggeado para poner la img correcta
                      backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3447/3447354.png'),
                      backgroundColor: AppColors.lightGrey,
                    ),
                    const SizedBox(width: 10.0),

                    // Usuario
                    Text(
                      '@${review.username}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: usernameColor,
                      ),
                    ),
                    const Spacer(),

                    // Estrellas
                    Text(
                        review.stars.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentGold
                        )
                    ),
                    const Icon(Icons.star, color: AppColors.accentGold, size: 16),
                  ],
                ),

                const SizedBox(height: 8.0),

                // Contenido de la Reseña
                Text(
                  review.content,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
          // Separación entre tarjetas
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}