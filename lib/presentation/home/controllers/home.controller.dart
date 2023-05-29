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

  final TextEditingController searchController = TextEditingController();
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  final AhoCorasick ahoCorasick = AhoCorasick();
  final Map<String, String> patterns = {};
  final RxList<String> searchResults = RxList<String>();

  Stream<QuerySnapshot> getStream() {
    if (selectedOption.value == 'Tampilkan Semua') {
      return kamus.snapshots();
    } else {
      return kamus
          .where('kategori', isEqualTo: selectedOption.value)
          .snapshots();
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(selectedOption, (_) => loadPatterns());
  }

  Future<void> loadPatterns() async {
    final snapshot = await getStream().first;
    if (snapshot.docs.isEmpty) {
      Get.snackbar('Informasi', 'Tidak ada data untuk kategori ini');
    } else {
      patterns.clear();
      for (var doc in snapshot.docs) {
        String originalPattern = doc.get('kataSahu');
        String searchPattern = originalPattern.replaceAll('_', '');
        patterns[searchPattern] = originalPattern;
      }
      ahoCorasick.buildTrie(patterns.keys.toList());
      ahoCorasick.buildSuffixAndOutputLinks();
    }
  }

  void search() {
    String query = searchController.text.replaceAll('_', '');
    List<String> tokens = query.split(' ');
    query.replaceAllMapped(RegExp(r'_\w'), (m) => '${m.group(0)![1]}̲');
    Stopwatch stopwatch = Stopwatch()..start();

    searchResults.clear();
    bool dataFound = false;

    for (String token in tokens) {
      final indices = List.generate(patterns.length, (_) => <int>[]);
      ahoCorasick.searchPattern(token, indices);

      for (int i = 0; i < patterns.length; i++) {
        if (indices[i].isNotEmpty) {
          String originalPattern = patterns.values.elementAt(i);
          if (!searchResults.contains(originalPattern)) {
            searchResults.add(originalPattern);
            dataFound = true;
          }
        }
      }
    }

    stopwatch.stop();

    if (!dataFound) {
      searchResults.add("Data tidak cocok");
      Get.snackbar('Hasil Pencarian', 'Kata tidak ditemukan');
    }
  }

  RxString selectedOption = 'Tampilkan Semua'.obs;
  List<String> options = [
    'Tampilkan Semua',
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
      errorText.value = '';
      loadPatterns();
      search();
    } else {
      errorText.value = 'Pilih salah satu opsi';
    }
  }
}
