import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/screens/auth/auth_button.dart';

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
            const SizedBox(height: 100),
            SizedBox(
              width: 323.92,
              height: 309.13,
              child: SvgPicture.asset(AppVectorialImages.illEmpty),
            ),
            const SizedBox(height: 62.87),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 100.5, right: 101.5),
                  child: SizedBox(
                    width: 173,
                    height: 46,
                    child: Text(
                      localizations.my_scans_screen_description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontFamily: 'Avenir',
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.41,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 41),
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
