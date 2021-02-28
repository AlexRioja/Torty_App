import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:torty_test_1/Components/ProfileInfo.dart';
import 'package:torty_test_1/Components/SettingsScreen.dart';
import '../FirebaseInterface.dart';
import '../main.dart';
import 'CustomWidgets.dart';
import 'package:splashscreen/splashscreen.dart' as sp;
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

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

class _homeState extends State<home> with TickerProviderStateMixin {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  int _currentIndex = 0;
  PageController _pageController;
  FirebaseInterface f;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    Provider.of<LogState>(context, listen: true).initLog();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    f = FirebaseInterface();
    _pageController = PageController();
    rootBundle.load('assets/rive/torty.riv').then(
      (data) async {
        final file = RiveFile();
        if (file.import(data)) {
          final artboard = file.mainArtboard;
          artboard.addController(_controller = SimpleAnimation('Idle'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Provider.of<LogState>(context, listen: true).isLogged
        ? Scaffold(
            //body: SafeArea(child: Body(size: size)),
            body: SafeArea(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: <Widget>[
                  Body(size: size, firebase: f),
                  Container(
                    color: Colors.red,
                  ),
                  ProfileInfo(),
                  SettingsScreen(),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavyBar(
              selectedIndex: _currentIndex,
              showElevation: true,
              backgroundColor: Colors.white,
              itemCornerRadius: 24,
              curve: Curves.easeIn,
              onItemSelected: (index) {
                setState(() => _currentIndex = index);
                _pageController.jumpToPage(index);
              },
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                  activeColor: Colors.red,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.people),
                  title: Text('Users'),
                  activeColor: Colors.purpleAccent,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.person),
                  title: Text(
                    'Profile',
                  ),
                  activeColor: Colors.pink,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                  activeColor: Colors.blue,
                  textAlign: TextAlign.center,
                ),
              ],
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
                          Provider.of<LogState>(context, listen: false).login();
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
