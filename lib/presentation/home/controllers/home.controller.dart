import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/aho_corasick.dart';

class HomeController extends GetxController {
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  final AhoCorasick ahoCorasick = AhoCorasick();
  final List<String> patterns = [];
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
      patterns.add(doc.get('kataIndonesia'));
    }
    ahoCorasick.buildTrie(patterns);
    ahoCorasick.buildSuffixAndOutputLinks();
  }

  void search(String query) {
    final indices = List.generate(patterns.length, (_) => <int>[]);
    ahoCorasick.searchPattern(query, indices);
    searchResults.clear();
    for (int i = 0; i < patterns.length; i++) {
      if (indices[i].isNotEmpty) {
        searchResults.add(patterns[i]);
      }
    }
  }
}
