import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PaginationController extends GetxController {
  final CollectionReference kamus =
      FirebaseFirestore.instance.collection('kamus');
  Rx<DocumentSnapshot?> lastDocument = Rx<DocumentSnapshot?>(null);
  RxList<DocumentSnapshot> documents = RxList<DocumentSnapshot>();
  bool isLoading = false;

  Future<void> loadData({bool isNew = false}) async {
    if (isLoading) return;
    isLoading = true;

    if (isNew) {
      lastDocument.value = null;
      documents.clear();
    }

    QuerySnapshot snapshot;
    if (lastDocument.value != null) {
      snapshot =
          await kamus.startAfterDocument(lastDocument.value!).limit(5).get();
    } else {
      snapshot = await kamus.limit(5).get();
    }

    if (snapshot.docs.isNotEmpty) {
      lastDocument.value = snapshot.docs.last;
      documents.addAll(snapshot.docs);
    }

    isLoading = false;
  }

  @override
  void onInit() {
    super.onInit();
    loadData(isNew: true);
  }
}
