import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GetDataController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<DocumentSnapshot<Object?>> getData(String docId) async {
    DocumentReference documentReference =
        firestore.collection('kamus').doc(docId);
    return documentReference.get();
  }
}
