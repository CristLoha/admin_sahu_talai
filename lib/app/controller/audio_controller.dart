import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

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
}
