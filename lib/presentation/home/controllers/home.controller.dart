import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/aho_corasick.dart';

enum LanguageDirection { indSahu, sahuInd }

class HomeController extends GetxController {
  Rx<LanguageDirection> selectedDirection = LanguageDirection.indSahu.obs;
  var errorText = ''.obs;
  var isFieldEmpty = true.obs;

  void setDirection(LanguageDirection direction) {
    selectedDirection.value = direction;
    loadPatterns();
  }

  RxList<QueryDocumentSnapshot> filteredResults =
      RxList<QueryDocumentSnapshot>();
  RxString selectedOption = 'Semua'.obs;

  final TextEditingController searchController = TextEditingController();
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  final AhoCorasick ahoCorasick = AhoCorasick();
  final Map<String, QueryDocumentSnapshot> patterns = {};
  final RxList<QueryDocumentSnapshot> searchResults =
      RxList<QueryDocumentSnapshot>();

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

    for (var doc in snapshot.docs) {
      String originalPattern =
          selectedDirection.value == LanguageDirection.indSahu
              ? doc.get('kataIndonesia')
              : doc.get('kataSahu');
      String searchPattern = originalPattern.replaceAll('_', '');
      patterns[searchPattern] = doc;
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
          QueryDocumentSnapshot originalPattern = patterns.values.elementAt(i);
          if (!searchResults.contains(originalPattern)) {
            String originalPatternInd = originalPattern.get('kataIndonesia');
            String originalPatternSahu = originalPattern.get('kataSahu');
            if (selectedOption.value == 'Semua' ||
                selectedOption.value == categories[originalPatternInd] ||
                selectedOption.value == categories[originalPatternSahu]) {
              searchResults.add(originalPattern);
              dataFound = true;
            }
          }
        }
      }
    }

    stopwatch.stop();

    if (!dataFound && searchController.text.isNotEmpty) {
      Get.snackbar('Hasil Pencarian', 'Kata tidak ditemukan');
    } else {
      filteredResults = RxList<QueryDocumentSnapshot>.from(searchResults);
    }

    update();
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
      filteredResults = RxList<QueryDocumentSnapshot>.from(searchResults);
      update();
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
