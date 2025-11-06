import 'package:go_router/go_router.dart';
import 'package:livria_user/common/widgets/main_shell.dart';
import 'package:livria_user/features/auth/presentation/pages/login_page.dart';

import 'package:livria_user/features/book/presentation/pages/search_page.dart';
import 'package:livria_user/features/book/presentation/pages/recommendations_page.dart';
import 'package:livria_user/features/orders/presentation/pages/location_page.dart';
import 'package:livria_user/features/drawers/presentation/pages/cart_page.dart';

import 'package:livria_user/features/home/presentation/pages/home_page.dart';
import 'package:livria_user/features/book/presentation/pages/categories_page.dart';
import 'package:livria_user/features/communities/presentation/pages/communities_page.dart';
import 'package:livria_user/features/drawers/presentation/pages/notifications_page.dart';
import 'package:livria_user/features/profile/presentation/pages/profile_page.dart';

//import 'package:livria_user/features/auth/presentation/pages/login_page.dart';

final appRouter = GoRouter(
    // initialLocation: '/home', // inicia la app en la ruta /home
    initialLocation: '/login', // inicia la app en la ruta /home
    routes: [
        // rutas con barra de navegación
        ShellRoute(
            // mainshell
            builder: (context, state, child) {
                return MainShell(child: child);
            },
            // 'routes' son las páginas que se inyectan en el child
            routes: [
                GoRoute(
                    path: '/login',
                    builder: (context, state) => const LoginPage()
                ),
                GoRoute(
                    path: '/home',
                    builder: (context, state) => const HomePage()
                ),
                GoRoute(
                    path: '/categories',
                    builder: (context, state) => const CategoriesPage()
                ),
                GoRoute(
                    path: '/communities',
                    builder: (context, state) => const CommunitiesPage()
                ),
                GoRoute(
                    path: '/notifications',
                    builder: (context, state) => const NotificationsPage()
                ),
                GoRoute(
                    path: '/profile',
                    builder: (context, state) => const ProfilePage()
                ),
                GoRoute(
                    path: '/search',
                    builder: (context, state) => const SearchPage()
                ),
                GoRoute(
                    path: '/recommendations',
                    builder: (context, state) => const RecommendationsPage()
                ),
                GoRoute(
                    path: '/location',
                    builder: (context, state) => const LocationPage()
                ),
                GoRoute(
                    path: '/cart',
                    builder: (context, state) => const CartPage()
                )

                // rutas sin barra de navegacion
                // GoRoute(
                //     path: '/login',
                //     builder: (context, state) => const LoginPage()
                // )
            ],
        ),

    ]
);