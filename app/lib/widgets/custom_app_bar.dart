import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_responsive.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final double height;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.height = 54.0,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leadingWidth: showBackButton ? 40 : 0,
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Center(
                    child: SizedBox(
                      width: 17.94,
                      height: 15,
                      child: SvgPicture.asset(
                        AppVectorialImages.goingBackArrow,
                        fit: BoxFit.fill,
                        colorFilter: const ColorFilter.mode(
                          AppColors.blue,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
        titleSpacing: showBackButton ? 14.5 : 14.5,
        title: SizedBox(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.w800,
              fontFamily: 'Avenir',
              fontSize: AppResponsive.sp(context, 17),
              letterSpacing: -0.41,
            ),
          ),
        ),
        centerTitle: centerTitle,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
