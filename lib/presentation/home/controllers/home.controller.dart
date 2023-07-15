import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/theme/theme.dart';
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

  // void search() {
  //   String query = searchController.text.replaceAll('_', '');
  //   List<String> tokens = query.split(' ');
  //   query = query.replaceAllMapped(RegExp(r'_\w'), (m) => '${m.group(0)![1]}̲');
  //   Stopwatch stopwatch = Stopwatch()..start();

  //   searchResults.clear();
  //   bool dataFound = false;

  //   for (String token in tokens) {
  //     final indices = List.generate(patterns.length, (_) => <int>[]);
  //     ahoCorasick.searchPattern(token, indices);

  //     for (int i = 0; i < patterns.length; i++) {
  //       if (indices[i].isNotEmpty) {
  //         QueryDocumentSnapshot originalPattern = patterns.values.elementAt(i);
  //         if (!searchResults.contains(originalPattern)) {
  //           String originalPatternInd = originalPattern.get('kataIndonesia');
  //           String originalPatternSahu = originalPattern.get('kataSahu');
  //           if (selectedOption.value == 'Semua' ||
  //               selectedOption.value == categories[originalPatternInd] ||
  //               selectedOption.value == categories[originalPatternSahu]) {
  //             searchResults.add(originalPattern);
  //             dataFound = true;
  //           }
  //         }
  //       }
  //     }
  //   }

  //   stopwatch.stop();

  //   if (!dataFound && searchController.text.isNotEmpty) {
  //     Get.snackbar('Hasil Pencarian', 'Kata tidak ditemukan');
  //   } else {
  //     filteredResults = RxList<QueryDocumentSnapshot>.from(searchResults);
  //   }

  //   update();
  // }
  /// menghapus tokens
  void search() {
    String query = searchController.text.replaceAll('_', '');
    query = query.replaceAllMapped(RegExp(r'_\w'), (m) => '${m.group(0)![1]}̲');
    Stopwatch stopwatch = Stopwatch()..start();

    searchResults.clear();
    bool dataFound = false;
    int resultCount = 0; // Menyimpan jumlah hasil yang telah ditemukan

    final indices = List.generate(patterns.length, (_) => <int>[]);
    ahoCorasick.searchPattern(query, indices);

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
            resultCount++; // Meningkatkan jumlah hasil yang ditemukan
            ahoCorasick.buildSuffixAndOutputLinks();
            ahoCorasick.printTransitionTable();
            // ahoCorasick.bfs();
            if (resultCount >= 3) {
              // Jika jumlah hasil sudah mencapai 3, hentikan pencarian
              break;
            }
          }
        }
      }
    }

    stopwatch.stop();

    // Get.snackbar('d', 'dd');
    if (!dataFound && searchController.text.isNotEmpty) {
      infoFailed(
          msg1: 'Hasil Pencarian',
          msg2: "Kata ${searchController.text} tidak ditemukan");
    } else {
      filteredResults = RxList<QueryDocumentSnapshot>.from(searchResults);
      print(
          'Kata ${searchController.text} ditemukan dalam ${stopwatch.elapsedMilliseconds} ms');
      print(
          'Kata ${searchController.text} ditemukan dalam ${stopwatch.elapsedMilliseconds / 1000} detik');
      infoSuccess("Hasil Pencarian",
          "Kata ${searchController.text} ditemukan dalam  ${stopwatch.elapsedMilliseconds / 1000} detik ");
    }

    update();
  }

  List<String> options = [
    'Semua',
    'Benda',
    'Kerja',
    'Sifat',
    'Tempat/Lokasi',
    'Panggilan',
    'Angka',
    'Depan',
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

  void infoFailed({String? msg1, String? msg2}) {
    Get.snackbar(
      "",
      "",
      backgroundColor: oldRose,
      colorText: white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(0),
      borderRadius: 0,
      duration: const Duration(seconds: 8),
      animationDuration: const Duration(milliseconds: 600),
      reverseAnimationCurve: Curves.easeInBack,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      showProgressIndicator: false,
      overlayBlur: 0.0,
      overlayColor: darkBlue,
      icon: const Icon(
        EvaIcons.alertCircleOutline,
        color: white,
      ),
      shouldIconPulse: true,
      leftBarIndicatorColor: oldRose,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      snackStyle: SnackStyle.FLOATING,
      titleText: Text(
        msg1!,
        style: whiteTextStyle.copyWith(
          fontWeight: bold,
        ),
      ),
      messageText: Text(
        msg2!,
        style: whiteTextStyle.copyWith(fontWeight: medium, fontSize: 12),
      ),
    );
  }

  void infoSuccess(String msg1, String msg2) {
    Get.snackbar(
      "",
      "",
      backgroundColor: shamrockGreen,
      colorText: white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(0),
      borderRadius: 0,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 600),
      reverseAnimationCurve: Curves.easeInBack,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      showProgressIndicator: false,
      overlayBlur: 0.0,
      overlayColor: white, // Menggunakan warna putih
      icon: const Icon(
        EvaIcons.checkmarkCircle2Outline,
        color: white,
      ),
      shouldIconPulse: true,
      leftBarIndicatorColor: shamrockGreen,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      snackStyle: SnackStyle.FLOATING,
      titleText: Text(
        msg1,
        style: whiteTextStyle.copyWith(
          fontWeight: bold,
        ),
      ),
      messageText: Text(
        msg2,
        style: whiteTextStyle.copyWith(fontWeight: medium, fontSize: 12),
      ),
    );
  }
}
