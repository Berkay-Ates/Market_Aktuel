import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../provider/will_be_required.dart';

class FirebaseMyApi {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>>? getStreamCategoryData(BuildContext context) {
    Stream<QuerySnapshot<Object?>> snapshot = firestore
        .collection(Provider.of<WillBeRequired>(context).getCategory().name)
        .snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot<Object?>>? getStreamMainCategoryData(
      BuildContext context) {
    Stream<QuerySnapshot<Object?>> snapshot = firestore
        .collection(
            Provider.of<WillBeRequired>(context).getMainPageCategory().name)
        .snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot<Object?>>? getStreamBrandData(
      BuildContext context, String collectionName) {
    Stream<QuerySnapshot<Object?>> snapshot =
        firestore.collection(collectionName).snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot<Object?>>? getStreamBrandCatalogData(
      BuildContext context, String collectionName) {
    Stream<QuerySnapshot<Object?>>? snapshot =
        firestore.collection(collectionName).snapshots();
    return snapshot;
  }
}
