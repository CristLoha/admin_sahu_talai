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

  RxList<String> filteredResults = RxList<String>();

  RxString selectedOption = 'Semua'.obs;

  final TextEditingController searchController =
      TextEditingController(); // Tambahkan ini
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  final AhoCorasick ahoCorasick = AhoCorasick();
  final Map<String, String> patterns = {}; // Ubah ini
  final RxList<String> searchResults = RxList<String>();

  Rx<Stream<QuerySnapshot>> stream = const Stream<QuerySnapshot>.empty().obs;
  Stream<QuerySnapshot> getStream() {
    if (selectedOption.value == 'Semua') {
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
    stream.value = getStream();
    loadPatterns();
  }

  Future<void> loadPatterns() async {
    QuerySnapshot snapshot;

    if (selectedOption.value == 'Semua') {
      snapshot = await kamus.get();
    } else {
      snapshot =
          await kamus.where('kategori', isEqualTo: selectedOption.value).get();
    }
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
    query = query.replaceAllMapped(RegExp(r'_\w'), (m) => '${m.group(0)![1]}̲');
    Stopwatch stopwatch = Stopwatch()..start();

    searchResults.clear();
    bool dataFound = false;

    if (selectedOption.value == 'Semua') {
      for (String token in tokens) {
        final indices = List.generate(patterns.length, (_) => <int>[]);
        ahoCorasick.searchPattern(token, indices);

        for (int i = 0; i < patterns.length; i++) {
          if (indices[i].isNotEmpty) {
            String originalPattern = patterns.values.elementAt(i);
            if (!searchResults.contains(originalPattern)) {
              searchResults.add(originalPattern);
              dataFound = true;

              print('Kata "$originalPattern" ditemukan pada kata "$token"!');
              print(
                  'Total kemunculan "$originalPattern": ${indices[i].length}');
              print('Posisi kemunculan ke-${i + 1}: ${indices[i].join(', ')}');
              print('----');
            }
          }
        }
      }
    } else {
      final indices = List.generate(patterns.length, (_) => <int>[]);
      for (String token in tokens) {
        ahoCorasick.searchPattern(token, indices);
      }

      for (int i = 0; i < patterns.length; i++) {
        if (indices[i].isNotEmpty) {
          String originalPattern = patterns.values.elementAt(i);
          if (!searchResults.contains(originalPattern)) {
            searchResults.add(originalPattern);
            dataFound = true;

            print('Kata "$originalPattern" ditemukan!');
            print('Total kemunculan "$originalPattern": ${indices[i].length}');
            print('Posisi kemunculan ke-${i + 1}: ${indices[i].join(', ')}');
            print('----');
          }
        }
      }
    }

    stopwatch.stop();

    if (!dataFound && searchController.text.isNotEmpty) {
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

  List<String> options = [
    'Semua',
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
  void updateCategory(String category) {
    selectedOption.value = category;
    if (selectedOption.value != 'Semua') {
      loadPatterns().then((_) {
        search(); // Memulai pencarian ulang setelah memuat pola baru
      });
    } else {
      searchResults
          .clear(); // Menghapus hasil pencarian jika kategori "Semua" dipilih
    }
  }

  Future<void> onOptionChanged(String? newValue) async {
    if (newValue != null) {
      selectedOption.value = newValue;
      stream.value = getStream();
      await loadPatterns(); // Menunggu ini selesai
      errorText.value = '';
    } else {
      errorText.value = 'Pilih salah satu opsi';
    }
  }
}
