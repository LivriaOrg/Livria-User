import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:livria_user/common/theme/app_colors.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // Coordenadas de "Av. República de Chile 661, Jesús María" (Aprox)
  static const LatLng _storeLocation = LatLng(-12.0641, -77.0367);

  final Completer<GoogleMapController> _controller = Completer();

  // Marcador para la tienda
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addStoreMarker();
  }

  void _addStoreMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('livria_store'),
          position: _storeLocation,
          infoWindow: InfoWindow(
            title: 'LIVRIA STORE',
            snippet: 'Av. República de Chile 661',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el Theme definido para acceder a los estilos de texto
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('UBICACIÓN'), // O Livria Logo
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: textTheme.labelLarge?.copyWith(color: AppColors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // --- SECCIÓN 1: OUR STORE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OUR STORE',
                    style: textTheme.headlineLarge?.copyWith(
                      color: AppColors.darkBlue,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Come visit our store!',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- FOTO DE LA TIENDA ---
            // Simulamos la tarjeta con la foto de la fachada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    // Reemplaza esto con tu asset: AssetImage('assets/store_front.png')
                    // Usando una imagen de internet de ejemplo por ahora:
                      image: NetworkImage('https://images.pexels.com/photos/34824141/pexels-photo-34824141.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black26, // Un poco de oscuridad para leer el texto
                          BlendMode.darken
                      )
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LIVRIA STORE',
                        style: textTheme.headlineLarge?.copyWith(
                          color: AppColors.white,
                          shadows: [
                            const Shadow(
                              blurRadius: 4.0,
                              color: Colors.black,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LIVRIA',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.white,
                            fontSize: 36, // Más grande como en la foto
                            fontFamily: 'serif', // O la fuente específica del logo
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- SECCIÓN 2: ADDRESS ---
            Center(
              child: Text(
                'ADDRESS',
                style: textTheme.headlineLarge?.copyWith(
                  color: AppColors.secondaryYellow, // Amarillo como en la imagen
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Av. República de Chile 661, Jesús María 15072, Peru',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- GOOGLE MAPS ---
            Container(
              height: 250, // Altura del mapa
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // ClipRRect para que el mapa respete los bordes redondeados
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: const CameraPosition(
                    target: _storeLocation,
                    zoom: 16.0, // Zoom cercano para ver las calles
                  ),
                  markers: _markers,
                  myLocationEnabled: true, // Muestra el punto azul del usuario
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false, // Más limpio sin controles de zoom
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),



            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}