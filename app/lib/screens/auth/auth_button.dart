import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellow,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 18,
            height: 18,
            child: SvgPicture.asset(AppVectorialImages.arrow),
          ),
        ],
      ),
    );
  }
}
