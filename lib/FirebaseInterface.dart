import 'package:torty_test_1/Tortilla.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseInterface {
  getFavs() {
    return FirebaseFirestore.instance
        .collection("tortillas")
        .orderBy("torty_points", descending: true)
        .limit(5)
        .snapshots();
  }

  getTortillas() {}

  pushTortilla(Tortilla t) {
    FirebaseFirestore.instance.collection('tortillas').add({
      'name': t.name,
      'desc': t.description,
      'price': t.price,
      'quality': t.quality,
      'torty_points': t.torty_points,
      'location': t.location,
      'address':t.address,
      'id':t.id
    });
  }
}
