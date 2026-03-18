import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/auth/auth_text_field.dart';
import 'package:formation_flutter/screens/auth/auth_button.dart';
import 'package:go_router/go_router.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/model/scan_history.dart';
import 'package:formation_flutter/model/favorites_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
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
      // PocketBase URL
      // 10.0.2.2 for Android Emulator, localhost for Windows/Web/iOS
      const baseUrl = String.fromEnvironment(
        'PB_URL',
        defaultValue: 'http://127.0.0.1:8090',
      );

      final dio = Dio();
      final response = await dio.post(
        '$baseUrl/api/collections/users/auth-with-password',
        data: {'identity': email, 'password': password},
      );

      debugPrint('Success: ${response.data}');

      if (response.statusCode == 200) {
        AuthService().setTokenAndUserId(
          response.data['token'],
          response.data['record']['id'],
        );

        if (mounted) {
          // On recharge l'historique lié à CE compte via PocketBase !
          Provider.of<ScanHistoryManager>(context, listen: false).fetchItems();
          Provider.of<FavoritesManager>(context, listen: false).fetchFavorites();
          context.go('/');
        }
      }
    } on DioException catch (e) {
      debugPrint(
        'Error during login: ${e.response?.statusCode} - ${e.response?.data}',
      );
      String message = 'Erreur lors de la connexion';

      if (e.response?.statusCode == 400) {
        message = 'Identifiants incorrects';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        message = 'Impossible de contacter le serveur (Vérifiez l\'URL)';
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
                      'Connexion',
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
                        AuthButton(
                          label: 'Créer un compte',
                          onPressed: () => context.push('/register'),
                        ),
                        const SizedBox(height: 12),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : AuthButton(
                                label: 'Se connecter',
                                onPressed: _login,
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
