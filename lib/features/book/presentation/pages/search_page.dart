import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/theme/app_colors.dart';
import '../../application/services/book_service.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository_impl.dart';
import '../../infrastructure/datasource/book_remote_datasource.dart';
import '../widgets/book_filters_sheet.dart';

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


  BookFilterOptions _filters = const BookFilterOptions();

  @override
  void initState() {
    super.initState();
    _allBooksFuture = _service.getAllBooks();
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

  Future<void> _openFilters() async {
    final applied = await showModalBottomSheet<BookFilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BookFiltersSheet(initial: _filters),
    );
    if (applied != null && mounted) {
      setState(() => _filters = applied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header de búsqueda ---
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
              child: Text(
                'BÚSQUEDA POR TÍTULO O AUTOR',
                style: t.headlineMedium?.copyWith(
                  color: AppColors.softTeal,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Buscar un libro…',
                  hintStyle: t.bodyMedium?.copyWith(color: Colors.black54),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: AppColors.accentGold, width: 1.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.vibrantBlue, width: 1.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.search, color: AppColors.vibrantBlue),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 2, color: AppColors.lightGrey),
            const SizedBox(height: 16),
            // --- Encabezado de resultados ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Text(
                    'RESULTADOS',
                    style: t.bodyLarge?.copyWith(
                      color: AppColors.primaryOrange,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _openFilters,
                    icon: const Icon(Icons.filter_list,
                        color: AppColors.primaryOrange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

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

                  // filtrar por query
                  var results = _query.isEmpty
                      ? <Book>[]
                      : all.where((b) {
                    final q = _query.toLowerCase();
                    return b.title.toLowerCase().contains(q) ||
                        b.author.toLowerCase().contains(q);
                  }).toList();

                  // aplicar filtros
                  results = _filters.apply(results);

                  if (_query.isNotEmpty && results.isEmpty) {
                    return Center(
                      child: Text(
                        'No resultados para “$_query”.',
                        style: t.bodyMedium,
                      ),
                    );
                  }


                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 8),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.8,
                    ),
                    itemCount: results.length,
                    itemBuilder: (_, i) =>
                        _HorizontalBookCard(results[i], t),
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
        onTap: () {
          final bookId = Uri.encodeComponent(b.id.toString());
          GoRouter.of(context).go('/book/$bookId');
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBlue,
                      ),
                    ),
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
