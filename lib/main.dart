import 'package:flutter/material.dart';
import 'package:torty_test_1/Components/TestScreen.dart';
import 'Components/HomeScreen.dart';
import 'Components/AddScreen.dart';
import 'Tortilla.dart';
import 'package:google_fonts/google_fonts.dart';


void main() => runApp(Torty_App());

class Torty_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color main=Colors.amber;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(primarySwatch: Colors.lime,fontFamily: "",brightness: Brightness.dark),
      theme: ThemeData(fontFamily: "Nunito"),
      //TODO Big todo, cambiar todo el tema a dark ThemeData.dark() y hacer que todo cuadre o poner color amarillo clarito a todo
      title: 'Torty',
      routes: {
        '/': (context) => HomeScreen(),
        '/add': (context) => AddScreen(),
        '/test': (context) => TestScreen(),
      },
    );
  }
}

//TODO Echar un ojo a Slimy_card https://pub.dev/packages/slimy_card
