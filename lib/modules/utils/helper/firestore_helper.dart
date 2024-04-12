import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future adddata(
      {required Map<String, dynamic> data, required dynamic id}) async {
    return await firestore.collection("Product").doc("$id").set(data);
  }

  Stream<QuerySnapshot> fetchdata() {
    return firestore.collection("Product").snapshots();
  }

  Future updatedata(
      {required Map<String, dynamic> newdata, required dynamic id}) async {
    return await firestore.collection("Product").doc("$id").update(newdata);
  }

  Stream<QuerySnapshot> fetchcoupon() {
    Stream<QuerySnapshot<Map<String, dynamic>>> data =
        firestore.collection("Coupon").snapshots();
    return data;
  }

  Future updatecoupon(
      {required Map<String, dynamic> newdata, required dynamic id}) async {
    return await firestore.collection("Coupon").doc("$id").update(newdata);
  }
}
