import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:formation_flutter/res/app_colors.dart';

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
      appBar: AppBar(
        title: const Text(
          'Scanner un code-barres',
          style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                switch (value.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: AppColors.yellow);
                  case TorchState.auto:
                    return const Icon(Icons.flash_auto, color: Colors.grey);
                  case TorchState.unavailable:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: AppColors.blue),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
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
    );
  }
}
