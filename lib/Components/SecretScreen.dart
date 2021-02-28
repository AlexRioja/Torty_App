import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:torty_test_1/slowly_moving.dart';

final r = new Random();

class SecretScreen extends StatefulWidget {
  @override
  _SecretScreenState createState() => _SecretScreenState();
}

class _SecretScreenState extends State<SecretScreen> {
  final List<Moving> list = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.amberAccent),
          child: Center(
              child:
                  Text("Esto es el secreto", style: TextStyle(fontSize: 45))),
          height: 50,
          width: 370),
      height: 50,
      width: 370,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.red),
          child: Center(
              child: Text("Pincha en 'Buy me a coffe'...",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))),
          height: 50,
          width: 370),
      height: 50,
      width: 370,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.red),
          child: Center(
              child: Text("Pincha en 'Buy me a coffe'...",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))),
          height: 50,
          width: 250),
      height: 50,
      width: 250,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.purpleAccent),
          child: Center(
              child: Text("¿Qué esperabas?", style: TextStyle(fontSize: 25))),
          height: 50,
          width: 250),
      height: 50,
      width: 250,
    ));

    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrangeAccent),
          child:
              Center(child: Text("Págame...", style: TextStyle(fontSize: 14))),
          height: 30,
          width: 100),
      height: 30,
      width: 100,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrangeAccent),
          child: Center(
              child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 12),
                  height: 40,
                  child: Text(
                    "Puedes ayudarme pagándome un café!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              Container(
                height: 50,
                child: InkWell(
                  child: SvgPicture.asset(
                    "assets/images/logo_buyme.svg",
                    semanticsLabel: 'Ayúdame con tu donación!',
                  ),
                  onTap: () {
                    _goToBuyMeACoffe();
                  },
                ),
              ),
            ],
          )),
          height: 100,
          width: 380),
      height: 100,
      width: 380,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent),
          child: Image(
            image: AssetImage("assets/images/tortilla_1.png"),
          ),
          height: 70,
          width: 70),
      height: 70,
      width: 70,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent),
          child: Image(
            image: AssetImage("assets/images/tortilla_1.png"),
          ),
          height: 50,
          width: 50),
      height: 50,
      width: 50,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent),
          child: Image(
            image: AssetImage("assets/images/tortilla_2.png"),
          ),
          height: 50,
          width: 50),
      height: 50,
      width: 50,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent),
          child: Image(
            image: AssetImage("assets/images/tortilla_2.png"),
          ),
          height: 90,
          width: 90),
      height: 90,
      width: 90,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent),
          child: Image(
            image: AssetImage("assets/images/tortilla_1.png"),
          ),
          height: 70,
          width: 70),
      height: 70,
      width: 70,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent),
          child: Image(
            image: AssetImage("assets/images/tortilla_1.png"),
          ),
          height: 50,
          width: 50),
      height: 50,
      width: 50,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent),
          child: Image(
            image: AssetImage("assets/images/tortilla_2.png"),
          ),
          height: 50,
          width: 50),
      height: 50,
      width: 50,
    ));
    list.add(Moving(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent),
          child: Image(
            image: AssetImage("assets/images/tortilla_2.png"),
          ),
          height: 90,
          width: 90),
      height: 90,
      width: 90,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SlowlyMovingWidgetsField(
          list: list,
          bd: BoxDecoration(image:DecorationImage(
              image: AssetImage('assets/images/backgrounds/test_2.jpg'),
              fit: BoxFit.cover)),
        ),
      ),
    );
  }
}

_goToBuyMeACoffe() async {
  if (await canLaunch("https://www.buymeacoffee.com/alexrioja")) {
    await launch("https://www.buymeacoffee.com/alexrioja");
  } else {
    throw 'Could not launch url';
  }
}
