import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tortilla.dart';
import 'package:google_sign_in/google_sign_in.dart';

checkUser(String email) async {
  var data = await FirebaseFirestore.instance
      .collection("users")
      .where('email', isEqualTo: email.toLowerCase())
      .get();
  return data.size;
}

logUser(GoogleSignInAccount gAccount) async{
  FirebaseFirestore.instance
      .collection('users')
      .doc(gAccount.email)
      .set({'email': gAccount.email, 'name': gAccount.displayName});
}

///Get 5 best tortillas for current user
getFavs(String email){
  return FirebaseFirestore.instance
      .collection("tortillas")
      .orderBy("torty_points", descending: true)
      .limit(5)
      .where('users', arrayContains: email)
      .snapshots();
}

///Get All tortillas for the user
Future<List<QueryDocumentSnapshot>> getAllTortillas(String email) async {
  var data = await FirebaseFirestore.instance
      .collection("tortillas")
      .orderBy("torty_points", descending: true)
      .where('users', arrayContains: email)
      .get();
  return data.docs;
}
///Get All tortillas for the user
Future<List<QueryDocumentSnapshot>> getAllTortillasFriend(String email,String friend) async {
  var data = await FirebaseFirestore.instance
      .collection("tortillas")
      .orderBy("torty_points", descending: true)
      .where('users', arrayContainsAny: [email,friend])
      .get();
  return data.docs;
}///Get All tortillas for the user
Future<List<QueryDocumentSnapshot>> getAllTortillasFriends(String email,List<String> friends) async {
  List<String> temp=friends;
  temp.add(email);
  var data = await FirebaseFirestore.instance
      .collection("tortillas")
      .orderBy("torty_points", descending: true)
      .where('users', arrayContainsAny: temp)
      .get();
  temp.remove(email);
  return data.docs;
}

pushTortilla(Tortilla t) async {
  FirebaseFirestore.instance
      .collection('tortillas')
      .doc(t.location.id + '_' + t.user.email)
      .set({
    'id': t.location.id,
    'desc': t.description,
    'price': t.price,
    'quality': t.quality,
    'amount':t.amount,
    'torty_points': t.torty_points,
    'location': {
      'name': t.location.name,
      'address': t.location.formatted_address,
      'url': t.location.url,
      'coordinates_lat': t.location.coordinates_lat,
      'coordinates_lon': t.location.coordinates_lon
    },
    'users': [t.user.email]
  });
}

delete(String id) async {
  FirebaseFirestore.instance.collection('tortillas').doc(id).delete();
}

update(double price, double torty, double quality,double amount,  String id) {
  FirebaseFirestore.instance
      .collection('tortillas')
      .doc(id)
      .update({'price': price, 'quality': quality,'amount':amount, 'torty_points': torty});
}
