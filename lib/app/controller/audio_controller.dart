import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../infrastructure/theme/theme.dart';

class AudioController extends GetxController {
  RxBool isPlayingPria = false.obs;
  RxBool isPlayingWanita = false.obs;

  final audioPlayerPria = AudioPlayer();
  final audioPlayerWanita = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    listenToPlayer(audioPlayerPria, isPlayingPria);
    listenToPlayer(audioPlayerWanita, isPlayingWanita);
  }

  void listenToPlayer(AudioPlayer player, RxBool playing) {
    player.playingStream.listen((playingState) {
      playing.value = playingState;
    });

    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playing.value = false;
      }
    });
  }

  @override
  void onClose() {
    audioPlayerPria.dispose();
    audioPlayerWanita.dispose();
    super.onClose();
  }

  Future<void> togglePlayingPria(String audioUrl) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      infoFailed("Tidak dapat memutar audio",
          "Anda membutuhkan koneksi internet untuk memutar audio");
      return;
    }

    if (isPlayingPria.value) {
      await audioPlayerPria.stop();
    } else {
      if (isPlayingWanita.value) {
        await audioPlayerWanita.stop();
        isPlayingWanita.value = false;
      }
      await audioPlayerPria.setUrl(audioUrl);
      await audioPlayerPria.play();
      isPlayingPria.value = true;
    }
  }

  Future<void> togglePlayingWanita(String audioUrl) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      infoFailed("Tidak dapat memutar audio",
          "Anda membutuhkan koneksi internet untuk memutar audio");
      return;
    }

    if (isPlayingWanita.value) {
      await audioPlayerWanita.stop();
    } else {
      if (isPlayingPria.value) {
        await audioPlayerPria.stop();
        isPlayingPria.value = false;
      }
      await audioPlayerWanita.setUrl(audioUrl);
      await audioPlayerWanita.play();
      isPlayingWanita.value = true;
    }
  }

  void infoFailed(String msg1, String msg2) {
    Get.snackbar(
      "",
      "",
      backgroundColor: oldRose,
      colorText: white,
      snackPosition: SnackPosition.TOP,
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
}
