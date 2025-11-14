import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:livria_user/features/book/presentation/pages/category_books_page.dart';
import 'package:livria_user/features/auth/presentation/pages/register_step1_page.dart';
import 'package:livria_user/features/auth/presentation/pages/register_step2_page.dart';

final _testRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: Scaffold(body: Text('Home'))),
    ),
    GoRoute(
      path: '/categories/:genre',
      pageBuilder: (context, state) {
        final genre = state.pathParameters['genre']!;
        return MaterialPage(child: CategoryBooksPage(genre: genre));
      },
    ),
    GoRoute(
      path: '/register_step1',
      pageBuilder: (context, state) => const MaterialPage(child: RegisterStep1Page()),
    ),
    GoRoute(
      path: '/register_step2',
      redirect: (context, state) {
        if (state.extra == null ||
            state.extra is! Map<String, dynamic> ||
            !(state.extra as Map<String, dynamic>).containsKey('email')) {
          return '/register_step1';
        }
        return null;
      },
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return MaterialPage(
          child: RegisterStep2Page(
            email: data['email'] as String,
            password: data['password'] as String,
          ),
        );
      },
    ),
  ],
);

void main() {
  Widget createTestApp(GoRouter router) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }

  group('GoRouter - Validación de Carga de Widgets', () {
    testWidgets('T1: Debe cargar CategoryBooksPage y decodificar el parámetro', (tester) async {
      const genreValue = 'literatura';

      await tester.pumpWidget(createTestApp(_testRouter));
      await tester.pumpAndSettle();

      final encodedGenre = Uri.encodeComponent(genreValue);
      _testRouter.go('/categories/$encodedGenre');
      await tester.pumpAndSettle();

      expect(find.byType(CategoryBooksPage), findsOneWidget);
      final categoryBooksPage = tester.widget<CategoryBooksPage>(find.byType(CategoryBooksPage));
      expect(categoryBooksPage.genre, genreValue);
    });

    testWidgets('T2: Debe navegar a RegisterStep2Page al enviar datos extra', (tester) async {
      await tester.pumpWidget(createTestApp(_testRouter));
      await tester.pumpAndSettle();

      const email = 'test@livria.com';
      const password = 'securepassword';
      const confirmPassword = 'securepassword';

      _testRouter.go('/register_step2', extra: {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      });
      await tester.pumpAndSettle();

      expect(find.byType(RegisterStep2Page), findsOneWidget);
      final step2Page = tester.widget<RegisterStep2Page>(find.byType(RegisterStep2Page));
      expect(step2Page.email, email);
      expect(step2Page.password, password);
    });

    testWidgets('T3: Debe redirigir a RegisterStep1Page si los datos extra faltan', (tester) async {
      await tester.pumpWidget(createTestApp(_testRouter));
      await tester.pumpAndSettle();

      _testRouter.go('/register_step2');
      await tester.pumpAndSettle();

      expect(find.byType(RegisterStep1Page), findsOneWidget);
      expect(find.byType(RegisterStep2Page, skipOffstage: false), findsNothing);
    });
  });
}
