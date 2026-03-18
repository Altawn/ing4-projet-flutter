import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';

class HomePageEmpty extends StatelessWidget {
  const HomePageEmpty({super.key, this.onScan});

  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 20),
          SvgPicture.asset(AppVectorialImages.illEmpty),
          Spacer(flex: 10),
          Expanded(
            flex: 20,
            child: Column(
              children: <Widget>[
                Text(
                  localizations.my_scans_screen_description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 16,
                  ),
                ),
                Spacer(flex: 5),
                TextButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blue,
                    backgroundColor: AppColors.yellow,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22.0)),
                    ),
                  ),
                  onPressed: onScan,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        localizations.my_scans_screen_button.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8.0),
                      SvgPicture.asset(AppVectorialImages.arrow),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 20),
        ],
      ),
    );
  }
}
