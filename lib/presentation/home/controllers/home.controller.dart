import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/aho_corasick.dart';

enum LanguageDirection { indSahu, sahuInd }

class HomeController extends GetxController {
  Rx<LanguageDirection> selectedDirection = LanguageDirection.indSahu.obs;
  var errorText = ''.obs;
  void setDirection(LanguageDirection direction) {
    selectedDirection.value = direction;
  }

  final TextEditingController searchController =
      TextEditingController(); // Tambahkan ini
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  final AhoCorasick ahoCorasick = AhoCorasick();
  final Map<String, String> patterns = {}; // Ubah ini
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
      patterns[searchPattern] = originalPattern;
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
          String originalPattern = patterns.values.elementAt(i);
          if (!searchResults.contains(originalPattern)) {
            // Tambahkan pemeriksaan ini untuk menghindari duplikat
            searchResults.add(originalPattern);
            dataFound = true;

            print('Kata "$originalPattern" ditemukan pada kata "$token"!');
            print('Total kemunculan "$originalPattern": ${indices[i].length}');
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

  RxString selectedOption = ''.obs;
  List<String> options = [
    'Benda',
    'Kerja',
    'Sifat',
    'Depan',
    'Tumbuhan',
    'Tempat',
    'Angka',
    'Tempat/Lokasi',
    'Panggilan'
  ];

  void onOptionChanged(String? newValue) {
    if (newValue != null) {
      selectedOption.value = newValue;
      errorText.value =
          ''; // Menghilangkan pesan kesalahan saat kategori dipilih
    } else {
      errorText.value = 'Pilih salah satu opsi';
    }
  }
}
