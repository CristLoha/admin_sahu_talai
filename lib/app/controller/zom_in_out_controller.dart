import 'package:get/get.dart';

class ZoomInOutController extends GetxController {
  // State untuk mengatur faktor zoom
  final RxDouble _scaleFactor = RxDouble(1.0);

  // Getter untuk mendapatkan nilai _scaleFactor
  double get scaleFactor => _scaleFactor.value;

  // Setter untuk mengubah nilai _scaleFactor
  void setScaleFactor(double value) {
    _scaleFactor.value = value;
    update(); // Update UI ketika nilai _scaleFactor berubah
  }

  // Fungsi untuk melakukan zoom in
  void zoomIn() {
    _scaleFactor.value += 0.1;
    update(); // Update UI ketika nilai _scaleFactor berubah
  }

  // Fungsi untuk melakukan zoom out
  void zoomOut() {
    _scaleFactor.value -= 0.1;
    update(); // Update UI ketika nilai _scaleFactor berubah
  }
}
