import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../common/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterFormStep1 extends StatefulWidget {
  const RegisterFormStep1({super.key});

  @override
  State<RegisterFormStep1> createState() => _RegisterFormStep1State();
}

class _RegisterFormStep1State extends State<RegisterFormStep1> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Estado del Checkbox
  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    // validar formulario (Emails y Contraseñas)
    if (_formKey.currentState!.validate()) {
      // validar Checkbox manualmente
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must accept the terms and conditions to continue.'),
            backgroundColor: AppColors.errorRed,
          ),
        );
        return;
      }

      context.push(
        '/register_step2',
        extra: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        },
      );
    }
  }

  // función helper para abrir URLs
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
        throw Exception('No se pudo lanzar $url');
      }
    } catch (e) {
      print("Error abriendo URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: AppColors.accentGold50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'REGISTER',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // --- Campo Email ---
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration('Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter your email';
                  if (!EmailValidator.validate(value)) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- Campo Contraseña ---
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _buildInputDecoration('Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a password';
                  if (value.length < 8) return 'It must have at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- Campo Confirmar Contraseña ---
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: _buildInputDecoration('Confirm Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Confirm your password';
                  if (value != _passwordController.text) return 'Passwords don\'t match';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- Checkbox Términos y Condiciones ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _termsAccepted,
                      activeColor: AppColors.primaryOrange,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.bodySmall?.copyWith(color: AppColors.darkBlue, fontSize: 13),
                        children: [
                          const TextSpan(text: 'I have read and agree to the'),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            // --- ENLACE 1 ---
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchURL(
                                  'https://es.wikipedia.org/wiki/Términos_y_condiciones_de_uso'
                              ),
                          ),
                          const TextSpan(text: ' y los '),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            // --- ENLACE 2 ---
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchURL(
                                  'https://es.wikipedia.org/wiki/Política_de_privacidad'
                              ),
                          ),
                          const TextSpan(text: ' of Livria.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // --- Botón CONTINUAR ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: AppColors.darkBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkBlue,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
      ),
    );
  }
}