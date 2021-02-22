import 'dart:math';

import 'package:flutter/material.dart';
import 'package:torty_test_1/Components/TestScreen.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'CustomWidgets.dart';
import 'package:splashscreen/splashscreen.dart' as sp;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return sp.SplashScreen(
      seconds: 5,
      imageBackground: AssetImage('assets/images/backgrounds/background.png'),
      loadingText: Text(_getRandomPhrase()),
      title: Text(
        "Torty",
        style: TextStyle(fontFamily: 'Lobster', fontSize: 140, shadows: [
          BoxShadow(
              color: Colors.amberAccent, blurRadius: 50, offset: Offset(10, 10))
        ]),
      ),
      navigateAfterSeconds: home(),
    );
  }

  String _getRandomPhrase() {
    List<String> rndm_phrase = [
      "Rompiendo algunos huevos...",
      "Batiendo los huevos...",
      "Preparando tortilla...",
      "Buscando plato para dar la vuelta...",
      "Calentando el aceite...",
      "Pelando las patatas...",
      "Añadiendo sal...",
      "La tortilla siempre con cebolla",
      "Pintxo pintxo, pintxo de tortilla...",
      "Ini tirtilli sin cibilli pir fivir..."
    ];
    var rng = new Random();
    return rndm_phrase[rng.nextInt(rndm_phrase.length)];
  }
}

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(child: Body(size: size)),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.person_sharp),
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: Icon(Icons.person_pin_rounded),
            foregroundColor: Colors.black,
            backgroundColor: Colors.purpleAccent,
            label: 'Mi cuenta tortillera',
            onPressed: () {
              Navigator.of(context).pushNamed("/userInfo");
            },
          ),
        ],
        closedBackgroundColor: Colors.purple,
        openBackgroundColor: Colors.black,
      ),
    );
  }
}
