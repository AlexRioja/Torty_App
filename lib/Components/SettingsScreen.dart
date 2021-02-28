import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}