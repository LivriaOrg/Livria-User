import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/theme/app_colors.dart';
import '../../../../common/di/dependencies.dart' as di;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    // caso de uso de Logout
    await di.logoutUseCase.call();

    // si el widget sigue montado, navegamos al Login
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Pantalla de Perfil',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          // --- BOTÓN DE LOGOUT PROVISIONAL ---
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: AppColors.white),
            label: const Text('CERRAR SESIÓN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}