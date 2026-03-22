class ProductRecall {
  final String? gtin;
  final String? numeroFiche;
  final String? libelle;
  final String? marqueProduit;
  final String? image;
  final String? motifRappel;
  final String? risquesEncourus;
  final String? distributeurs;
  final String? zoneGeographique;
  final String? dateDebut;
  final String? dateFin;
  final String? conduiteATenir;
  final String? modalitesCompensation;
  final String? dateFinProcedure;
  final String? lienFiche;

  ProductRecall({
    this.gtin,
    this.numeroFiche,
    this.libelle,
    this.marqueProduit,
    this.image,
    this.motifRappel,
    this.risquesEncourus,
    this.distributeurs,
    this.zoneGeographique,
    this.dateDebut,
    this.dateFin,
    this.conduiteATenir,
    this.modalitesCompensation,
    this.dateFinProcedure,
    this.lienFiche,
  });

  factory ProductRecall.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['liens_vers_les_images'] as String?;
    if (imageUrl != null && imageUrl.contains('|')) {
      imageUrl = imageUrl.split('|').first;
    }

    return ProductRecall(
      gtin: json['gtin']?.toString(),
      numeroFiche: json['numero_fiche'] as String?,
      libelle: json['libelle'] as String?,
      marqueProduit: json['marque_produit'] as String?,
      image: imageUrl,
      motifRappel: json['motif_rappel'] as String?,
      risquesEncourus: json['risques_encourus'] as String?,
      distributeurs: json['distributeurs'] as String?,
      zoneGeographique: json['zone_geographique_de_vente'] as String?,
      dateDebut: json['date_debut_commercialisation'] as String?,
      dateFin: json['date_date_fin_commercialisation'] as String?,
      conduiteATenir: json['conduites_a_tenir_par_le_consommateur'] as String?,
      modalitesCompensation: json['modalites_de_compensation'] as String?,
      dateFinProcedure: json['date_de_fin_de_la_procedure_de_rappel'] as String?,
      lienFiche: json['lien_vers_la_fiche_rappel'] as String?,
    );
  }

  factory ProductRecall.fromPocketBase(Map<String, dynamic> json) {
    String? imageUrl = (json['image'] ??
        json['liens_vers_les_images'] ??
        json['liens_vers_image'] ??
        json['imageUrl']) as String?;

    if (imageUrl != null && imageUrl.contains('|')) {
      imageUrl = imageUrl.split('|').first;
    }

    return ProductRecall(
      gtin: (json['gtin'] ?? json['barcode'])?.toString(),
      numeroFiche: (json['numero_fiche'] ?? json['numeroFiche'] ?? json['numero']) as String?,
      libelle: (json['libelle'] ?? json['name'] ?? json['label']) as String?,
      marqueProduit:
          (json['marque_produit'] ?? json['marqueProduit'] ?? json['marque']) as String?,
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
      conduiteATenir: (json['conduites_a_tenir_par_le_consommateur'] ??
          json['conduite_a_tenir']) as String?,
      modalitesCompensation: (json['modalites_de_compensation'] ??
          json['modalites_compensation']) as String?,
      dateFinProcedure: (json['date_de_fin_de_la_procedure_de_rappel'] ??
          json['date_fin_procedure']) as String?,
      lienFiche: (json['lien_vers_la_fiche_rappel'] ?? json['lien_fiche'] ?? json['url']) as String?,
    );
  }
}
