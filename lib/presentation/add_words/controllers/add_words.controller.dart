import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/theme.dart';

class AddWordsController extends GetxController {
  final progress = RxDouble(0.0);
  File? _audioFilePria;
  RxBool isSelectedPria = false.obs;

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
      sendDataToFirebase();
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
      const maxSize = 1 * 1024 * 1024; // maksimum ukuran file 1MB
      if (fileSize > maxSize) {
        infoFailed(
            "Terjadi kesalahan", "Ukuran file tidak boleh lebih dari 1MB");

        return;
      }

      _audioFilePria = file;
      isSelectedPria.value = true;

      update();
    }
  }

  void resetAudioPria() {
    _audioFilePria = null;
    isSelectedPria.value = false;
    update();
  }

  String get audioFileNamePria =>
      _audioFilePria != null ? _audioFilePria!.path.split('/').last : '';
  String get audioFileSizePria => _audioFilePria != null
      ? '${(_audioFilePria!.lengthSync() / 1024).toStringAsFixed(2)} KB'
      : '';

  ///PRIAwANITA
  Future<void> pickAudioWanita() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      const maxSize = 1 * 1024 * 1024; // maksimum ukuran file 1MB
      if (fileSize > maxSize) {
        infoFailed(
            "Terjadi kesalahan", "Ukuran file tidak boleh lebih dari 1MB");

        return;
      }

      _audioFileWanita = file;
      isSelectedWanita.value = true;

      update();
    }
  }

  void resetAudioWanita() {
    _audioFileWanita = null;
    isSelectedWanita.value = false;
    update();
  }

  String get audioFileNameWanita =>
      _audioFileWanita != null ? _audioFileWanita!.path.split('/').last : '';
  String get audioFileSizeWanita => _audioFileWanita != null
      ? '${(_audioFileWanita!.lengthSync() / 1024).toStringAsFixed(2)} KB'
      : '';

  Future<void> sendDataToFirebase() async {
    if (selectedOption.value.isEmpty || errorText.value.isNotEmpty) {
      // Tampilkan pesan error jika kategori belum dipilih atau ada pesan error pada dropdown
      errorText.value = 'Pilih salah satu kategori';
      return;
    }

    // Pastikan ada koneksi internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      infoFailed(
          "Tidak ada Internet", "Silahkan periksa koneksi internet Anda");
      return;
    }

    // Add confirmation dialog here
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
          'Apakah Anda yakin ingin menambahkan data kata baru?',
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

    if (!(confirmed ?? false)) {
      return;
    }

    // Ambil referensi ke Firebase Storage dan Firestore
    final firestoreRef = FirebaseFirestore.instance.collection('kamus').doc();

    // Ambil referensi ke koleksi Firestore
    final firestoreCollectionRef =
        FirebaseFirestore.instance.collection('kamus');

    // Cek apakah kataIndonesia sudah ada dalam database
    final existingWordSnapshots = await firestoreCollectionRef
        .where('kataIndonesia', isEqualTo: kIndo.text)
        .get();
    if (existingWordSnapshots.docs.isNotEmpty) {
      // Kata dalam Bahasa Indonesia sudah ada dalam database
      infoFailed("Gagal menambah kata baru", "Kata ini sudah ditambahkan");
      return;
    }

    try {
      // Tampilkan dialog progress dan progress bar
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              // Tampilkan pesan bahwa proses upload sedang berjalan
              Get.snackbar('Info', 'Proses upload sedang berjalan...');
              return false;
            },
            child: AlertDialog(
              title: Text(
                'Sedang mengirim data...',
                style: darkBlueTextStyle.copyWith(fontWeight: medium),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => LinearProgressIndicator(
                      value: progress
                          .value)), // Ubah progress menjadi sebuah variabel Rx agar dapat diupdate secara reactive
                  const SizedBox(height: 16),
                  Obx(() => Text(
                      '${(progress.value * 100).toStringAsFixed(0)}%')), // Ubah progress menjadi sebuah variabel Rx agar dapat diupdate secara reactive
                ],
              ),
            ),
          );
        },
      );

      String? downloadUrlPria;
      String? downloadUrlWanita;

      // Upload file audio untuk pria ke Firebase Storage dan update progress bar, jika ada
      if (_audioFilePria != null) {
        final storageRefPria = FirebaseStorage.instance
            .ref()
            .child('audioPria/${DateTime.now().toString()}');
        final taskpria = storageRefPria.putFile(_audioFilePria!);
        taskpria.snapshotEvents.listen((snapshot) {
          updateProgress(snapshot);
        });
        await taskpria;

        // Set metadata file audio menjadi "audio/mpeg"
        final metadata = SettableMetadata(contentType: 'audio/mpeg');
        await storageRefPria.updateMetadata(metadata);

        // Simpan URL file audio di Firestore
        downloadUrlPria = await storageRefPria.getDownloadURL();
      }

      // Upload file audio untuk wanita ke Firebase Storage dan update progress bar, jika ada
      if (_audioFileWanita != null) {
        final storageRefWanita = FirebaseStorage.instance
            .ref()
            .child('audioWanita/${DateTime.now().toString()}');
        final taskWanita = storageRefWanita.putFile(_audioFileWanita!);
        taskWanita.snapshotEvents.listen((snapshot) {
          updateProgress(snapshot);
        });
        await taskWanita;

        // Set metadata file audio menjadi "audio/mpeg"
        final metadata = SettableMetadata(contentType: 'audio/mpeg');
        await storageRefWanita.updateMetadata(metadata);

        // Simpan URL file audio di Firestore
        downloadUrlWanita = await storageRefWanita.getDownloadURL();
      }

      // Simpan data lainnya di Firestore
      await firestoreRef.set({
        'audioUrlPria': downloadUrlPria,
        'audioUrlWanita': downloadUrlWanita,
        'kataSahu': kSahu.text,
        'contohKataSahu': cKSahu.text,
        'kataIndonesia': kIndo.text,
        'contohKataIndo': cKIndo.text,
        'kategori': selectedOption.value,
        'addDataTime': DateTime.now().toIso8601String(),
      });

      // Reset file audio jika ada
      if (_audioFilePria != null) {
        resetAudioPria();
      }

      if (_audioFileWanita != null) {
        resetAudioWanita();
      }

      // Tampilkan pesan sukses
      infoSuccess("Berhasil", "Data berhasil tersimpan");
    } on FirebaseException {
      // Tampilkan pesan kesalahan
      infoFailed("Gagal mengunggah file audio",
          "Terjadi Kesalahan saat menggungah file audio");
    } finally {
      // Tutup dialog progress
      Navigator.of(Get.overlayContext!).pop();

      // Cek apakah progress sudah 100% atau tidak ada file audio
      if (progress.value == 1.0 ||
          (_audioFilePria == null && _audioFileWanita == null)) {
        // Ubah progress menjadi sebuah variabel Rx agar dapat diupdate secara reactive
        // Kembali ke halaman utama setelah proses upload selesai
        Future.delayed(const Duration(milliseconds: 1),
            () => Get.offAllNamed(Routes.admin));
      }
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
      duration: const Duration(seconds: 2),
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
