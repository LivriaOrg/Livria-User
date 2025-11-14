import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';
import '../widgets/login_form.dart';
import '../widgets/register_card.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo
              Image.asset(
                'assets/images/logo.png',
                height: 50,
              ),
              const SizedBox(height: 64),

              // Formulario de Login
              const LoginForm(),

              const SizedBox(height: 32),

              // Separador "O"
              Text(
                'OR',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 32),

              // Tarjeta de Registro
              const RegisterCard(),
            ],
          ),
        ),
      ),
    );
  }
}