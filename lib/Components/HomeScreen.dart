import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'CustomWidgets.dart';
import 'package:splashscreen/splashscreen.dart' as sp;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';

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

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool _isLoggedIn = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err) {
      print(err);
    }
  }

  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  Artboard _riveArtboard;
  RiveAnimationController _controller;
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _isLoggedIn=true;
      }});
      _googleSignIn.signInSilently();

      rootBundle.load('assets/rive/torty.riv').then(
      (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('Idle'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _isLoggedIn
        ? Scaffold(
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
          )
        : Scaffold(
            body: SafeArea(
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/backgrounds/background.png"),
                      fit: BoxFit.cover)),
              child: Center(
                child: ListView(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 350,
                        child: Rive(
                          artboard: _riveArtboard,
                        ),
                      ),
                      Text(
                        "Vaya!",
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 50),
                      Text(
                        "Parece que no estás registrado todavía...",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      OutlineButton(
                        child: Text("Login with Google",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        onPressed: () {
                          _login();
                        },
                        shape: StadiumBorder(),
                        color: Colors.red,
                        textColor: Colors.red,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ));
  }
}
