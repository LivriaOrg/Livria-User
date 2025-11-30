// Archivo: community_header.dart

import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import 'package:livria_user/common/utils/app_icons.dart';
import '../../domain/entities/community.dart';

class CommunityHeader extends StatelessWidget {
  final Community community;
  final String Function(int type) getCommunityTypeLabel;
  final VoidCallback onJoinPressed;
  final bool isJoined;

  const CommunityHeader({
    Key? key,
    required this.community,
    required this.getCommunityTypeLabel,
    required this.onJoinPressed,
    this.isJoined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... código de variables ...
    const double bannerHeight = 150;
    const double iconSize = 80;
    const double iconBottomMargin = 16;

    // Lógica para el botón
    final Color buttonColor = isJoined ? Colors.red[700]! : AppColors.primaryOrange;
    final String buttonText = isJoined ? 'LEAVE' : 'JOIN +';
    final Icon buttonIcon = isJoined
        ? const Icon(Icons.exit_to_app_rounded, size: 18, color: AppColors.white) // Icono de salir
        : const Icon(AppIcons.post, size: 18, color: AppColors.white); // Icono de post

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // BANNER
        Container(
          height: bannerHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.softTeal,
          ),
          child: Image.network(
            community.banner,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.softTeal.withOpacity(0.5),
              child: const Center(
                child: Text('Banner Image Failed', style: TextStyle(color: AppColors.darkBlue)),
              ),
            ),
          ),
        ),

        // CONTENIDO PRINCIPAL DE LA COMUNIDAD
        Padding(
          padding: EdgeInsets.only(top: bannerHeight - (iconBottomMargin + iconSize / 2), left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Ícono de la Comunidad
                  Container(
                    width: iconSize,
                    height: iconSize,
                    margin: const EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.primaryOrange, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(community.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Botón JOIN / LEAVE
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: onJoinPressed,
                    icon: buttonIcon, // Icono dinámico
                    label: Text(
                        buttonText, // Texto dinámico
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.white)
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor, // Color dinámico (Naranja o Rojo)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
              // ... resto del código del CommunityHeader ...
              const SizedBox(height: 12),
              Text(
                community.name.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkBlue,
                ),
              ),
              Text(
                getCommunityTypeLabel(community.type),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.secondaryYellow,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                community.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.black.withOpacity(0.7),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(height: iconBottomMargin + iconSize / 2),
      ],
    );
  }
}