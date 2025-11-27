import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livria_user/common/widgets/main_shell.dart';
import 'package:livria_user/features/auth/presentation/pages/login_page.dart';
import 'package:livria_user/features/auth/presentation/pages/register_step1_page.dart';
import 'package:livria_user/features/auth/presentation/pages/register_step2_page.dart';
import 'package:livria_user/features/auth/presentation/pages/splash_page.dart';

import 'package:livria_user/features/book/presentation/pages/search_page.dart';
import 'package:livria_user/features/book/presentation/pages/recommendations_page.dart';
import 'package:livria_user/features/orders/presentation/pages/location_page.dart';

import 'package:livria_user/features/home/presentation/pages/home_page.dart';
import 'package:livria_user/features/book/presentation/pages/categories_page.dart';
import 'package:livria_user/features/book/presentation/pages/category_books_page.dart'; // <-- NUEVO
import 'package:livria_user/features/communities/presentation/pages/communities_page.dart';
import 'package:livria_user/features/profile/presentation/pages/profile_page.dart';

import '../../features/book/application/services/book_service.dart';
import '../../features/book/domain/entities/book.dart';
import '../../features/book/domain/repositories/book_repository_impl.dart';
import '../../features/book/infrastructure/datasource/book_remote_datasource.dart';
import '../../features/book/presentation/pages/book_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/cart/presentation/pages/notifications_page.dart';
import '../../features/orders/presentation/pages/recipient_info_page.dart';

//import 'package:livria_user/features/auth/presentation/pages/login_page.dart';

final appRouter = GoRouter(
  // initialLocation: '/home', // inicia la app en la ruta /home
  // initialLocation: '/login', // inicia la app en la ruta /login
    initialLocation: '/',// iniciamos en el splashpage
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage()
      ),
      GoRoute(
        path: '/register_step1',
        builder: (context, state) => const RegisterStep1Page(),
      ),
      GoRoute(
        path: '/register_step2',
        builder: (context, state) {
          // extraemos los datos enviados desde el paso 1
          final data = state.extra as Map<String, String>?;

          if (data == null) {
            return const RegisterStep1Page();
          }

          return RegisterStep2Page(
            email: data['email']!,
            password: data['password']!,
          );
        },
      ),

      // rutas con barra de navegación
        ShellRoute(
            // mainshell
            builder: (context, state, child) {
                return MainShell(child: child);
            },
            // 'routes' son las páginas que se inyectan en el child
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomePage()),
              GoRoute(path: '/categories', builder: (_, __) => const CategoriesPage()),
              // ---------- NUEVA RUTA DETALLE POR CATEGORÍA ----------
              GoRoute(
                path: '/categories/:genre',
                builder: (context, state) {
                  final genre = state.pathParameters['genre'] ?? '';
                  return CategoryBooksPage(genre: Uri.decodeComponent(genre));
                },
              ),
              GoRoute(
                path: '/book/:bookId',
                builder: (context, state) {
                  final bookId = state.pathParameters['bookId'] ?? '';

                  final service = BookService(BookRepositoryImpl(BookRemoteDataSource()));

                  return FutureBuilder<Book?>(
                    future: service.findBookById(bookId),

                    builder: (context, snapshot) {
                      // Estado de error
                      if (snapshot.hasError) {
                        return const Scaffold(
                          body: Center(child: Text('Error al cargar el libro.')),
                        );
                      }
                      // Estado de datos
                      final selectedBook = snapshot.data;

                      if (selectedBook == null) {
                        // Libro no encontrado (404)
                        return const Scaffold(
                          body: Center(child: Text('Error: Libro no encontrado (404).')),
                        );
                      }

                      // Pasar el objeto Book real
                      return BookPage(b: selectedBook);
                    },
                  );
                },
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
                  path: '/checkout/shipping',
                  builder: (context, state) => const ShippingInfoPage(),
                ),
                GoRoute(
                    path: '/cart',
                    builder: (context, state) => const CartPage()
                ),
              GoRoute(
                path: '/checkout/recipient',
                builder: (context, state) => const RecipientInfoPage(),
              )

            ],
        ),

    ]
);