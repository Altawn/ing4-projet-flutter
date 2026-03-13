import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/auth/auth_text_field.dart';
import 'package:formation_flutter/screens/auth/auth_button.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                'Inscription',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 20),
              AuthButton(
                label: "S'inscrire",
                onPressed: () {
                  // TODO: logique d'inscription
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
