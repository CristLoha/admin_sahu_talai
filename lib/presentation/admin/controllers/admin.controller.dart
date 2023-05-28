import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  RxList<DocumentSnapshot> documents = <DocumentSnapshot>[].obs;
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  @override
  void onInit() {
    super.onInit();
    getKamusData().listen((data) {
      documents.value = data;
    });
  }

  Stream<List<DocumentSnapshot>> getKamusData() {
    return kamus.snapshots().map((snapshot) {
      return snapshot.docs;
    });
  }
}
