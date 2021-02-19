import 'package:flutter/material.dart';
import 'package:torty_test_1/Components/TestScreen.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'CustomWidgets.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child: Body(size: size)),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.settings),
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: Icon(Icons.construction),
            foregroundColor: Colors.black,
            backgroundColor: Colors.redAccent,
            label: 'En construcción! NO ENTRAR',
            onPressed: () {
              Navigator.of(context).pushNamed('/test');
            },
          ),
        ],
        closedBackgroundColor: Colors.purple,
        openBackgroundColor: Colors.black,
      ),
    );
  }
}
