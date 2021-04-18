import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:torty_test_1/Screens/ChatScreen.dart';
import 'package:torty_test_1/Screens/MapScreen.dart';
import 'Screens/AddScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/SecretScreen.dart';
import 'Screens/SettingsScreen.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //inits the firebase service
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(Torty_App());
}

class Torty_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color main = Colors.amber;
    return FeatureDiscovery(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: ThemeData(primarySwatch: Colors.lime,fontFamily: "",brightness: Brightness.dark),
        theme: ThemeData(
            fontFamily: "Nunito",
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primarySwatch: Colors.purple),
        title: 'Torty',
        routes: {
          '/': (context) => HomeScreen(),
          '/add': (context) => AddScreen(),
          '/settings': (context) => SettingsScreen(),
          '/secret': (context) => SecretScreen(),
          '/map': (context) => MapScreen(),
          '/chat': (context) => ChatScreen()
        },
      ),
    );
  }
}

//TODO Echar un ojo a Slimy_card https://pub.dev/packages/slimy_card
//TODO Echar un ojo a bottom_navy_bar https://pub.dev/packages/bottom_navy_bar. Cambiar por todo la navegación?
//TODO O a esta https://github.com/tunitowen/fancy_bottom_navigation
