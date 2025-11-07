import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/theme/app_colors.dart';

class LoginRedirectCard extends StatelessWidget {
  const LoginRedirectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.softTeal50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              '¿Ya tienes una cuenta?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.vibrantBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                // redirige al Login
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.darkBlue, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'INICIAR SESIÓN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}