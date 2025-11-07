import 'package:go_router/go_router.dart';
import 'package:livria_user/common/widgets/main_shell.dart';
import 'package:livria_user/features/book/presentation/pages/book_page.dart';

import 'package:livria_user/features/book/presentation/pages/search_page.dart';
import 'package:livria_user/features/book/presentation/pages/recommendations_page.dart';
import 'package:livria_user/features/orders/presentation/pages/location_page.dart';
import 'package:livria_user/features/drawers/presentation/pages/cart_page.dart';

import 'package:livria_user/features/home/presentation/pages/home_page.dart';
import 'package:livria_user/features/book/presentation/pages/categories_page.dart';
import 'package:livria_user/features/book/presentation/pages/category_books_page.dart'; // <-- NUEVO
import 'package:livria_user/features/communities/presentation/pages/communities_page.dart';
import 'package:livria_user/features/drawers/presentation/pages/notifications_page.dart';
import 'package:livria_user/features/profile/presentation/pages/profile_page.dart';

final appRouter = GoRouter(
    initialLocation: '/home',
    routes: [
        ShellRoute(
            builder: (context, state, child) => MainShell(child: child),
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
                // -------------------------------------------------------
                GoRoute(
                    path: '/book/:book',
                  builder: (context, state) {
                      final book = state.pathParameters['book'] ?? '';
                      return BookPage(book: Uri.decodeComponent(book));
                  }
                ),
                GoRoute(path: '/communities', builder: (_, __) => const CommunitiesPage()),
                GoRoute(path: '/notifications', builder: (_, __) => const NotificationsPage()),
                GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
                GoRoute(path: '/search', builder: (_, __) => const SearchPage()),
                GoRoute(path: '/recommendations', builder: (_, __) => const RecommendationsPage()),
                GoRoute(path: '/location', builder: (_, __) => const LocationPage()),
                GoRoute(path: '/cart', builder: (_, __) => const CartPage()),
            ],
        ),
    ],
);
