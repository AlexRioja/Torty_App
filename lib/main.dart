import 'package:flutter/material.dart';
import 'package:torty_test_1/Components/ProfileInfo.dart';
import 'package:torty_test_1/Components/SecretScreen.dart';
import 'Components/AddScreen/AddScreen.dart';
import 'Components/HomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //inits the firebase service
  runApp(Torty_App());
}

class LogState with ChangeNotifier {
  bool _isLogged = false;
  GoogleSignInAccount _currentUser;

  GoogleSignInAccount get currentUser => _currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  bool get isLogged => _isLogged;

  initLog() async {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
      if (_currentUser != null) {
        _isLogged = true;
      }
    });
    await _googleSignIn.signInSilently();
    notifyListeners();
  }

  set isLogged(bool value) {
    _isLogged = value;
    notifyListeners();
  }

  login() async {
    try {
      await _googleSignIn.signIn();
      _isLogged = true;
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  logout() {
    _googleSignIn.signOut();
    _isLogged = false;
  }
}

class Torty_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color main = Colors.amber;
    return ChangeNotifierProvider<LogState>(
      create: (_) => LogState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: ThemeData(primarySwatch: Colors.lime,fontFamily: "",brightness: Brightness.dark),
        theme: ThemeData(
          fontFamily: "Nunito",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //TODO Big todo, cambiar todo el tema a dark ThemeData.dark() y hacer que todo cuadre o poner color amarillo clarito a todo
        title: 'Torty',
        routes: {
          '/': (context) => HomeScreen(),
          '/add': (context) => AddScreen(),
          '/userInfo': (context) => ProfileInfo(),
          '/secret':(context)=>SecretScreen()
        },
      ),
    );
  }
}

//TODO Echar un ojo a Slimy_card https://pub.dev/packages/slimy_card
//TODO Echar un ojo a bottom_navy_bar https://pub.dev/packages/bottom_navy_bar. Cambiar por todo la navegación?
//TODO O a esta https://github.com/tunitowen/fancy_bottom_navigation
