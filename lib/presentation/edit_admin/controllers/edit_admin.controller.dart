import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/theme.dart';

class EditAdminController extends GetxController {
  final GlobalKey<FormState> formKe1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final progress = RxDouble(0.0);
  File? _audioFilePria;
  RxBool isSelectedPria = false.obs;
  final audioFileNamePria = ''.obs;
  final audioFileNameWanita = ''.obs;

  File? _audioFileWanita;
  RxBool isSelectedWanita = false.obs;

  var errorText = ''.obs;

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

  TextEditingController kSahu = TextEditingController();
  TextEditingController cKSahu = TextEditingController();
  TextEditingController kIndo = TextEditingController();
  TextEditingController cKIndo = TextEditingController();
  TextEditingController kategori = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  // Future<void> initData(Map<String, dynamic> data) async {
  //   kSahu.text = data['kataSahu'] ?? '';
  //   cKSahu.text = data['contohKataSahu'] ?? '';
  //   kIndo.text = data['kataIndonesia'] ?? '';
  //   cKIndo.text = data['contohKataIndo'] ?? '';
  //   kategori.text = data['kategori'] ?? '';
  //   audioFileNamePria.value = data['audioUrlPria'] ?? '';
  //   audioFileNameWanita.value = data['audioUrlWanita'] ?? '';
  // }
  Future<void> getKamusId(String docId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await FirebaseFirestore.instance.collection('kamus').doc(docId).get();

      // Cek apakah dokumen ada
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data();

        if (data != null) {
          // Memasukkan data ke dalam TextEditingController dan RxString
          kSahu.text = data['kataSahu'] ?? '';
          cKSahu.text = data['contohKataSahu'] ?? '';
          kIndo.text = data['kataIndonesia'] ?? '';
          cKIndo.text = data['contohKataIndo'] ?? '';
          kategori.text = data['kategori'] ?? '';
          selectedOption.value = data['kategori'];

          if (data['audioUrlPria'] != null) {
            Uri audioUri = Uri.parse(data['audioUrlPria']);
            String fileName = audioUri.pathSegments.last
                .replaceFirst('audioPria/', '')
                .trim();
            audioFileNamePria.value = fileName;
          }

          if (data['audioUrlWanita'] != null) {
            Uri audioUri = Uri.parse(data['audioUrlWanita']);
            String fileName = audioUri.pathSegments.last
                .replaceFirst('audioWanita/', '')
                .trim();
            audioFileNameWanita.value = fileName;
          }
        }
      } else {
        print('No such document!');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    String docId = Get.arguments; // misalnya ambil dari argumen
    getKamusId(docId);
  }

  void updateProgress(TaskSnapshot snapshot) {
    progress.value = snapshot.bytesTransferred / snapshot.totalBytes;
  }

  String get selectedValue => selectedOption.value;

  void onOptionChanged(String? newValue) {
    if (newValue != null) {
      selectedOption.value = newValue;
      errorText.value =
          ''; // Menghilangkan pesan kesalahan saat kategori dipilih
    } else {
      errorText.value = 'Pilih salah satu opsi';
    }
  }

  void handleSubmit() {
    if (selectedOption.value.isEmpty) {
      // Jika dropdown belum dipilih, tampilkan pesan error
      errorText.value = 'Pilih salah satu opsi';
    } else if (kategori.text.isEmpty) {
      // Jika teks field kosong, tampilkan pesan error
      errorText.value = 'Input tidak boleh kosong';
    } else {
      // Simpan nilai kategori ke dalam controller
      kategori.text = selectedOption.value;
      // Kirim data
      sendDataToFirebase(Get.arguments);
    }
  }

  ///PRIA
  Future<void> pickAudioPria() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      const maxSize = 1 * 1024 * 1024; // maximum file size 1MB
      if (fileSize > maxSize) {
        infoFailed(
            "Terjadi kesalahan", "Ukuran file tidak boleh lebih dari 1MB");
        return;
      }

      _audioFilePria = file;
      audioFileNamePria.value = file.path.split('/').last;
      isSelectedPria.value = true;

      update();
    }
  }

  void resetAudioPria() {
    _audioFilePria = null;
    isSelectedPria.value = false;
    audioFileNamePria.value = ''; // reset the audio file name
    update();
  }

  String get audioFileSizePria => _audioFilePria != null
      ? '${(_audioFilePria!.lengthSync() / 1024).toStringAsFixed(2)} KB'
      : '';

  ///WANITA
  Future<void> pickAudioWanita() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      const maxSize = 1 * 1024 * 1024; // maximum file size 1MB
      if (fileSize > maxSize) {
        infoFailed(
            "Terjadi kesalahan", "Ukuran file tidak boleh lebih dari 1MB");
        return;
      }

      _audioFileWanita = file;
      audioFileNameWanita.value = file.path.split('/').last;
      isSelectedWanita.value = true;

      update();
    }
  }

  void resetAudioWanita() {
    _audioFileWanita = null;
    isSelectedWanita.value = false;
    audioFileNameWanita.value = ''; // reset the audio file name
    update();
  }

  String get audioFileSizeWanita => _audioFileWanita != null
      ? '${(_audioFileWanita!.lengthSync() / 1024).toStringAsFixed(2)} KB'
      : '';

  ///UPDATE DATA
  Future<void> sendDataToFirebase(String docId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      infoFailed(
          "Tidak ada Internet", "Silahkan periksa koneksi internet Anda");
      return;
    }

    final storageRefPria = FirebaseStorage.instance
        .ref()
        .child('audioPria/${DateTime.now().toString()}');

    final storageRefWanita = FirebaseStorage.instance
        .ref()
        .child('audioWanita/${DateTime.now().toString()}');

    final firestoreRef =
        FirebaseFirestore.instance.collection('kamus').doc(docId);

    // Add this line
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    try {
      var downloadUrlPria = '';
      var downloadUrlWanita = '';

      // Only upload the file if it was selected
      if (_audioFilePria != null) {
        final taskpria = storageRefPria.putFile(_audioFilePria!);
        await taskpria;

        final metadata = SettableMetadata(contentType: 'audio/mpeg');
        await storageRefPria.updateMetadata(metadata);
        downloadUrlPria = await storageRefPria.getDownloadURL();
      }

      // Only upload the file if it was selected
      if (_audioFileWanita != null) {
        final taskWanita = storageRefWanita.putFile(_audioFileWanita!);
        await taskWanita;

        final metadata = SettableMetadata(contentType: 'audio/mpeg');
        await storageRefWanita.updateMetadata(metadata);
        downloadUrlWanita = await storageRefWanita.getDownloadURL();
      }

      var dataToUpdate = {
        'kataSahu': kSahu.text,
        'contohKataSahu': cKSahu.text,
        'kataIndonesia': kIndo.text,
        'contohKataIndo': cKIndo.text,
        'kategori': selectedOption.value,
        'updatedTime': DateTime.now().toIso8601String(),
      };

      // Only add the URL to the data if the file was uploaded
      if (downloadUrlPria.isNotEmpty) {
        dataToUpdate['audioUrlPria'] = downloadUrlPria;
      }

      // Only add the URL to the data if the file was uploaded
      if (downloadUrlWanita.isNotEmpty) {
        dataToUpdate['audioUrlWanita'] = downloadUrlWanita;
      }
      await firestoreRef.update(dataToUpdate);

      resetAudioPria();
      resetAudioWanita();

      // Tambahkan delay sebelum menghilangkan dialog loading
      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Menghilangkan dialog loading

      infoSuccess("Berhasil", "Data berhasil diubah");

      // Tambahkan delay sebelum navigasi
      await Future.delayed(const Duration(seconds: 2));
    } on FirebaseException {
      // Tambahkan delay sebelum menghilangkan dialog loading
      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Menghilangkan dialog loading

      infoFailed("Gagal mengunggah file audio",
          "Terjadi Kesalahan saat menggungah file audio");
    } finally {
      Get.offAllNamed(Routes.admin);
    }
  }

  void infoFailed(String msg1, String msg2) {
    Get.snackbar(
      "",
      "",
      backgroundColor: oldRose,
      colorText: white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(0),
      borderRadius: 0,
      duration: const Duration(seconds: 4),
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

  void infoSuccess(String msg1, String msg2) {
    Get.snackbar(
      "",
      "",
      backgroundColor: shamrockGreen,
      colorText: white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(0),
      borderRadius: 0,
      duration: const Duration(seconds: 4),
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
