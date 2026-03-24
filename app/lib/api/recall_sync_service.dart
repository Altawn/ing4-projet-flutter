import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:formation_flutter/api/auth_service.dart';

class RecallSyncService extends ChangeNotifier {
  static final RecallSyncService _instance = RecallSyncService._internal();
  factory RecallSyncService() => _instance;
  RecallSyncService._internal();

  static const String _govApiUrl =
      'https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso-v2-gtin-trie/exports/json';
  final Dio _dio = Dio();
  bool _isSyncing = false;

  bool get isSyncing => _isSyncing;

  void schedulePeriodicSync() {
    final next12 = _nextOccurrence(12, 0);
    final next00 = _nextOccurrence(0, 0);
    debugPrint('[Sync] Prochain sync programmé à ${_fmt(next12)} et ${_fmt(next00)}');
    _scheduleAt(next12);
    _scheduleAt(next00);
  }

  void _scheduleAt(DateTime target) {
    final diff = target.difference(DateTime.now());
    debugPrint('[Sync] Timer démarré — déclenchement dans ${diff.inMinutes} min (${_fmt(target)})');
    Timer(diff, () {
      debugPrint('[Sync] Déclenchement automatique à ${_fmt(target)}');
      sync();
      _scheduleAt(target.add(const Duration(days: 1)));
    });
  }

  DateTime _nextOccurrence(int hour, int minute) {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, hour, minute);
    if (!target.isAfter(now)) {
      target = target.add(const Duration(days: 1));
    }
    return target;
  }

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> syncIfNeeded() async {
    final token = AuthService().token;
    if (token == null) {
      debugPrint('[Sync] Pas de token — sync annulé');
      return;
    }

    debugPrint('[Sync] Vérification de la collection rappels...');
    final empty = await _isCollectionEmpty(token);
    if (empty) {
      debugPrint('[Sync] Collection vide, lancement du sync initial');
      await sync();
    } else {
      debugPrint('[Sync] Collection non vide, sync ignoré');
    }
  }

  Future<bool> _isCollectionEmpty(String token) async {
    try {
      final response = await _dio.get(
        '${AuthService.pbBaseUrl}/api/collections/rappels/records',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'perPage': 1},
      );
      if (response.statusCode == 200) {
        final total = response.data['totalItems'] as int? ?? 0;
        debugPrint('[Sync] Total actuel dans PocketBase : $total enregistrement(s)');
        return total == 0;
      }
    } catch (e) {
      debugPrint('[Sync] Erreur vérification collection : $e');
    }
    return false;
  }

  Future<void> sync() async {
    if (_isSyncing) {
      debugPrint('[Sync] Déjà en cours — ignoré');
      return;
    }
    final token = AuthService().token;
    if (token == null) {
      debugPrint('[Sync] Pas de token — sync annulé');
      return;
    }

    _isSyncing = true;
    notifyListeners();
    debugPrint('[Sync] Démarrage — ${DateTime.now()}');

    try {
      debugPrint('[Sync] Téléchargement des rappels depuis data.economie.gouv.fr...');
      final records = await _fetchGovRecalls();
      debugPrint('[Sync] ${records.length} rappels reçus depuis le gouvernement');

      final validRecords = records.where((r) {
        final gtin = r['gtin']?.toString().trim();
        return gtin != null && gtin.isNotEmpty && gtin != '0';
      }).toList();
      debugPrint('[Sync] ${validRecords.length} avec GTIN valide, ${records.length - validRecords.length} sans GTIN ignorés');

      int synced = 0;
      int updated = 0;
      int created = 0;
      int failed = 0;

      for (int i = 0; i < validRecords.length; i++) {
        final record = validRecords[i];
        final gtin = record['gtin'].toString().trim();

        if (i % 500 == 0) {
          debugPrint('[Sync] Progression : $i/${validRecords.length} (créés=$created, mis à jour=$updated, échecs=$failed)');
        }

        final result = await _saveToPocketBase(token, gtin, record);
        if (result == _SaveResult.created) {
          created++;
          synced++;
        } else if (result == _SaveResult.updated) {
          updated++;
          synced++;
        } else {
          failed++;
        }
      }

      debugPrint('[Sync] Terminé — total=$synced (créés=$created, mis à jour=$updated, échecs=$failed)');
    } catch (e) {
      debugPrint('[Sync] Erreur fatale : $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> _fetchGovRecalls() async {
    try {
      final response = await _dio.get(_govApiUrl);
      if (response.statusCode == 200) {
        final results = response.data as List?;
        return results?.cast<Map<String, dynamic>>() ?? [];
      }
      debugPrint('[Sync] Réponse inattendue : HTTP ${response.statusCode}');
    } catch (e) {
      debugPrint('[Sync] Erreur fetch RappelConso : $e');
    }
    return [];
  }

  Future<_SaveResult> _saveToPocketBase(
    String token,
    String gtin,
    Map<String, dynamic> record,
  ) async {
    try {
      final existing = await _dio.get(
        '${AuthService.pbBaseUrl}/api/collections/rappels/records',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'filter': 'gtin = "$gtin"'},
      );

      String? imageUrl = record['liens_vers_les_images'] as String?;
      if (imageUrl != null && imageUrl.contains('|')) {
        imageUrl = imageUrl.split('|').first;
      }

      final data = {
        'gtin': gtin,
        'libelle': record['libelle'] ?? record['modeles_ou_references'],
        'liens_vers_les_images': imageUrl,
        'motif_rappel': record['motif_rappel'],
        'risques_encourus': record['risques_encourus'],
        'distributeurs': record['distributeurs'],
        'zone_geographique_de_vente': record['zone_geographique_de_vente'],
        'date_debut_commercialisation': record['date_debut_commercialisation'],
        'date_fin_commercialisation': record['date_date_fin_commercialisation'],
        'conduites_a_tenir': record['conduites_a_tenir_par_le_consommateur'],
        'lien_vers_la_fiche_rappel': record['lien_vers_la_fiche_rappel'],
      };

      final items = existing.data['items'] as List;
      if (items.isNotEmpty) {
        await _dio.patch(
          '${AuthService.pbBaseUrl}/api/collections/rappels/records/${items.first['id']}',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: data,
        );
        return _SaveResult.updated;
      } else {
        await _dio.post(
          '${AuthService.pbBaseUrl}/api/collections/rappels/records',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: data,
        );
        return _SaveResult.created;
      }
    } catch (e) {
      debugPrint('[Sync] Erreur sauvegarde GTIN=$gtin : $e');
      return _SaveResult.failed;
    }
  }
}

enum _SaveResult { created, updated, failed }
