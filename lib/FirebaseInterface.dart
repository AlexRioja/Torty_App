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
      'id': t.location.id,
      'desc': t.description,
      'price': t.price,
      'quality': t.quality,
      'torty_points': t.torty_points,
      'location': {
        'name': t.location.name,
        'address': t.location.formatted_address,
        'url': t.location.url,
        'coordinates': t.location.coordinates
      }
    });
  }
}
