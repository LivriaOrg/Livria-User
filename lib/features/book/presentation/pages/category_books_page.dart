import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../application/services/book_service.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository_impl.dart';
import '../../infrastructure/datasource/book_remote_datasource.dart';

class CategoryBooksPage extends StatelessWidget {
  final String genre;
  const CategoryBooksPage({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    final service = BookService(BookRepositoryImpl(BookRemoteDataSource()));
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (AsapCondensed)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    genre.toUpperCase(),
                    style: t.headlineMedium?.copyWith(
                      color: AppColors.primaryOrange,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.filter_list, color: AppColors.primaryOrange),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: service.getByGenre(genre),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }

                  final books = snap.data ?? const [];
                  if (books.isEmpty) {
                    return const Center(child: Text('No books for this category'));
                  }

                  // Grid de 2 columnas con celdas horizontales
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      // Card horizontal ⇒ más ancho que alto
                      // (ancho/alto). Sube o baja si quieres más/menos altura.
                      childAspectRatio: 1.8,
                    ),
                    itemCount: books.length,
                    itemBuilder: (_, i) => _HorizontalBookCard(books[i], t),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalBookCard extends StatelessWidget {
  final Book b;
  final TextTheme t;
  const _HorizontalBookCard(this.b, this.t);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {/* TODO: navegar a detalle */},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Portada a la izquierda
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Image.network(
                    b.cover,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.lightGrey,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Texto a la derecha
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      b.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    // Autor
                    Text(
                      b.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(
                        color: AppColors.vibrantBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // Precio al fondo
                    Text(
                      'S/ ${b.salePrice.toStringAsFixed(2)}',
                      style: t.bodyMedium?.copyWith(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
