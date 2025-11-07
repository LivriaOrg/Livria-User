import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';
import '../widgets/register_form_step1.dart';
import '../widgets/login_redirect_card.dart';

class RegisterStep1Page extends StatelessWidget {
  const RegisterStep1Page({super.key});

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

              // Formulario Paso 1
              const RegisterFormStep1(),

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