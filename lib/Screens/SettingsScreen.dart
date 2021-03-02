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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              FlatButton(
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationName: "Torty",
                      applicationIcon: Icon(Icons.local_pizza),
                      applicationVersion: "0.0.1",
                      applicationLegalese:
                          "Alejandro Martínez de Ternero Ruiz.",
                      children: <Widget>[
                        Text("Con todo el cariño del mundo hacia vosotros :)"),
                      ]);
                },
                child: Text('Sobre la aplicación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
