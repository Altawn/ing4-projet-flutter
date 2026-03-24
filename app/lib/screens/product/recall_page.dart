import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:share_plus/share_plus.dart';

class RecallPage extends StatelessWidget {
  final ProductRecall recall;
  final String? productImage;

  const RecallPage({super.key, required this.recall, this.productImage});

  @override
  Widget build(BuildContext context) {
    final String? displayImage =
        (productImage != null && productImage!.isNotEmpty)
        ? productImage
        : (recall.image != null && recall.image!.isNotEmpty
              ? recall.image
              : null);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Rappel produit',
          style: TextStyle(
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Transform.scale(
              scaleX: -1,
              child: SvgPicture.asset(
                'res/svg/35 Left_5.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.blue,
                  BlendMode.srcIn,
                ),
              ),
            ),
            onPressed: () {
              final shareText =
                  'Rappel produit : ${recall.libelle ?? recall.gtin}\n'
                  '${recall.lienFiche ?? ""}';
              SharePlus.instance.share(ShareParams(text: shareText));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (displayImage != null && displayImage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.network(
                  displayImage,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),

            const _SectionTitle(title: 'Dates de commercialisation'),
            _SectionContent(
              content: (recall.dateDebut == null && recall.dateFin == null)
                  ? 'Pas de date'
                  : 'Du ${recall.dateDebut ?? "?"} au ${recall.dateFin ?? "?"}',
            ),

            if (recall.distributeurs != null &&
                recall.distributeurs!.isNotEmpty) ...[
              const _SectionTitle(title: 'Distributeurs'),
              _SectionContent(content: recall.distributeurs!),
            ],

            if (recall.zoneGeographique != null &&
                recall.zoneGeographique!.isNotEmpty) ...[
              const _SectionTitle(title: 'Zone géographique'),
              _SectionContent(content: recall.zoneGeographique!),
            ],

            if (recall.motifRappel != null &&
                recall.motifRappel!.isNotEmpty) ...[
              const _SectionTitle(title: 'Motif du rappel'),
              _SectionContent(content: recall.motifRappel!),
            ],

            if (recall.risquesEncourus != null &&
                recall.risquesEncourus!.isNotEmpty) ...[
              const _SectionTitle(title: 'Risques encourus'),
              _SectionContent(content: recall.risquesEncourus!),
            ],

            if (recall.conduiteATenir != null &&
                recall.conduiteATenir!.isNotEmpty) ...[
              const _SectionTitle(title: 'Conduite à tenir'),
              _SectionContent(content: recall.conduiteATenir!),
            ],

const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: const Color(0xFFF6F6F8),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF080040),
            fontFamily: 'Avenir',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            height: 25 / 16,
          ),
        ),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String content;
  const _SectionContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF6A6A6A),
            fontFamily: 'Avenir',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.37,
          ),
        ),
      ),
    );
  }
}
