import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomWidgets.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.bottomRight,
          child: Icon(
            Icons.menu_rounded,
            size: 40,
          ),
        ),
        elevation: 0,
      ),
      body: CoolAppBar(size: size),
    );
  }
}
