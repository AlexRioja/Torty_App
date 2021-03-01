import 'package:cloud_firestore/cloud_firestore.dart';

import 'Tortilla.dart';

class FirebaseInterface {
  getFavs(String email) {
    return FirebaseFirestore.instance
        .collection("tortillas")
        .orderBy("torty_points", descending: true)
        .limit(5)
        .where('users', arrayContains: email)
        .snapshots();
  }

  getTortillas() {}

  pushTortilla(Tortilla t) {
    FirebaseFirestore.instance.collection('tortillas').doc(t.location.id).set({
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
      },
      'users': [t.user.email]
    });
  }

  update(double price, double torty, double quality, String id) {
    FirebaseFirestore.instance
        .collection('tortillas')
        .doc(id)
        .update({'price': price, 'quality': quality, 'torty_points': torty});
  }
}
