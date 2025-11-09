import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../book/application/services/book_service.dart';
import '../../../book/infrastructure/datasource/book_remote_datasource.dart';
import '../../domain/repositories/book_repository_impl.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BookService(BookRepositoryImpl(BookRemoteDataSource()));
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: service.getGenres(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }
            final genres = snap.data ?? const [];
            if (genres.isEmpty) {
              return const Center(child: Text('No categorias encontradas'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'BUSQUEDA POR CATEGORIA',
                    style: text.bodyLarge?.copyWith(
                      color: AppColors.softTeal,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),


                Expanded(
                  child: ListView.separated(
                    itemCount: genres.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    separatorBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    itemBuilder: (context, i) {
                      final genre = genres[i];
                      return InkWell(
                        onTap: () =>
                            context.go('/categories/${Uri.encodeComponent(genre)}'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  genre.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: text.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: _colorForRow(i),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.vibrantBlue,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color _colorForRow(int i) {

    switch (i % 3) {
      case 0:
        return AppColors.vibrantBlue;
      case 1:
        return AppColors.primaryOrange;
      default:
        return AppColors.secondaryYellow;
    }
  }
}
