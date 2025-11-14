import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';
import '../../domain/entities/book.dart';


class BookFilterOptions {
  final double? minPrice;
  final double? maxPrice;
  final String? language;
  final SortBy sortBy;

  const BookFilterOptions({
    this.minPrice,
    this.maxPrice,
    this.language,
    this.sortBy = SortBy.none,
  });

  BookFilterOptions copyWith({
    double? minPrice,
    double? maxPrice,
    String? language,
    SortBy? sortBy,
  }) {
    return BookFilterOptions(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      language: language ?? this.language,
      sortBy: sortBy ?? this.sortBy,
    );
  }


  static String _norm(String s) {
    final lower = s.toLowerCase().trim();
    return lower
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }

  /// Aplica filtros + orden a una lista de libros
  List<Book> apply(List<Book> input) {
    Iterable<Book> out = input;

    if (minPrice != null) {
      out = out.where((b) => b.salePrice >= minPrice!);
    }
    if (maxPrice != null) {
      out = out.where((b) => b.salePrice <= maxPrice!);
    }

    if (language != null && language!.isNotEmpty) {
      final wanted = _norm(language!); // 'english' o 'espanol'
      out = out.where((b) => _norm(b.language) == wanted);
    }

    final list = out.toList();

    switch (sortBy) {
      case SortBy.priceAsc:
        list.sort((a, b) => a.salePrice.compareTo(b.salePrice));
        break;
      case SortBy.priceDesc:
        list.sort((a, b) => b.salePrice.compareTo(a.salePrice));
        break;
      case SortBy.titleAsc:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortBy.titleDesc:
        list.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case SortBy.none:
        break;
    }

    return list;
  }
}

enum SortBy { none, priceAsc, priceDesc, titleAsc, titleDesc }

class BookFiltersSheet extends StatefulWidget {
  final BookFilterOptions initial;
  const BookFiltersSheet({super.key, this.initial = const BookFilterOptions()});

  @override
  State<BookFiltersSheet> createState() => _BookFiltersSheetState();
}

class _BookFiltersSheetState extends State<BookFiltersSheet> {
  late double? _minPrice = widget.initial.minPrice;
  late double? _maxPrice = widget.initial.maxPrice;
  late String? _language = widget.initial.language;
  late SortBy _sortBy = widget.initial.sortBy;

  final _minCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_minPrice != null) _minCtrl.text = _minPrice!.toStringAsFixed(2);
    if (_maxPrice != null) _maxCtrl.text = _maxPrice!.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _apply() {

    double? minP =
    _minCtrl.text.trim().isEmpty ? null : double.tryParse(_minCtrl.text.trim());
    double? maxP =
    _maxCtrl.text.trim().isEmpty ? null : double.tryParse(_maxCtrl.text.trim());

    Navigator.of(context).pop(
      BookFilterOptions(
        minPrice: minP,
        maxPrice: maxP,
        language: _language,
        sortBy: _sortBy,
      ),
    );
  }

  void _clear() {
    setState(() {
      _minCtrl.clear();
      _maxCtrl.clear();
      _minPrice = null;
      _maxPrice = null;
      _language = null;
      _sortBy = SortBy.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final langs = const [

      ('English', 'english'),
      ('Español', 'español'),
    ];

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text('Filters',
                      style: t.headlineSmall?.copyWith(color: AppColors.darkBlue)),
                  const Spacer(),
                  TextButton(
                    onPressed: _clear,
                    child: const Text('Clean Filters'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Precio
              Text('Price Range', style: t.titleMedium?.copyWith(color: AppColors.darkBlue)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minCtrl,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Min',
                        prefixText: 'S/ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _minPrice = double.tryParse(v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _maxCtrl,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Max',
                        prefixText: 'S/ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _maxPrice = double.tryParse(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Idioma
              Text('Idioma', style: t.titleMedium?.copyWith(color: AppColors.darkBlue)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final (label, value) in langs)
                    ChoiceChip(
                      label: Text(label),
                      selected: _language == value,
                      onSelected: (sel) {
                        setState(() {
                          _language = sel ? value : null;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Orden
              Text('Order by', style: t.titleMedium?.copyWith(color: AppColors.darkBlue)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _sortChip('None', SortBy.none),
                  _sortChip('Price ↑', SortBy.priceAsc),
                  _sortChip('Price ↓', SortBy.priceDesc),
                  _sortChip('Title A-Z', SortBy.titleAsc),
                  _sortChip('Title Z-A', SortBy.titleDesc),
                ],
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply Filters',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortChip(String label, SortBy val) {
    return ChoiceChip(
      label: Text(label),
      selected: _sortBy == val,
      onSelected: (sel) => setState(() => _sortBy = sel ? val : SortBy.none),
    );
  }
}
