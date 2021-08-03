import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_products_upload/models/inspection_model.dart';
import 'package:etar_products_upload/models/product_model.dart';
import 'package:flutter/foundation.dart';


class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  String company;

  //**********************************************

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs
            .map(
              (snapshot) => builder(snapshot.data()),
        )
            .toList());
  }

  Stream<List<T>> filteredProductStream<T>({
    @required String path,
    @required String description,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = FirebaseFirestore.instance.collection(path)
        .where('description', isEqualTo: description);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs
            .map(
              (snapshot) => builder(snapshot.data()),
        )
            .toList());
  }



  Stream<List<T>> orderedOpStreamStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
    @required String productId
  }) {
    final reference = FirebaseFirestore.instance.collection(path).orderBy('date')
        .where('productID', isEqualTo: productId);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs
            .map(
              (snapshot) => builder(snapshot.data()),
        )
            .toList());
  }

  Stream<List<T>> dateFilteredEventStream<T>({
    @required String path,
    @required String date,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = FirebaseFirestore.instance.collection(path)
        .where('date', isEqualTo: date);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs
            .map(
              (snapshot) => builder(snapshot.data()),
        )
            .toList());
  }

  Stream<List<T>> companyIdCounterStream<T>({
    @required String company,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = FirebaseFirestore.instance.collection('counter')
        .where('company', isEqualTo: company);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs
            .map(
              (snapshot) => builder(snapshot.data()),
        )
            .toList());
  }
  Future<InspectionModel> retrieveEventFromNr(company, nr, event) async {
    final ref = FirebaseFirestore.instance.collection('companies/$company/$event');
    return await ref.doc(nr).get().then((value) =>
        InspectionModel.fromMap(value.data())
    );
  }
  Future<ProductModel> retrieveProductFromId(company, productId) async {
    final ref = FirebaseFirestore.instance.collection('companies/$company/products');
    return await ref.doc(productId).get().then((value) =>
        ProductModel.fromMap(value.data())
    );
  }

}
