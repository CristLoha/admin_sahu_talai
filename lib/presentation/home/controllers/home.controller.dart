import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/aho_corasick.dart';

class HomeController extends GetxController {
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

  void search(String query) {
    query = query.replaceAll('_', '');
    final indices = List.generate(patterns.length, (_) => <int>[]);
    Stopwatch stopwatch = Stopwatch()..start();
    ahoCorasick.searchPattern(query, indices);
    stopwatch.stop();
    searchResults.clear();
    bool dataFound = false;

    for (int i = 0; i < patterns.length; i++) {
      if (indices[i].isNotEmpty) {
        String originalPattern = patterns.values.elementAt(i);
        searchResults.add(originalPattern);
        dataFound = true;

        print('Kata "$originalPattern" ditemukan!');
        print('Total kemunculan "$originalPattern": ${indices[i].length}');
        print('Posisi kemunculan ke-${i + 1}: ${indices[i].join(', ')}');
        print('----');
      }
    }

    if (dataFound) {
      Get.snackbar(
        'Hasil Pencarian',
        'Kata "$query" ditemukan dalam ${stopwatch.elapsed.inMilliseconds} ms',
      );
    } else {
      searchResults.clear();
      searchResults.add("Data tidak cocok");
      print('Data tidak cocok');
    }

    print(
        'Aho-Corasick matching executed in ${stopwatch.elapsedMilliseconds} ms');
    print(
        'Aho-Corasick matching executed in ${stopwatch.elapsedMilliseconds / 1000} seconds');
  }
}
