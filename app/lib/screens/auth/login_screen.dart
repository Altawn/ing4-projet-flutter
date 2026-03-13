import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/auth/auth_text_field.dart';
import 'package:formation_flutter/screens/auth/auth_button.dart';
import 'package:go_router/go_router.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              const Text(
                'Connexion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 44),
              AuthTextField(
                hint: 'Adresse email',
                icon: SvgPicture.asset(AppVectorialImages.icEmail),
              ),
              const SizedBox(height: 12),
              AuthTextField(
                hint: 'Mot de passe',
                icon: SvgPicture.asset(AppVectorialImages.icPassword),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthButton(
                      label: 'Créer un compte',
                      onPressed: () => context.push('/register'),
                    ),
                    const SizedBox(height: 12),
                    AuthButton(
                      label: 'Se connecter',
                      onPressed: () {
                        // TODO: logique de connexion
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
