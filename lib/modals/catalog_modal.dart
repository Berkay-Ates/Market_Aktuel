import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogModal {
  String? name;
  String? image;
  Timestamp? startingDate;
  Timestamp? expiringDate;
  String? catalogPdfURL;

  CatalogModal({this.name, this.image, this.startingDate, this.expiringDate,this.catalogPdfURL});
}
