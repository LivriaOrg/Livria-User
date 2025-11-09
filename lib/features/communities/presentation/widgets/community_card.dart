import 'package:flutter/material.dart';
import 'package:livria_user/features/communities/infrastructure/datasource/community_remote_datasource.dart';
import '../../domain/entities/community.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import '../pages/community_detail_page.dart';
import '../../../auth/infrastructure/datasource/auth_local_datasource.dart';
import '../../../auth/infrastructure/datasource/auth_remote_datasource.dart';
import '../../infrastructure/datasource/post_remote_datasource.dart';


class CommunityCard extends StatelessWidget {
  final Community community;

  const CommunityCard({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 12.0;

    return InkWell(
      onTap: () {
        // LÓGICA DE NAVEGACIÓN A COMMUNITY DETAIL PAGE
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CommunityDetailPage(
              community: community,
              authLocalDataSource: AuthLocalDataSource(),
              authRemoteDataSource: AuthRemoteDataSource(),
              postRemoteDataSource: PostRemoteDataSource(),
              communityRemoteDataSource: CommunityRemoteDataSource(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(borderRadius)),
                child: Image.network(
                  community.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.lightGrey,
                    child: Center(
                      // Usamos un ícono o texto simple si la imagen falla
                      child: Icon(community.type == 1 ? Icons.people : Icons.book, color: AppColors.darkBlue),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Text(
                community.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}