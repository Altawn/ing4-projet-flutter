import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.controller,
  });

  final String hint;
  final Widget icon;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 351,
      height: 44,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.grey3,
            fontFamily: 'Avenir',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: SizedBox(width: 20, height: 20, child: icon),
            ),
          ),
          filled: true,
          fillColor: AppColors.white,
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 0, right: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.grey2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
          ),
        ),
      ),
    );
  }
}
