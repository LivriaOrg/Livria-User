// lib/features/book/presentation/pages/search_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../book/application/services/book_service.dart';
import '../../../book/domain/entities/book.dart';
import '../../../book/domain/repositories/book_repository_impl.dart';
import '../../../book/infrastructure/datasource/book_remote_datasource.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _service = BookService(BookRepositoryImpl(BookRemoteDataSource()));

  Timer? _debounce;
  String _query = '';
  late Future<List<Book>> _allBooksFuture;

  @override
  void initState() {
    super.initState();
    // ⚠️ Si en tu servicio el método se llama distinto, cámbialo aquí:
    _allBooksFuture = _service.getAllBooks(); // <- getAll() / getAllBooks()
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _query = _controller.text.trim();
      });
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
            // ----- Campo de búsqueda -----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Text(
                'SEARCH BY TITLE OR AUTHOR',
                style: t.bodyLarge?.copyWith(
                  color: AppColors.softTeal,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search a book…',
                  hintStyle: t.bodyMedium?.copyWith(color: Colors.black54),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: AppColors.softTeal, width: 1.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: AppColors.vibrantBlue, width: 1.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.search, color: AppColors.vibrantBlue),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ----- Header resultados -----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'RESULTS',
                    style: t.bodyLarge?.copyWith(
                      color: AppColors.primaryOrange,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.filter_list, color: AppColors.primaryOrange),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ----- Contenido -----
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _allBooksFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  final all = snap.data ?? const <Book>[];

                  // Si no hay query, opcionalmente puedes mostrar vacio o sugerencias
                  final results = _query.isEmpty
                      ? <Book>[]
                      : all.where((b) {
                    final q = _query.toLowerCase();
                    return b.title.toLowerCase().contains(q) ||
                        b.author.toLowerCase().contains(q);
                  }).toList();

                  if (_query.isNotEmpty && results.isEmpty) {
                    return Center(
                      child: Text(
                        'No results for “$_query”.',
                        style: t.bodyMedium,
                      ),
                    );
                  }

                  // Grid compacto de resultados (2 columnas)
                  return GridView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.05, // compacto tipo mock
                    ),
                    itemCount: results.length,
                    itemBuilder: (_, i) => _SearchResultCard(book: results[i]),
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

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Material(
      color: AppColors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          final bookId = Uri.encodeComponent(book.id.toString());
          GoRouter.of(context).go('/book/$bookId');
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Portada centrada
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        child: Image.network(
                          book.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.lightGrey,
                            alignment: Alignment.center,
                            width: 120,
                            height: 160,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Precio
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'S/ ${book.salePrice.toStringAsFixed(2)}',
                  style: t.bodyMedium?.copyWith(
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
