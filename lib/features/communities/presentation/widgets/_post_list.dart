import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import '../../domain/entities/post.dart';
import 'post_card.dart';

class PostList extends StatelessWidget {
  final bool isLoadingPosts;
  final List<Post> posts;
  final String? currentUsername;
  final String? currentUserIconUrl;

  const PostList({
    Key? key,
    required this.isLoadingPosts,
    required this.posts,
    required this.currentUsername,
    required this.currentUserIconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoadingPosts) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      ));
    }

    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Text(
            'There are no posts in this community',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.black.withOpacity(0.5)
            ),
          ),
        ),
      );
    }

    final String defaultIcon = 'https://cdn-icons-png.flaticon.com/512/3447/3447354.png';

    final List<Post> reversedPosts = posts.reversed.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = reversedPosts[index];

        // Regla para el ícono: Si el post pertenece al usuario logueado, usar su ícono. Sino, usar el default.
        final String iconToUse = (currentUsername != null && post.username == currentUsername)
            ? currentUserIconUrl ?? defaultIcon
            : defaultIcon;

        return PostCard(
          post: post,
          userIconUrl: iconToUse,
        );
      },
    );
  }
}