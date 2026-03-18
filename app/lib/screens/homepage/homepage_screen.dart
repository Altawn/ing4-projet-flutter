import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.my_scans_screen_title,
          style: const TextStyle(
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              AppVectorialImages.star,
              colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
            ),
          ),
          IconButton(
            onPressed: () => context.go('/login'),
            icon: SvgPicture.asset(
              AppVectorialImages.arrowInSquare,
              colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: HomePageEmpty(onScan: () => _onScanButtonPressed(context)),
    );
  }

  void _onScanButtonPressed(BuildContext context) {
    context.push('/scanner');
  }
}
