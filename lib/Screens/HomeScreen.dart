import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torty_test_1/Components/CustomWidgets.dart';
import 'package:torty_test_1/Constants/ColorsConstants.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:torty_test_1/Screens/SearchScreen.dart';
import 'package:torty_test_1/Screens/SettingsScreen.dart';
import '../main.dart';
import 'package:splashscreen/splashscreen.dart' as sp;
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return sp.SplashScreen(
      seconds: 5,
      imageBackground:
          AssetImage('assets/images/backgrounds/background_login.png'),
      loadingText: Text(_getRandomPhrase()),
      title: const Text(
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
  String phrase;
  bool isLogged;
  List<BottomNavyBarItem> items;
  GoogleSignInAccount account;

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    Provider.of<LogState>(context, listen: true).initLog();
    isLogged = Provider.of<LogState>(context, listen: true).isLogged;
    account = Provider.of<LogState>(context, listen: false).currentUser;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>[
        'add',
        'navBar',
        'cards',
        'info',
        'search',
        'map',
        'settings'
      ]);
    });
    items = [
      BottomNavyBarItem(
        icon: const Icon(Icons.home),
        title: const Text('Casita'),
        activeColor: Colors.red,
        textAlign: TextAlign.center,
      ),
      BottomNavyBarItem(
        icon: const Icon(Icons.map),
        title: const Text('Búsqueda'),
        activeColor: Colors.purpleAccent,
        textAlign: TextAlign.center,
      ),
      BottomNavyBarItem(
        icon: const Icon(Icons.settings),
        title: const Text('Ajustes'),
        activeColor: Colors.blue,
        textAlign: TextAlign.center,
      ),
    ];
    isLogged = false;
    phrase = _getPhrase();
    super.initState();
    _pageController = PageController();
    rootBundle.load('assets/rive/torty_curioso.riv').then(
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

  _getPhrase() {
    final List<String> phrases = [
      " camarada",
      " tortiller@",
      " comidista",
      " compatriota",
    ];
    final List<String> times = [
      "Buenos días",
      "Buenas tardes",
      "Apacibles noches"
    ];
    int hour = DateTime.now().hour;
    print(hour);

    var rng = new Random();
    int ran = rng.nextInt(phrases.length);
    if (hour > 4 && hour <= 12) return times[0] + phrases[ran];
    if (hour > 12 && hour <= 19)
      return times[1] + phrases[ran];
    else
      return times[2] + phrases[ran];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return isLogged
        ? Scaffold(
            //body: SafeArea(child: Body(size: size)),
            body: SafeArea(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: <Widget>[
                  Body(
                    size,
                    phrase,
                    account.email,
                  ),
                  SearchScreen(),
                  SettingsScreen(),
                ],
              ),
            ),
            bottomNavigationBar: DescribedFeatureOverlay(
              featureId: "navBar",
              tapTarget: Icon(Icons.home),
              title: Text("Barra de navegación"),
              description: Text(
                  "Pincha en los iconos de la barra de navegación para moverte entre pantallas!."),
              child: BottomNavyBar(
                selectedIndex: _currentIndex,
                showElevation: true,
                backgroundColor: ambersoft,
                itemCornerRadius: 24,
                curve: Curves.easeIn,
                onItemSelected: (index) {
                  setState(() => _currentIndex = index);
                  _pageController.jumpToPage(index);
                },
                items: items,
              ),
            ),
          )
        : notLogged(size: size, riveArtboard: _riveArtboard);
  }
}

class notLogged extends StatelessWidget {
  const notLogged({
    Key key,
    @required this.size,
    @required Artboard riveArtboard,
  })  : _riveArtboard = riveArtboard,
        super(key: key);

  final Size size;
  final Artboard _riveArtboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/backgrounds/background_login.png"),
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
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Text(
                  "Parece que no estás registrado todavía...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                OutlineButton(
                  child: Text("Loggeate con Google",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
