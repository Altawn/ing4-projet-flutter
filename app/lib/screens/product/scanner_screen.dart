import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_responsive.dart';
import 'package:formation_flutter/widgets/custom_app_bar.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController? controller;
  bool isParsing = false;

  bool get _isWindows => Platform.isWindows;

  @override
  void initState() {
    super.initState();
    if (!_isWindows) controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(String barcode) {
    if (isParsing) return;
    setState(() => isParsing = true);
    context.pushReplacement('/product', extra: barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Scanner un produit'),
      body: _isWindows ? _buildWindowsScanner() : _buildMobileScanner(),
    );
  }

  Widget _buildWindowsScanner() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppResponsive.w(context, 24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Saisissez le code-barres',
              style: TextStyle(
                color: AppColors.blue,
                fontFamily: 'Avenir',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
          ],
        ),
      ),
    );
  }

  Widget _buildMobileScanner() {
    return Stack(
      children: [
        MobileScanner(
          controller: controller!,
          onDetect: (BarcodeCapture capture) {
            final barcode = capture.barcodes.firstOrNull?.rawValue;
            if (barcode != null) _onBarcodeDetected(barcode);
          },
        ),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }
}
