import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';

class PostCard extends StatelessWidget {
  final Post post;
  final String userIconUrl;

  const PostCard({
    super.key,
    required this.post,
    required this.userIconUrl,
  });

  String _formatTimestamp(dynamic timestamp) {
    DateTime dateTime;
    try {
      if (timestamp == null) return 'Fecha desconocida';

      String utcTimestamp = timestamp is String
          ? (timestamp.endsWith('Z') ? timestamp : '${timestamp}Z')
          : timestamp.toString();

      dateTime = DateTime.parse(utcTimestamp).toLocal();

      return DateFormat('dd/MM/yyyy \'a las\' HH:mm').format(dateTime);
    } catch (e) {
      return 'Fecha desconocida';
    }
  }

  // Widget de utilidad para el Avatar (extraído para claridad)
  Widget _buildUserAvatar() {
    const double radius = 18;
    const String defaultIconUrl = 'https://cdn-icons-png.flaticon.com/512/3447/3447354.png';
    final String effectiveUrl = userIconUrl.isNotEmpty ? userIconUrl : defaultIconUrl;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.softTeal.withOpacity(0.2),
      child: ClipOval(
        child: Image.network(
          effectiveUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.account_circle,
            color: AppColors.softTeal,
            size: radius * 2,
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: SizedBox(
                width: radius * 1.5,
                height: radius * 1.5,
                child: CircularProgressIndicator(
                  color: AppColors.softTeal,
                  strokeWidth: 2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 12.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER: Avatar, Username y Timestamp
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar Simplificado
                _buildUserAvatar(),
                const SizedBox(width: 8),

                // Username y Timestamp
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${post.username}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    // Timestamp
                    Text(
                      _formatTimestamp(post.createdAt),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 2. CONTENIDO DEL POST (Texto)
            Text(
              post.content,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.black,
              ),
            ),

            // 3. IMAGEN DEL POST
            if (post.img != null && post.img!.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Builder(
                    builder: (context) {
                      final imageStr = post.img!;

                      // CASO A: Es Base64
                      if (imageStr.startsWith('data:image')) {
                        try {
                          final base64String = imageStr.split(',').last;
                          final Uint8List bytes = base64Decode(base64String);
                          return Image.memory(bytes, fit: BoxFit.cover, width: double.infinity);
                        } catch (e) {
                          return const SizedBox();
                        }
                      }
                      // CASO B: Es URL normal
                      else {
                        return Image.network(
                          imageStr,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            padding: const EdgeInsets.all(16),
                            color: AppColors.lightGrey,
                            child: const Center(child: Icon(Icons.broken_image)),
                          ),
                        );
                      }
                    }
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}