import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/res/app_responsive.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppResponsive.w(context, 197),
      height: AppResponsive.h(context, 45),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          padding: EdgeInsets.only(
            left: AppResponsive.w(context, 26),
            right: AppResponsive.w(context, 28),
          ),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: AppResponsive.sp(context, 15),
                fontFamily: 'Avenir',
                color: AppColors.blue,
                letterSpacing: -0.36,
              ),
            ),
            SizedBox(
              width: AppResponsive.w(context, 15.5),
              height: AppResponsive.h(context, 11),
              child: SvgPicture.asset(AppVectorialImages.arrow),
            ),
          ],
        ),
      ),
    );
  }
}
