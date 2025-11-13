import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../book/application/services/book_service.dart';
import '../../../book/domain/entities/book.dart';
import '../../../book/domain/repositories/book_repository_impl.dart';
import '../../../book/infrastructure/datasource/book_remote_datasource.dart';
import '../../../book/presentation/widgets/horizontal_book_card.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  late final BookService _bookService = BookService(
    BookRepositoryImpl(
      BookRemoteDataSource(),
    ),
  );

  late Future<List<Book>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = _bookService.getRandomBooks();
  }

  Future<void> _refreshRecommendations() async {
    setState(() {
      _recommendationsFuture = _bookService.getRandomBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RECOMMENDATIONS FOR YOU',
                    style: t.headlineLarge?.copyWith(
                      color: AppColors.vibrantBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hi! Based on your preferences, here are some recommendations...',
                    style: t.bodyLarge?.copyWith(
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We hope you like them! Remember, you can mark your interest in each book with the bookmark and negative icons, respectively.',
                    style: t.bodyLarge?.copyWith(
                      color: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _recommendationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error al cargar recomendaciones: ${snapshot.error}'));
                  }

                  final books = snapshot.data ?? [];

                  if (books.isEmpty) {
                    return const Center(child: Text('No se encontraron recomendaciones.'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.8,
                    ),
                    itemCount: books.length,
                    itemBuilder: (_, i) => HorizontalBookCard(books[i], t),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton(
                onPressed: _refreshRecommendations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vibrantBlue.withOpacity(0.7),
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'REFRESH',
                  style: t.labelLarge?.copyWith(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}