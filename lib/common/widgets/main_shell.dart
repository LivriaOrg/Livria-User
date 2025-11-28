import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:livria_user/common/utils/app_icons.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import 'package:livria_user/common/widgets/multi_color_line.dart';
import 'package:livria_user/features/cart/presentation/widgets/cart_drawer.dart';
import 'package:livria_user/features/auth/infrastructure/datasource/auth_local_datasource.dart';

class MainShell extends StatefulWidget {
  // este child es la página actual
  // go_router la inyectará aquí
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // "Memoria" para guardar el último tab principal activo
  int _lastMainTabIndex = 0;

  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authLocal = AuthLocalDataSource();
    final userId = await authLocal.getUserId();

    if (mounted && userId != null) {
      setState(() {
        _currentUserId = userId;
      });
    }
  }

  bool _isMainTab(String location) {
    return location.startsWith('/home') ||
        location.startsWith('/categories') ||
        location.startsWith('/communities') ||
        location.startsWith('/notifications') ||
        location.startsWith('/profile');
  }

  @override
  Widget build(BuildContext context) {

    // usar .uri.toString() para obtener la ruta real
    final String location = GoRouterState.of(context).uri.toString();
    final bool isMainTab = _isMainTab(location);

    int currentIndex;
    if (isMainTab) {
      // si es un tab principal, actualizamos el índice y la memoria
      currentIndex = _calculateCurrentIndex(location);
      _lastMainTabIndex = currentIndex;
    } else {
      // si no, usamos la memoria
      currentIndex = _lastMainTabIndex;
    }

    return Scaffold(
        key: _scaffoldKey,

        endDrawer: _currentUserId != null
            ? CartDrawer(userId: _currentUserId!)
            : const Drawer(child: Center(child: CircularProgressIndicator())),

        appBar: _buildAppBar(context, location),

        // el body es la página que el go_router nos pasa
        body: widget.child,

        // Barra inferior
        bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min, // para que la columna no ocupe toda la pantalla
            children: [

              // linea de colores personalizada
              const MultiColorLine(height: 3),

              BottomNavigationBar(

                // Estilos
                  type: BottomNavigationBarType.fixed, // Para que se vean los 5 ítems

                  currentIndex: currentIndex,

                  selectedItemColor: isMainTab
                      ? AppColors.primaryOrange
                      : AppColors.black,

                  unselectedItemColor: AppColors.black,

                  onTap: (index) => _onItemTapped(index, context), // navegar al tocar

                  showUnselectedLabels: false,
                  showSelectedLabels: isMainTab,

                  items: const [
                    BottomNavigationBarItem(
                      icon: FaIcon(AppIcons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(AppIcons.categories),
                      label: 'Categories',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(AppIcons.community),
                      label: 'Community',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(AppIcons.notifications),
                      label: 'Alerts',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(AppIcons.profile),
                      label: 'Profile',
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
  int _calculateCurrentIndex(String location) {
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

  PreferredSizeWidget _buildAppBar(BuildContext context, String location) {
    Color getIconColor(String path) {
      return location.startsWith(path) ? AppColors.primaryOrange : AppColors.black;
    }

    // construir appbar
    final defaultAppBar = AppBar(

      // titulo clickeable
      title: GestureDetector(
        onTap: () => context.go('/home'), // acción ir a /home
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
                'assets/images/logo.png',
                height: 24,
                fit: BoxFit.contain)
            ),
        ),
      centerTitle: false, // Alinea el logo a la izquierda
      backgroundColor: AppColors.white,
      //  acciones
      actions: [
        IconButton(
          icon: const FaIcon(AppIcons.search),
          color: getIconColor('/search'),
          onPressed: () => context.push('/search'),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const FaIcon(AppIcons.recommendations),
          color: getIconColor('/recommendations'),
          onPressed: () => context.push('/recommendations'),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const FaIcon(AppIcons.location),
          onPressed: () => context.push('/location'),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const FaIcon(AppIcons.cart),
          color: getIconColor('/cart'),
          onPressed: () {
            if (_currentUserId != null) {
              _scaffoldKey.currentState?.openEndDrawer();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Loading user data..."))
              );
            }
          },
        ),
        const SizedBox(width: 16) // espacio a la derecha

      ],
    );

    // usamos PreferredSize para definir un alto total
    return PreferredSize(
      // Alto total = AppBar (kToolbarHeight) + Línea (3)
      preferredSize: Size.fromHeight(kToolbarHeight + 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // para alinear a la derecha de la pantalla
        children: [
          defaultAppBar,
          const MultiColorLine(height: 4,)
        ],
      ),
    );
  }
}