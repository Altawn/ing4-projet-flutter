import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/screens/auth/auth_button.dart';
import 'package:formation_flutter/screens/auth/auth_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      const baseUrl = String.fromEnvironment(
        'PB_URL',
        defaultValue: 'http://127.0.0.1:8090',
      );

      final dio = Dio();
      final response = await dio.post(
        '$baseUrl/api/collections/users/records',
        data: {
          'email': email,
          'password': password,
          'passwordConfirm': password, // Obligatoire pour PocketBase
          'emailVisibility': true,
        },
      );

      debugPrint('Register Success: ${response.data}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte créé avec succès !')),
        );
        context.pushReplacement('/login');
      }
    } on DioException catch (e) {
      debugPrint('Register Error: ${e.response?.statusCode} - ${e.response?.data}');
      String message = 'Erreur lors de l\'inscription';

      if (e.response?.statusCode == 400) {
        final data = e.response?.data['data'];
        if (data != null && data['email'] != null) {
          message = 'Cette adresse email est déjà utilisée';
        } else if (data != null && data['password'] != null) {
          message = 'Le mot de passe est trop court ou invalide';
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Row(
                children: [
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: const Text(
                      'Inscription',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
              const SizedBox(height: 44),
              AuthTextField(
                controller: _emailController,
                hint: 'Adresse email',
                icon: SvgPicture.asset(AppVectorialImages.icEmail),
              ),
              const SizedBox(height: 12),
              AuthTextField(
                controller: _passwordController,
                hint: 'Mot de passe',
                icon: SvgPicture.asset(AppVectorialImages.icPassword),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : AuthButton(
                                label: "S'inscrire",
                                onPressed: _register,
                              ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
