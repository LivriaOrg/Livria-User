import 'package:flutter/material.dart';

// Importaciones necesarias para la arquitectura
import '../../../../common/theme/app_colors.dart';
import '../../../book/application/services/book_service.dart';
import '../../../book/domain/entities/book.dart';
import '../../../book/domain/repositories/book_repository_impl.dart';
import '../../../book/infrastructure/datasource/book_remote_datasource.dart';
// Importación del widget de tarjeta reutilizable (cambiado a HorizontalBookCard)
import '../../../book/presentation/widgets/horizontal_book_card.dart';

// =========================================================================

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  // Inicialización de la cadena de servicios
  late final BookService _bookService = BookService(
    BookRepositoryImpl(
      BookRemoteDataSource(),
    ),
  );

  late Future<List<Book>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    // Iniciar la carga de los 4 libros aleatorios al inicio
    _recommendationsFuture = _bookService.getRandomBooks();
  }

  /// Refresca la lista de recomendaciones volviendo a llamar al servicio.
  Future<void> _refreshRecommendations() async {
    setState(() {
      // Reasigna el Future para disparar una nueva llamada a la API
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

                  // Grid de 2 columnas con celdas horizontales
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      // Aspect ratio idéntico al usado en CategoryBooksPage
                      childAspectRatio: 1.8,
                    ),
                    itemCount: books.length,
                    // Utilizamos HorizontalBookCard y pasamos argumentos posicionales (b, t)
                    itemBuilder: (_, i) => HorizontalBookCard(books[i], t),
                  );
                },
              ),
            ),
            // Botón de refresco centrado debajo de la cuadrícula de libros
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton(
                onPressed: _refreshRecommendations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vibrantBlue.withOpacity(0.7), // Color de fondo azul claro
                  foregroundColor: AppColors.white, // Color del texto
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Bordes redondeados
                  ),
                  elevation: 5, // Sombra suave
                ),
                child: Text(
                  'REFRESH',
                  style: t.labelLarge?.copyWith(
                    color: AppColors.darkBlue, // Color del texto según la imagen
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