import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';
import '../widgets/register_form_step2.dart';
import '../widgets/login_redirect_card.dart';

class RegisterStep2Page extends StatelessWidget {
  // datos del paso 1
  final String email;
  final String password;

  const RegisterStep2Page({
    super.key,
    required this.email,
    required this.password,
  });

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
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 80,
              ),
              const SizedBox(height: 48),

              // Formulario Paso 2 (le pasamos los datos del paso 1)
              RegisterFormStep2(
                email: email,
                password: password,
              ),

              const SizedBox(height: 32),

              // Separador "O"
              Text(
                'O',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 32),

              // Tarjeta de redirección al Login
              const LoginRedirectCard(),
            ],
          ),
        ),
      ),
    );
  }
}