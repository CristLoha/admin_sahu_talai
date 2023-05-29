import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/theme.dart';
import '../../../models/aho_corasick.dart';

class AdminController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  final AhoCorasick ahoCorasick = AhoCorasick();
  final Map<String, Map<String, String>> patterns = {};
  RxList<QueryDocumentSnapshot> resultDocuments =
      RxList<QueryDocumentSnapshot>();

  final RxList<String> searchResults = RxList<String>();

  Stream<QuerySnapshot> getStream() {
    return kamus.snapshots();
  }

  @override
  void onInit() {
    super.onInit();
    loadPatterns();
  }

  Future<void> loadPatterns() async {
    final snapshot = await kamus.get();
    for (var doc in snapshot.docs) {
      String originalPattern = doc.get('kataSahu');
      String searchPattern = originalPattern.replaceAll('_', '');
      String kataIndonesia = doc.get('kataIndonesia');
      patterns[searchPattern] = {
        'kataSahu': originalPattern,
        'kataIndonesia': kataIndonesia,
      };
      patterns[kataIndonesia] = {
        'kataSahu': originalPattern,
        'kataIndonesia': kataIndonesia,
      };
    }
    ahoCorasick.buildTrie(patterns.keys.toList());
    ahoCorasick.buildSuffixAndOutputLinks();
  }

  void search() {
    String query =
        searchController.text.replaceAll('_', ''); // no longer redefining query
    List<String> tokens = query.split(' ');
    query.replaceAllMapped(RegExp(r'_\w'), (m) => '${m.group(0)![1]}̲');
    Stopwatch stopwatch = Stopwatch()..start();

    searchResults.clear();
    bool dataFound = false;

    // Melakukan pencarian untuk setiap token
    for (String token in tokens) {
      final indices = List.generate(patterns.length, (_) => <int>[]);
      ahoCorasick.searchPattern(
          token, indices); // Melakukan pencarian untuk token ini

      for (int i = 0; i < patterns.length; i++) {
        if (indices[i].isNotEmpty) {
          Map<String, String> originalPatternMap = patterns.values.elementAt(i);
          if (!searchResults.contains(originalPatternMap['kataSahu']) ||
              !searchResults.contains(originalPatternMap['kataIndonesia'])) {
            searchResults.add(originalPatternMap['kataSahu']!);

            searchResults.add(originalPatternMap['kataIndonesia']!);

            dataFound = true;

            print(
                'Kata "${originalPatternMap['kataSahu']}" atau "${originalPatternMap['kataIndonesia']}" ditemukan pada kata "$token"!');
            print(
                'Total kemunculan "${originalPatternMap['kataSahu']} atau ${originalPatternMap['kataIndonesia']}": ${indices[i].length}');
            print('Posisi kemunculan ke-${i + 1}: ${indices[i].join(', ')}');
            print('----');
          }
        }
      }
    }

    stopwatch.stop();

    if (dataFound) {
      // Get.snackbar(
      //   'Hasil Pencarian',
      //   'Kata ditemukan dalam ${stopwatch.elapsed.inMilliseconds} ms',
      // );
    } else {
      searchResults.clear();
      searchResults.add("Data tidak cocok");
      print('Data tidak cocok');
      Get.snackbar(
        'Hasil Pencarian',
        'Kata tidak ditemukan',
      );
    }

    print(
        'Aho-Corasick matching executed in ${stopwatch.elapsedMilliseconds} ms');
    print(
        'Aho-Corasick matching executed in ${stopwatch.elapsedMilliseconds / 1000} seconds');
  }

  Future<void> deleteHewan(String id) async {
    DocumentReference docRef = kamus.doc(id);

    // Tampilkan dialog konfirmasi sebelum menghapus item
    var confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Konfirmasi',
          style: darkBlueTextStyle.copyWith(fontWeight: bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus item ini?',
          style: darkBlueTextStyle.copyWith(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text(
              'Tidak',
              style: darkBlueTextStyle,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text(
              'Ya',
              style: oldRoseTextStyle,
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await docRef.delete();
        Get.snackbar('Berhasil', 'Item telah dihapus',
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Error', 'Terjadi kesalahan saat menghapus item',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
