import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';
import '../../domain/entities/book.dart';


class SingleBookView extends StatefulWidget {
  final Book b;
  const SingleBookView({super.key, required this.b});

  @override
  State<SingleBookView> createState() => _SingleBookViewState();
}

class _SingleBookViewState extends State<SingleBookView> {
  int _selectedQuantity = 1;
  final List<int> _quantities = [1, 2, 3];

  // --- WIDGET AUXILIAR PARA LAS ETIQUETAS LATERALES ---
  Widget _buildVerticalLabel(String text, Color color, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  // --- SECCIÓN 1: ENCABEZADO Y DETALLE DEL LIBRO ---
  Widget _buildBookHeader(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TÍTULO PRINCIPAL
          Text(
            widget.b.title.toUpperCase(),
            style: t.headlineMedium?.copyWith(
              color: AppColors.accentGold,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16.0),

          // ROW PRINCIPAL
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 160,
              height: 200,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Imagen de la Portada
                  Image(
                    image: AssetImage(widget.b.cover),
                    height: 240,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                  // Etiquetas Rotadas
                  _buildVerticalLabel(widget.b.genre.toUpperCase(), AppColors.primaryOrange, 30, -35),
                  _buildVerticalLabel(widget.b.language.toUpperCase(), AppColors.vibrantBlue, 100, -35),
                  _buildVerticalLabel(widget.b.author.toUpperCase(), AppColors.darkBlue, 40, 115),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16.0),

          // PRECIO Y BOTONES DE ACCIÓN 
          Row(
            children: [
              // Íconos
              const Icon(Icons.remove_circle_outline, color: AppColors.darkBlue, size: 32,),
              const SizedBox(width: 8.0),
              const Icon(Icons.bookmark_border, color: AppColors.darkBlue, size: 32,),
              const SizedBox(width: 16.0),
              // Precio
              Text(
                'S/ ${widget.b.salePrice.toStringAsFixed(2)}',
                style: t.titleLarge?.copyWith(
                    color: AppColors.primaryOrange, fontWeight: FontWeight.bold),
              ),
              const Spacer(),

              // Dropdown de Cantidad
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: AppColors.softTeal.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isDense: true,
                    style: t.bodyMedium?.copyWith(color: AppColors.darkBlue, fontWeight: FontWeight.bold),
                    value: _selectedQuantity,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.darkBlue, size: 20),items: _quantities.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBlue, fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedQuantity = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              // Botón Añadir al Carrito
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vibrantBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text('AÑADIR A CARRITO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SECCIÓN 2: SINOPSIS ---
  Widget _buildSynopsis() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.8))
        ),
        child: Text(
          widget.b.description,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, color: AppColors.black),
        ),
      ),
    );
  }

  // --- SECCIÓN 3: LISTA DE RESEÑAS DETALLADAS ---
  Widget _buildReviewsSection(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'RESEÑAS',
                style: t.headlineMedium?.copyWith(
                  color: AppColors.primaryOrange,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Comparte una reseña para este libro.', style: TextStyle(color: AppColors.darkBlue)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Estrellas
              Row(
                children: [
                  ...List.generate(5, (index) => const Icon(Icons.star_border, color: AppColors.accentGold, size: 20)),
                ],
              ),
              const SizedBox(height: 8.0),
              // Input de Texto
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: '¿Cuál es tu opinión?',
                  hintStyle: TextStyle(color: AppColors.darkBlue.withOpacity(0.7)),
                  filled: true,
                  fillColor: AppColors.softTeal.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                ),
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 8.0),
              // Botón de Enviar Reseña
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.vibrantBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('PUBLICAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        const SizedBox(height: 16.0),
        // Lista de reseñas (Usando los datos simulados)
        // Nota: ReviewCard también debería usar AppColors internamente para consistencia.
        /*...mockReviews.map((review) {
          return ReviewCard(review: review);
        }).toList(),*/

        const SizedBox(height: 20.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/book_cover.png"), context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBookHeader(context),
            _buildSynopsis(),
            const SizedBox(height: 32.0),
            const Divider(height: 1, thickness: 2, color: AppColors.lightGrey),
            _buildReviewsSection(context),
          ],
        ),
      ),
    );
  }
}
