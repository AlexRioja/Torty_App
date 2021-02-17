import 'package:flutter/material.dart';
import 'package:torty_test_1/Components/TestScreen.dart';

import 'CustomWidgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        drawer: Navegacion(),
        body: Body(size: size));
  }
}
