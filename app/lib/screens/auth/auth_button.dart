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
    return SizedBox(
      width: 197,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          padding: const EdgeInsets.only(left: 26, right: 28),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                fontFamily: 'Avenir',
                color: AppColors.blue,
                letterSpacing: -0.36,
              ),
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(AppVectorialImages.arrow),
            ),
          ],
        ),
      ),
    );
  }
}
