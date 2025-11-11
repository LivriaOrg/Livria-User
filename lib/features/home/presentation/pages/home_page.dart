import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importación del widget de tarjeta horizontal compartido
import '../../../book/presentation/widgets/horizontal_book_card.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../book/application/services/book_service.dart';
import '../../../book/domain/entities/book.dart';
import '../../../book/domain/repositories/book_repository_impl.dart';
import '../../../book/infrastructure/datasource/book_remote_datasource.dart';
import '../../application/services/home_service.dart';

// =========================================================================
// 1. WIDGET PRINCIPAL (STATELESS) - El envoltorio público
// =========================================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // El widget principal ahora es Stateless y provee el Scaffold sin AppBar.
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: _HomeView(), // El cuerpo que maneja la lógica de estado y carga de datos.
    );
  }
}

// =========================================================================
// 2. WIDGET DE VISTA (STATEFUL) - Contiene la lógica de datos
// =========================================================================

class _HomeView extends StatefulWidget {
  const _HomeView({super.key});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  // Inicialización de la cadena de servicios de forma manual (como en otros archivos)
  late final BookService _bookService = BookService(
    BookRepositoryImpl(
      BookRemoteDataSource(),
    ),
  );

  // HomeService como fachada, dependiendo del BookService
  late final HomeService _homeService = HomeService(_bookService);

  // Datos cargados una sola vez en initState
  late Future<List<Book>> _allBooksFuture;
  late Future<List<String>> _genresFuture;

  @override
  void initState() {
    super.initState();
    // 1. Obtener la lista completa de libros
    _allBooksFuture = _bookService.getAllBooks();
    // 2. Obtener la lista de géneros
    _genresFuture = _homeService.getAllGenres();
  }

  // Lógica para rotar los colores de las secciones (permanece en el State)
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

  /// Construye el carrusel horizontal para una categoría específica.
  Widget _buildCategoryCarousel(
      BuildContext context,
      String genre,
      List<Book> allBooks,
      int index,
      ) {
    // Filtrar los libros en memoria por el género actual
    final genreBooks = allBooks
        .where((b) => b.genre.toLowerCase() == genre.toLowerCase())
        .toList();

    if (genreBooks.isEmpty) {
      return const SizedBox.shrink();
    }

    final sectionColor = _colorForRow(index);

    // 🚀 CÁLCULO DE ANCHO USANDO EL ENFOQUE DE ROW 🚀
    final screenWidth = MediaQuery.of(context).size.width;

    // Espacio fijo que reservaremos para cada flecha (usado en SizedBox)
    // 8.0 (padding para simetría con el título) + 30.0 (tamaño estimado del botón de flecha) = 38.0
    const double arrowReservedSpace = 30.0;
    const double totalSymmetricSpace = arrowReservedSpace * 2;

    // Padding lateral interno del ListView para alinear el primer/último elemento
    const double listViewPadding = 4.0;
    // Espacio entre tarjetas
    const double itemGap = 16.0;

    // Ancho disponible para el ListView (el centro del Row)
    final availableWidth = screenWidth - totalSymmetricSpace;

    // Ancho disponible para el contenido (ListView width - 2x padding interno)
    final availableContentWidth = availableWidth - (listViewPadding * 2);

    // AJUSTE CRUCIAL: itemWidth = (Ancho disponible para el contenido - Espacio entre items) / 2
    // Esto garantiza que dos items y el gap llenen el 100% del espacio visible.
    final itemWidth = (availableContentWidth - itemGap) / 2;

    // CÁLCULO DE ALTURA BASADO EN ASPECT RATIO (1.8):
    // El margen de 75.0 asegura que el precio y la sombra de la tarjeta no se corten.
    final carouselHeight = (itemWidth / 1.8) + 75.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la Categoría
        // Mantenemos el padding izquierdo de 24.0 para el título
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                genre.toUpperCase(),
                // Usamos headlineLarge (AsapCondensed w700) del tema.
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: sectionColor,
                  letterSpacing: 0.8,
                ),
              ),
              // Botón para ver todo (navega a la página de lista de categoría)
              TextButton(
                onPressed: () {
                  context.go('/categories/${Uri.encodeComponent(genre)}');
                },
                child: Text(
                  'Ver todo (${genreBooks.length})',
                  // Usamos bodyMedium (Alexandria w500) del tema.
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: sectionColor,
                    fontWeight: FontWeight.w600, // Sobrescribe a w600 (no en tema, pero mantiene la intención original)
                  ),
                ),
              ),
            ],
          ),
        ),

        // Carrusel de Libros con Flechas de Navegación (Ahora usa Row)
        _CategoryCarouselWithArrows(
          genreBooks: genreBooks,
          itemWidth: itemWidth,
          carouselHeight: carouselHeight,
          sectionColor: sectionColor,
          arrowReservedSpace: arrowReservedSpace, // Pasamos el nuevo espacio fijo (38.0)
          listViewPadding: listViewPadding, // Pasamos el nuevo padding (8.0)
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Devolvemos el FutureBuilder para géneros
    return FutureBuilder<List<String>>(
      future: _genresFuture,
      builder: (context, genresSnap) {
        if (genresSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (genresSnap.hasError) {
          return Center(child: Text('Error al cargar géneros: ${genresSnap.error}'));
        }

        final genres = genresSnap.data ?? [];

        // Anidar el FutureBuilder para cargar los libros una vez que los géneros estén listos
        return FutureBuilder<List<Book>>(
          future: _allBooksFuture,
          builder: (context, booksSnap) {
            if (booksSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (booksSnap.hasError) {
              return Center(child: Text('Error al cargar libros: ${booksSnap.error}'));
            }

            final allBooks = booksSnap.data ?? [];

            if (allBooks.isEmpty) {
              return const Center(child: Text('No hay contenido para mostrar.'));
            }

            // Llamar al componente Stateless que construye el cuerpo
            return _HomeContent(
              genres: genres,
              allBooks: allBooks,
              buildCategoryCarousel: _buildCategoryCarousel, // Pasar la función como callback
            );
          },
        );
      },
    );
  }
}

// =========================================================================
// 3. CONTENIDO PRINCIPAL (STATELESS) - Contiene el SingleChildScrollView
// =========================================================================

class _HomeContent extends StatelessWidget {
  final List<String> genres;
  final List<Book> allBooks;
  // Definimos el tipo de función que debe recibir
  final Widget Function(BuildContext, String, List<Book>, int) buildCategoryCarousel;

  const _HomeContent({
    required this.genres,
    required this.allBooks,
    required this.buildCategoryCarousel,
  });

  @override
  Widget build(BuildContext context) {
    // Construir la vista desplazable con los carruseles de cada género
    // El SingleChildScrollView permite que el contenido se desplace
    return SingleChildScrollView(
      // Aplicar padding solo en la parte superior para dejar espacio a la barra de estado
      // si no hay AppBar, aunque el banner ya está dentro del Safe Area por defecto.
      // Si el banner debe empezar justo donde termina el Safe Area, no necesitamos Padding aquí.
      child: Column(
        children: [
          // 🚀 BANNER DE COMUNIDAD EN LA PARTE SUPERIOR 🚀
          const _CommunityPlanBanner(),

          // Mapeo de los carruseles de categorías
          ...genres.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final genre = entry.value;
            // Llamar a la función del padre para construir el carrusel
            return buildCategoryCarousel(context, genre, allBooks, index);
          }).toList(),
        ],
      ),
    );
  }
}

// =========================================================================
// 4. WIDGET BANNER (STATELESS)
// =========================================================================

class _CommunityPlanBanner extends StatelessWidget {
  const _CommunityPlanBanner();

  @override
  Widget build(BuildContext context) {
    // Define el ancho total de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // *** Mantenido: Quitamos el margen superior (top: 0.0), manteniendo solo el inferior. ***
      margin: const EdgeInsets.only(bottom: 20.0),
      // Altura fija para el banner para mantener la consistencia
      height: 250,
      width: double.infinity, // Aseguramos que ocupe todo el ancho
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. Imagen de Fondo (logo_icon.png)
          Positioned(
            right: 0,
            bottom: 0,
            // La imagen ocupa un poco más que la mitad derecha
            width: screenWidth * 0.55,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/logo_icon.png', // Usando la ruta corregida
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Contenido (Texto y Botón)
          // Usamos Align para centrar el texto dentro del banner
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // *** RESTRICCIÓN DE ANCHO AL 50% (MANTENIDA) ***
              child: SizedBox(
                width: screenWidth * 0.50, // El texto solo ocupará el 50% del ancho
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Título (Amarillo y más espaciado)
                    Text(
                      'COMMUNITY PLAN',
                      // Usamos headlineLarge (AsapCondensed w700) del tema.
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.secondaryYellow,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Subtítulo
                    Text(
                      'Connect with other readers, share your thoughts and join spaces where reading come alive',
                      textAlign: TextAlign.center,
                      // Usamos bodyMedium (Alexandria w500) del tema.
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón
                    ElevatedButton(
                      onPressed: () {
                        // Acción al hacer clic en el botón
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 5,
                        // Borde menos redondeado (solicitud anterior)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'GET IT HERE',
                        // Usamos labelLarge (Alexandria w700) del tema.
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.darkBlue
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// =========================================================================
// WIDGETS DE NAVEGACIÓN Y CAROUSEL (MODIFICADO A ROW)
// =========================================================================

/// Widget stateful para manejar el ScrollController y las flechas de navegación
class _CategoryCarouselWithArrows extends StatefulWidget {
  final List<Book> genreBooks;
  final double itemWidth;
  final double carouselHeight;
  final Color sectionColor; // Parámetro para el color de la sección
  final double arrowReservedSpace; // Espacio total reservado en los lados (38.0)
  final double listViewPadding; // Nuevo padding interno para el ListView (8.0)

  const _CategoryCarouselWithArrows({
    required this.genreBooks,
    required this.itemWidth,
    required this.carouselHeight,
    required this.sectionColor,
    required this.arrowReservedSpace, // Requerido
    required this.listViewPadding, // Requerido
  });

  @override
  State<_CategoryCarouselWithArrows> createState() =>
      _CategoryCarouselWithArrowsState();
}

class _CategoryCarouselWithArrowsState
    extends State<_CategoryCarouselWithArrows> {
  late final ScrollController _scrollController;

  // Padding vertical para la sombra. Se mantiene en 16.0.
  static const double _verticalCarouselPadding = 10.0;
  // Ajuste: Nuevo padding para las flechas (8.0), que debe ser igual a listViewPadding
  static const double _arrowIconPadding = 8.0;
  // Espacio de separación entre tarjetas (padding derecho de HorizontalBookCard)
  static const double _itemGap = 16.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // LÓGICA DE SCROLL REVERTIDA PARA CORREGIR LA DIRECCIÓN
  void _scroll(double direction) {
    if (!_scrollController.hasClients) return;

    final maxExtent = _scrollController.position.maxScrollExtent;
    final minExtent = _scrollController.position.minScrollExtent;
    final currentOffset = _scrollController.offset;

    // La unidad de desplazamiento es exactamente el ancho de DOS tarjetas más el espacio entre ellas.
    // Usamos itemWidth + itemGap como unidad de desplazamiento para un scroll suave.
    // La unidad de desplazamiento es ahora exactamente el ancho de DOS tarjetas más DOS espacios de separación (16.0 * 2 = 32.0).
    final scrollUnit = (widget.itemWidth * 2.0) + (_itemGap * 2.0);
    final offsetDistance = scrollUnit * direction;

    final newOffset = currentOffset + offsetDistance;
    double targetOffset = newOffset;

    // 1. SCROLL HACIA LA DERECHA (direction > 0)
    if (direction > 0) {
      if (currentOffset == maxExtent) {
        // Si ya estamos al final y presionamos 'derecha', vamos al inicio (Looping)
        targetOffset = minExtent;
      } else {
        // En un scroll normal, aseguramos no pasarnos del final
        targetOffset = newOffset.clamp(minExtent, maxExtent);
      }
    }
    // 2. SCROLL HACIA LA IZQUIERDA (direction < 0)
    else if (direction < 0) {
      if (currentOffset == minExtent) {
        // Si ya estamos al inicio y presionamos 'izquierda', vamos al final (Looping)
        targetOffset = maxExtent;
      } else {
        // En un scroll normal, aseguramos no pasarnos del inicio
        targetOffset = newOffset.clamp(minExtent, maxExtent);
      }
    }

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Ahora, la flecha izquierda llama a scroll(-1) (mover hacia la izquierda)
  void _scrollLeft() => _scroll(-1);
  // Y la flecha derecha llama a scroll(1) (mover hacia la derecha)
  void _scrollRight() => _scroll(1);


  /// Widget que construye la flecha de navegación
  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: widget.sectionColor, size: 16),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.white.withOpacity(0.7),
        padding: const EdgeInsets.all(8),
        minimumSize: Size.zero,
        elevation: 4,
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
    );
  }


  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    // Usamos el espacio reservado del padre para los contenedores de las flechas
    final double arrowSpace = widget.arrowReservedSpace; // 38.0
    final double innerPadding = widget.listViewPadding; // 8.0

    return SizedBox(
      // Aumentamos la altura del contenedor principal por el padding vertical
      height: widget.carouselHeight + _verticalCarouselPadding * 2,
      child: Padding(
        // Aplicamos el padding vertical
        padding: const EdgeInsets.symmetric(vertical: _verticalCarouselPadding),

        // 🚀 USAMOS ROW PARA DISTRIBUIR LOS ELEMENTOS 🚀
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Flecha Izquierda
            SizedBox(
              width: arrowSpace,
              // El padding es ahora 8.0
              child: Padding(
                padding: const EdgeInsets.only(left: _arrowIconPadding), // 8.0
                child: Align(
                  alignment: Alignment.centerLeft,
                  // Llama a _scrollLeft()
                  child: _buildArrowButton(Icons.arrow_back_ios, _scrollLeft),
                ),
              ),
            ),

            // 2. Contenido del Carrusel (Expandido para ocupar el centro)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                // Aplicamos el padding lateral de 8.0 (el nuevo valor)
                padding: EdgeInsets.symmetric(horizontal: innerPadding),
                itemCount: widget.genreBooks.length,
                itemBuilder: (context, index) {
                  final book = widget.genreBooks[index];
                  final isLast = index == widget.genreBooks.length - 1;

                  return Padding(
                    // Separación entre tarjetas
                    padding: EdgeInsets.only(right: isLast ? 0.0 : _itemGap, bottom: 16.0,),
                    child: SizedBox(
                      width: widget.itemWidth, // Ancho calculado para 2 cards
                      child: HorizontalBookCard(book, t),
                    ),
                  );
                },
              ),
            ),

            // 3. Flecha Derecha
            SizedBox(
              width: arrowSpace,
              // El padding es ahora 8.0
              child: Padding(
                padding: const EdgeInsets.only(right: _arrowIconPadding), // 8.0
                child: Align(
                  alignment: Alignment.centerRight,
                  // Llama a _scrollRight()
                  child: _buildArrowButton(Icons.arrow_forward_ios, _scrollRight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}