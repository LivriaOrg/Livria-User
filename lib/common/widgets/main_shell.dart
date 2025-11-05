import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:livria_user/common/utils/app_icons.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import 'package:livria_user/common/widgets/multi_color_line.dart';


class MainShell extends StatelessWidget {
  // este child es la página actual
  // go_router la inyectará aquí
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),

      // el body es la página que el go_router nos pasa
      body: child,

      // Barra inferior
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // para que la columna no ocupe toda la pantalla
        children: [

          // linea de colores personalizada
          const MultiColorLine(),

          BottomNavigationBar(
            // Estilos
              type: BottomNavigationBarType.fixed, // Para que se vean los 5 ítems
              currentIndex: _calculateCurrentIndex(context), // calcular el ítem activo
              onTap: (index) => _onItemTapped(index, context), // navegar al tocar

              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(AppIcons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(AppIcons.categories),
                  label: 'Categorías',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(AppIcons.community),
                  label: 'Comunidad',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(AppIcons.notifications),
                  label: 'Alertas',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(AppIcons.profile),
                  label: 'Perfil',
                ),
              ]
          ),
        ]
      )
    );
  }

  // esta función usa go_router para navegar a la ruta
void _onItemTapped(int index, BuildContext context) {
    switch(index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/categories');
        break;
      case 2:
        context.go('/communities');
        break;
      case 3:
        context.go('/notifications');
        break;
      case 4:
        context.go('/profile');
        break;
    }
}

// esta función mira la ruta actual y devuelve el índice
// de esta forma se ilumina el ícono correcto
int _calculateCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/categories')) {
      return 1;
    }
    if (location.startsWith('/communities')) {
      return 2;
    }
    if (location.startsWith('/notifications')) {
      return 3;
    }
    if (location.startsWith('/profile')) {
      return 4;
    }
    return 0;
}

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // obtener ruta raiz
    final String location = GoRouterState.of(context).matchedLocation;

    // lógica de color manul
    Color getIconColor(String path) {
      return location == path
          ? AppColors.primaryOrange
          : AppColors.black;
    }

    // construir appbar
    final defaultAppBar = AppBar(

      // titulo clickeable
      title: GestureDetector(
        onTap: () => context.go('/home'), // acción ir a /home
        child: Image.asset(
          'assets/images/logo.png',
          height: 36,
          fit: BoxFit.contain,
        ),
      ),
      centerTitle: false, // Alinea el logo a la izquierda

      //  acciones
      actions: [
        IconButton(
          icon: const FaIcon(AppIcons.search),
          color: getIconColor('/search'),
          onPressed: () => context.go('/search'),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const FaIcon(AppIcons.recommendations),
          color: getIconColor('/recommendations'),
          onPressed: () => context.go('/recommendations'),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const FaIcon(AppIcons.location),
          color: getIconColor('/location'),
          onPressed: () => context.go('/location'),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const FaIcon(AppIcons.cart),
          color: getIconColor('/cart'),
          onPressed: () => context.go('/cart'),
        ),
        const SizedBox(width: 8) // espacio a la derecha

      ],
    );

    // usamos PreferredSize para definir un alto total
    return PreferredSize(
      // Alto total = AppBar (kToolbarHeight) + Línea (3)
      preferredSize: Size.fromHeight(kToolbarHeight + 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // para alinear a la derecha de la pantalla
        children: [
          defaultAppBar,
          const MultiColorLine(height: 3,)
        ],
      ),
    );
  }





}