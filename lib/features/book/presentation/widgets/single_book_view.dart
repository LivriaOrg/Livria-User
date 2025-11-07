import 'package:flutter/material.dart';

class SingleBookView extends StatefulWidget {
  const SingleBookView({super.key});

  @override
  State<SingleBookView> createState() => _SingleBookViewState();
}

class _SingleBookViewState extends State<SingleBookView> {
  // Estado para el Dropdown de cantidad
  int _selectedQuantity = 1;
  // Opciones del Dropdown: 1, 2 y 3
  final List<int> _quantities = [1, 2, 3];

  Widget _buildBookHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'PERCY JACKSON AND THE BATTLE OF THE LABYRINTH',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE96D3B)),
          ),
          const SizedBox(height: 16.0),

          // Contenido (Portada y Reseña Rápida)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portada (con etiquetas simuladas)
              Stack(
                children: [
                  Image.asset(
                    'assets/book_cover.png', // Reemplazar con tu imagen local
                    height: 200,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                  // Las etiquetas laterales pueden ser complejas, simplificamos:
                  const Positioned(
                    top: 10, left: -20,
                    child: RotatedBox(quarterTurns: 3, child: Text('JUVENILE', style: TextStyle(color: Color(0xFFE96D3B)))),
                  ),
                  const Positioned(
                    bottom: 10, left: -20,
                    child: RotatedBox(quarterTurns: 3, child: Text('en INGLÉS', style: TextStyle(color: Color(0xFF28547C)))),
                  ),
                ],
              ),
              const SizedBox(width: 20.0),

              // Sección de Reseñas Pequeña (lado derecho de la imagen)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('REVIEWS', style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text('Leave a review for this book.'),
                    const Row(
                      children: [
                        Icon(Icons.star_border, color: Colors.amber),
                        Icon(Icons.star_border, color: Colors.amber),
                        Icon(Icons.star_border, color: Colors.amber),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    // Input de Reseña
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: Colors.blue.shade300),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Text('What are your thoughts?'),
                    ),
                    const SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue.shade200,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('POST REVIEW'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Precio y Botón de Carrito
          Row(
            children: [
              // Iconos de Marcapáginas/Guardar (simulados)
              const Icon(Icons.bookmark_border, color: Colors.grey),
              const SizedBox(width: 8.0),
              const Icon(Icons.download_for_offline_outlined, color: Colors.grey),
              const SizedBox(width: 16.0),
              // Precio
              const Text('S/ 49.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Spacer(),

              // Dropdown de Cantidad (1, 2, 3)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedQuantity,
                    items: _quantities.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
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
                  backgroundColor: const Color(0xFF28547C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('ADD TO CART'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSynopsis() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Text(
            'Synopsis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          // Texto de la sinopsis
          Text(
            'In Percy Jackson and the Battle of the Labyrinth, Percy, Annabeth, Grover, and Tyson explore the ancient, magical, and constantly changing Labyrinth to prevent the Titan Lord Kronos and his army from using it to invade Camp Half-Blood. The quest takes them through the maze where they encounter mythical and dangerous traps, confront new enemies, and seek out Daedalus, the Labyrinth\'s creator, to find a way to stop the invasion.',
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'REVIEWS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Leave a review for this book.'),
          ),
          // La lista de reseñas construida con Column + ReviewCard
          /*Column(
            children: mockReviews.map((review) {
              return ReviewCard(review: review);
            }).toList(),
          ),*/
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- 2. SECCIÓN DEL ENCABEZADO Y DETALLE DEL LIBRO ---
          _buildBookHeader(),
          const Divider(height: 1, thickness: 1),

          // --- 3. SECCIÓN DE LA SINOPSIS ---
          _buildSynopsis(),
          const Divider(height: 1, thickness: 1),

          // --- 4. SECCIÓN DE LAS RESEÑAS ---
          _buildReviewsSection(),
        ],
      ),
    );
  }
}