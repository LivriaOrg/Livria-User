import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livria_user/common/theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // clave global para identificar y validar el formulario
  final _formKey = GlobalKey<FormState>();

  void _login() {
    // validar formulario
    if (_formKey.currentState!.validate()) {
      // si los campos son válidos

      // context.go() para reemplazar la pila de navegación
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // usamos scaffold porque esta pantalla está fuera del MainShell
    return Scaffold(
      // SingleChildScrollView para evitar que el teclado tape campos de texto
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // los hijos ocupan el ancho disponible
                children: [
                  Image.asset(
                    'assets/images.logo.png',
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 40),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                        padding: const EdgeInsets.all(24.0),
                      // FOrmulario
                      child: Form(
                        key: _formKey,
                        child: Column(),
                      ),
                    ),
                  )

                ],
              ),
            )
        ),
      ),

    );

  }

}

