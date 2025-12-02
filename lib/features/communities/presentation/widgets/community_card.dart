import 'package:flutter/material.dart';
import 'package:livria_user/features/communities/infrastructure/datasource/community_remote_datasource.dart';
import '../../domain/entities/community.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import '../pages/community_detail_page.dart';
import '../../../auth/infrastructure/datasource/auth_local_datasource.dart';
import '../../../auth/infrastructure/datasource/auth_remote_datasource.dart';
import '../../infrastructure/datasource/post_remote_datasource.dart';
import 'dart:convert';
import 'dart:typed_data';

class CommunityCard extends StatelessWidget {
  final Community community;

  const CommunityCard({
    super.key,
    required this.community,
  });

  Widget _buildPlaceholder(Community community, double borderRadius) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      child: Center(
        child: Icon(
          community.type == 1 ? Icons.people : Icons.book,
          color: AppColors.darkBlue,
          size: 40,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    const double borderRadius = 12.0;

    Widget imageContent;

    // 1. Si es URL de internet (http/https)
    if (community.image.startsWith('http')) {
      imageContent = Image.network(
        community.image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(community, borderRadius),
      );
    }
    // 2. Si es Base64 (data:image...)
    else if (community.image.startsWith('data:image')) {
      try {
        // Limpiamos el prefijo y decodificamos
        final base64String = community.image.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        imageContent = Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(community, borderRadius),
        );
      } catch (e) {
        imageContent = _buildPlaceholder(community, borderRadius);
      }
    }
    // 3. Si no es nada válido, mostramos placeholder
    else {
      imageContent = _buildPlaceholder(community, borderRadius);
    }


    return InkWell(
      onTap: () {
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
                child: imageContent,
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