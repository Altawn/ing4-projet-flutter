import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/screens/auth/auth_button.dart';
import 'package:formation_flutter/res/app_responsive.dart';

class HomePageEmpty extends StatelessWidget {
  const HomePageEmpty({super.key, this.onScan});

  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: AppResponsive.h(context, 100)),
            SizedBox(
              width: AppResponsive.w(context, 323.92),
              height: AppResponsive.h(context, 309.13),
              child: SvgPicture.asset(AppVectorialImages.illEmpty),
            ),
            SizedBox(height: AppResponsive.h(context, 62.87)),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: AppResponsive.w(context, 100.5),
                    right: AppResponsive.w(context, 101.5),
                  ),
                  child: SizedBox(
                    width: AppResponsive.w(context, 173),
                    height: AppResponsive.h(context, 46),
                    child: Text(
                      localizations.my_scans_screen_description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blue,
                        fontFamily: 'Avenir',
                        fontSize: AppResponsive.sp(context, 17),
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.41,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppResponsive.h(context, 41)),
                AuthButton(
                  label: localizations.my_scans_screen_button,
                  onPressed: onScan ?? () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
