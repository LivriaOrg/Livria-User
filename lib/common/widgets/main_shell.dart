import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:livria_user/common/utils/app_icons.dart';
import 'package:livria_user/common/theme/app_colors.dart';


class MainShell extends StatelessWidget {
  // este child es la página actual
  // go_router la inyectará aquí
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livria')
      ),

      // el body es la página que el go_router nos pasa
      body: child,

      // Barra inferior
      bottomNavigationBar: BottomNavigationBar(
        // Estilos
        type: BottomNavigationBarType.fixed, // Para que se vean los 5 ítems
        backgroundColor: AppColors.darkBlue,
        selectedItemColor: AppColors.accentGold,
        unselectedItemColor: AppColors.softTeal,
        showUnselectedLabels: false,
        showSelectedLabels: true,
          currentIndex: _calculateCurrentIndex(context), // calcular el ítem activo
          onTap: (index) => _onItemTapped(index, context), // navegar al tocar

          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(AppIcons.home),
              label: 'Home',
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


}