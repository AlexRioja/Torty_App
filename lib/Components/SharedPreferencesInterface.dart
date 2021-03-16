import 'package:shared_preferences/shared_preferences.dart';

setEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int res = _checkNumber(prefs);
  if (res == 0)
    return false;
  else
    await prefs.setString("friend$res", email);
  return true;
}

deleteFriends() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<List<String>> getEmails() async {
  List<String> ret = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int res = _checkNumber(prefs);
  if (res == 0) res = 6;
  if (res == 1) return ret;
  for (int i = 1; i < res; i++) {
    ret.add(prefs.getString("friend$i"));
  }
  return ret;
}

_checkNumber(SharedPreferences prefs) {
  String res1 = prefs.getString("friend1") ?? "";
  String res2 = prefs.getString("friend2") ?? "";
  String res3 = prefs.getString("friend3") ?? "";
  String res4 = prefs.getString("friend4") ?? "";
  String res5 = prefs.getString("friend5") ?? "";
  if (res1 == "") {
    return 1;
  }
  if (res2 == "") {
    return 2;
  }
  if (res3 == "") {
    return 3;
  }
  if (res4 == "") {
    return 4;
  }
  if (res5 == "") {
    return 5;
  }
  return 0;
}
