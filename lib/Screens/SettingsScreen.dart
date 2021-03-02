import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.settings),
        title: Text(
          "Ajustes",
          style: TextStyle(color: Colors.black, wordSpacing: 3),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.amberAccent,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/backgrounds/background_search_2.png"),
                fit: BoxFit.cover)),
        child: Center(
          child: FlatButton(
            onPressed: () {
              showLicensePage(
                context: context,
                // applicationIcon: Image.asset(name)
                // applicationName: "App Name"
                // Other parameters
              );
            },
            child: Text('Show Licenses'),
          ),
        ),
      ),
    );
  }
}
