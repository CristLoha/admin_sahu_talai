import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/aho_corasick.dart';

enum LanguageDirection { indSahu, sahuInd }

class HomeController extends GetxController {
  Rx<LanguageDirection> selectedDirection = LanguageDirection.indSahu.obs;
  var errorText = ''.obs;
  var isFieldEmpty =
      true.obs; // Nilai awalnya true, yang berarti TextField kosong.

  void setDirection(LanguageDirection direction) {
    selectedDirection.value = direction;
    loadPatterns(); // Memanggil loadPatterns setelah merubah arah
  }

  RxList<String> filteredResults = RxList<String>();
  RxString selectedOption = 'Semua'.obs;

  final TextEditingController searchController = TextEditingController();
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  final AhoCorasick ahoCorasick = AhoCorasick();
  final Map<String, String> patterns = {};
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
    searchController.addListener(() {
      isFieldEmpty.value = searchController.text.isEmpty;
      print('icon muncul');
    });
  }

  final Map<String, String> categories = {};

  Future<void> loadPatterns() async {
    QuerySnapshot snapshot;

    if (selectedOption.value == 'Semua') {
      snapshot = await kamus.get();
    } else {
      snapshot =
          await kamus.where('kategori', isEqualTo: selectedOption.value).get();
    }

    patterns.clear();
    categories.clear();

    List<DocumentSnapshot> docs = snapshot.docs;

    // Sort the documents
    docs.sort((a, b) => (selectedDirection.value == LanguageDirection.indSahu
            ? a.get('kataIndonesia')
            : a.get('kataSahu'))
        .compareTo(selectedDirection.value == LanguageDirection.indSahu
            ? b.get('kataIndonesia')
            : b.get('kataSahu')));

    for (var doc in docs) {
      String originalPattern =
          selectedDirection.value == LanguageDirection.indSahu
              ? doc.get('kataIndonesia')
              : doc.get('kataSahu');
      String searchPattern = originalPattern.replaceAll('_', '');
      patterns[searchPattern] = originalPattern;
      categories[originalPattern] = doc.get('kategori');
    }

    ahoCorasick.buildTrie(patterns.keys.toList());
    ahoCorasick.buildSuffixAndOutputLinks();
  }

  void search() {
    String query = searchController.text.replaceAll('_', '');
    List<String> tokens = query.split(' ');
    query = query.replaceAllMapped(RegExp(r'_\w'), (m) => '${m.group(0)![1]}̲');
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
            if (selectedOption.value == 'Semua' ||
                selectedOption.value == categories[originalPattern]) {
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
    }

    stopwatch.stop();

    if (!dataFound && searchController.text.isNotEmpty) {
      searchResults.clear();
      filteredResults.clear();
      searchResults.add("Data tidak cocok");
      filteredResults.add("Data tidak cocok");
      Get.snackbar(
        'Hasil Pencarian',
        'Kata tidak ditemukan',
      );

      // Menampilkan pesan kategori tidak cocok jika ditemukan
      if (selectedOption.value != 'Semua') {
        filteredResults.clear();
        filteredResults
            .add("Kata tidak cocok dengan kategori '${selectedOption.value}'");
      }
    } else {
      filteredResults = RxList<String>.from(searchResults);
    }

    update(); // Memperbarui tampilan UI

    print(
      'Aho-Corasick matching executed in ${stopwatch.elapsedMilliseconds} ms',
    );
    print(
      'Aho-Corasick matching executed in ${stopwatch.elapsedMilliseconds / 1000} seconds',
    );
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
    stream.value = getStream();
    loadPatterns().then((_) {
      search();
      filteredResults = RxList<String>.from(searchResults);
      update(); // Menambahkan ini untuk memperbarui tampilan UI
    });
  }

  Future<void> onOptionChanged(String? newValue) async {
    if (newValue != null) {
      selectedOption.value = newValue;
      stream.value = getStream();
      await loadPatterns();
      errorText.value = '';
    } else {
      errorText.value = 'Pilih salah satu opsi';
    }
  }
}
