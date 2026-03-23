import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';
import 'package:formation_flutter/api/auth_service.dart';
import 'package:formation_flutter/res/app_responsive.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final MobileScannerController controller;
  bool isParsing = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(54.0),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          titleSpacing: 13.0,
          title: const Text(
            'Scanner un produit',
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.w800,
              fontFamily: 'Avenir',
              fontSize: 17,
              letterSpacing: -0.41,
            ),
          ),
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () => context.push('/favorites'),
              child: SizedBox(
                width: 23.9,
                height: 23.9,
                child: SvgPicture.asset(
                  AppVectorialImages.star,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: () {
                AuthService().logout();
                context.go('/login');
              },
              child: SizedBox(
                width: 23.9,
                height: 23.9,
                child: SvgPicture.asset(
                  AppVectorialImages.arrowInSquare,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              if (isParsing) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final barcode = barcodes.first.rawValue;
                if (barcode != null) {
                  setState(() {
                    isParsing = true;
                  });

                  context.pushReplacement('/product', extra: barcode);
                }
              }
            },
          ),
          // Scanner Overlay Mask
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Manual Entry Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppResponsive.h(context, 20),
                horizontal: AppResponsive.w(context, 16),
              ),
              decoration: const BoxDecoration(color: AppColors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ou saisissez le code-barres',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontFamily: 'Avenir',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 351,
                    height: 44,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Code GTIN (ex: 3017620422003)',
                        hintStyle: const TextStyle(
                          color: AppColors.grey3,
                          fontFamily: 'Avenir',
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.grey2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.grey2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.blue),
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          context.pushReplacement('/product', extra: value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
