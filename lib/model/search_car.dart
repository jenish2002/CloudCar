import 'package:cloud_firestore/cloud_firestore.dart';

class SearchCar {
  searchByName(String searchValue) {
    return FirebaseFirestore.instance
        .collection('cars')
        .where('searchKey',
          isEqualTo: searchValue.substring(0, 1).toUpperCase()
        )
        .get();
  }
}