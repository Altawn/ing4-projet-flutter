class ProductRecall {
  final String? gtin;
  final String? libelle;
  final String? image;
  final String? motifRappel;
  final String? risquesEncourus;
  final String? distributeurs;
  final String? zoneGeographique;
  final String? dateDebut;
  final String? dateFin;
  final String? conduiteATenir;
  final String? lienFiche;

  ProductRecall({
    this.gtin,
    this.libelle,
    this.image,
    this.motifRappel,
    this.risquesEncourus,
    this.distributeurs,
    this.zoneGeographique,
    this.dateDebut,
    this.dateFin,
    this.conduiteATenir,
    this.lienFiche,
  });

  factory ProductRecall.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['liens_vers_les_images'] as String?;
    if (imageUrl != null && imageUrl.contains('|')) {
      imageUrl = imageUrl.split('|').first;
    }

    return ProductRecall(
      gtin: json['gtin']?.toString(),
      libelle: json['libelle'] as String?,
      image: imageUrl,
      motifRappel: json['motif_rappel'] as String?,
      risquesEncourus: json['risques_encourus'] as String?,
      distributeurs: json['distributeurs'] as String?,
      zoneGeographique: json['zone_geographique_de_vente'] as String?,
      dateDebut: json['date_debut_commercialisation'] as String?,
      dateFin: json['date_date_fin_commercialisation'] as String?,
      conduiteATenir: json['conduites_a_tenir_par_le_consommateur'] as String?,
      lienFiche: json['lien_vers_la_fiche_rappel'] as String?,
    );
  }

  factory ProductRecall.fromPocketBase(Map<String, dynamic> json) {
    String? imageUrl = (json['liens_vers_les_images'] ??
        json['image'] ??
        json['imageUrl']) as String?;

    if (imageUrl != null && imageUrl.contains('|')) {
      imageUrl = imageUrl.split('|').first;
    }

    return ProductRecall(
      gtin: (json['gtin'] ?? json['barcode'])?.toString(),
      libelle: (json['libelle'] ?? json['name'] ?? json['label']) as String?,
      image: imageUrl,
      motifRappel: (json['motif_rappel'] ?? json['motifRappel'] ?? json['motif']) as String?,
      risquesEncourus:
          (json['risques_encourus'] ?? json['risquesEncourus'] ?? json['risques']) as String?,
      distributeurs:
          (json['distributeurs'] ?? json['distributeur'] ?? json['vendeurs']) as String?,
      zoneGeographique: (json['zone_geographique_de_vente'] ??
          json['zone_geographique'] ??
          json['zone']) as String?,
      dateDebut: (json['date_debut_commercialisation'] ??
          json['date_debut_commerci'] ??
          json['date_debut']) as String?,
      dateFin: (json['date_date_fin_commercialisation'] ??
          json['date_fin_commercialisation'] ??
          json['date_fin_commerci'] ??
          json['date_fin']) as String?,
      conduiteATenir: (json['conduites_a_tenir'] ??
          json['conduites_a_tenir_par_le_consommateur'] ??
          json['conduite_a_tenir']) as String?,
      lienFiche: (json['lien_vers_la_fiche_rappel'] ?? json['lien_fiche'] ?? json['url']) as String?,
    );
  }
}
