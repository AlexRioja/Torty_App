import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:torty_test_1/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rive/rive.dart' as rive;
import 'FirebaseInterface.dart';
import 'Tortilla.dart';
import 'place_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';



class RiveAnim extends StatefulWidget {
  @override
  _RiveAnimState createState() => _RiveAnimState();
}

class _RiveAnimState extends State<RiveAnim> {
  rive.Artboard _riveArtboard;
  rive.RiveAnimationController _controller;

  void _loadRiveFile() async {
    final bytes = await rootBundle.load("assets/rive/crack_egg.riv");
    final file = rive.RiveFile();
    file.import(bytes);
    _riveArtboard = file.mainArtboard;
    _idle();
  }

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  void _crack() {
    _riveArtboard.addController(_controller = rive.SimpleAnimation('Breaking'));
  }

  void _idle() {
    _riveArtboard.addController(rive.SimpleAnimation('Idle'));
  }

  @override
  Widget build(BuildContext context) {
    return _riveArtboard != null
        ? Hero(
            tag: "add_btn",
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amberAccent,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5,
                        offset: Offset(0, 4))
                  ]),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    Future.delayed(const Duration(milliseconds: 950), () {
                      setState(() {
                        _idle();
                        Navigator.of(context).pushNamed('/add');
                      });
                    });
                    _crack();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.add,
                    ),
                    Text(
                      "Añadir",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: rive.Rive(
                        artboard: _riveArtboard,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: Colors.blue,
            height: 70,
          );
  }
}

class CoolAppBar extends StatelessWidget {
  const CoolAppBar({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: size.height * 0.25, //Clave para clipear cosas
          child: Stack(
            children: [
              Container(
                height: size.height * 0.25 - 30, //Clave para clipear cosas
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/backgrounds/test.jpg"),
                        fit: BoxFit.cover),
                    color: Colors.amberAccent,
                    gradient: LinearGradient(
                      colors: [Colors.amberAccent, Colors.amber],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(1, 5),
                          blurRadius: 10)
                    ]),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Bienvenido a Torty!",
                      //TODO Quitar esta mierda y poner un logo o una animación de Rive
                      style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          BoxShadow(
                              blurRadius: 12,
                              color: Colors.black45,
                              offset: Offset(2, 2))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                //Clave para clipear cosas
                bottom: 0,
                width: size.width / 2.5,
                right: size.width / 3.5,
                child: RiveAnim(),
                /*child: FloatingActionButton.extended(
                  heroTag: "add_btn",
                  label: Text("Añadir",
                      style: TextStyle(shadows: [
                        BoxShadow(
                            blurRadius: 8,
                            color: Colors.black45,
                            offset: Offset(2, 2))
                      ], color: Colors.black87,fontSize: 16)),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add');
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.black87,
                  ),
                  backgroundColor: Colors.amberAccent[700],
                  tooltip: "Vamonos a añadir esa tortilla!",
                ),*/
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Body extends StatelessWidget {
  final FirebaseInterface firebase;

  const Body({
    Key key,
    @required this.size,
    this.firebase,
  }) : super(key: key);

  final Size size;

  double cast2double(num input) {
    return input.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount account =
        Provider.of<LogState>(context, listen: false).currentUser;
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/backgrounds/background_home.jpg"),
        fit: BoxFit.cover,
      )),
      child: Column(
        children: [
          CoolAppBar(size: size),
          Padding(
            padding: const EdgeInsets.only(top: 36.0, bottom: 15),
            child: Text(
              "Sus tortillas favoritas!", //TODO ...hacerlo bien...
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
              child: StreamBuilder(
                  stream: firebase.getFavs(account.email),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<DocumentSnapshot> docs = snapshot.data.docs;
                    List<FlipCard_Tortilla> cards = [];
                    for (int i = 0; i < docs.length && i < 5; i++) {
                      Map<String, dynamic> info = docs[i].data();
                      Place place = Place(
                        id: info['id'],
                        url: info['location']['url'],
                        coordinates: info['location']['coordinates'],
                        formatted_address: info['location']['address'],
                        name: info['location']['name'],
                      );
                      Tortilla t = Tortilla(
                        id: info['id'],
                        description: info['desc'],
                        quality: this.cast2double(info['quality']),
                        price: this.cast2double(info['price']),
                        torty_points: this.cast2double(info['torty_points']),
                        location: place,
                      );
                      cards.add(FlipCard_Tortilla(tortilla: t));
                    }
                    return CarouselSlider(
                      //TODO cambiar esto por CarouselSlider.builder
                      items: cards,
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        height: _size.height / 2.2,
                        viewportFraction: 0.82,
                        autoPlay: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlayInterval: Duration(seconds: 12),
                        autoPlayAnimationDuration: Duration(milliseconds: 1800),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class FlipCard_Tortilla extends StatelessWidget {
  final Color first_color, second_color;
  Tortilla tortilla;

  FlipCard_Tortilla(
      {this.first_color = Colors.amber,
      this.second_color = const Color(0xFFFFE57F),
      this.tortilla});

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    BoxShadow _cardShadow = BoxShadow(
        color: Colors.black26,
        blurRadius: 14.0, // soften the shadow
        spreadRadius: 4.0, //extend the shadow
        offset: Offset(
          4.0, // Move to right 10  horizontally
          4.0, // Move to bottom 10 Vertically
        ));
    BorderRadius _cardBorder_first = BorderRadius.only(
      topRight: Radius.circular(65),
      topLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
    );
    BorderRadius _cardBorder_second = BorderRadius.only(
      topLeft: Radius.circular(65),
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: _size.width / 1.6,
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          front: Container(
            decoration: BoxDecoration(
              color: this.first_color,
              image: DecorationImage(
                image: AssetImage("assets/images/tortilladepatatas.jpg"),
                fit: BoxFit.fitHeight,
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.25), BlendMode.dstATop),
              ),
              borderRadius: _cardBorder_first,
              boxShadow: [_cardShadow],
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      tortilla.location.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          wordSpacing: 3),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    tortilla.location.formatted_address,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text('Pincha aquí para saber más!',
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ),
          back: Container(
            decoration: BoxDecoration(
                color: this.second_color,
                borderRadius: _cardBorder_second,
                boxShadow: [_cardShadow]),
            child: Card(
              color: this.second_color,
              shape: RoundedRectangleBorder(
                borderRadius: _cardBorder_second,
              ),
              elevation: 0,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.local_dining,
                      size: 40,
                    ),
                    title: Text(
                      tortilla.location.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Torty: ' + tortilla.torty_points.toString() + ' sobre 5',
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 16, right: 16),
                      child: Text(
                        tortilla.description,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    // this will take space as minimum as posible(to center)
                    children: [
                      FlatButton.icon(
                        textColor: const Color(0xFF6200EE),
                        onPressed: () {
                          //TODO añadir puntuación a la tortilla
                        },
                        label: const Text('Puntuar'),
                        icon: Icon(Icons.star),
                      ),
                      FlatButton.icon(
                        textColor: const Color(0xFF6200EE),
                        onPressed: () {
                          _goToMaps(tortilla.location.url);
                          //TODO Lanzar Maps para que le lleve a la tortilla
                        },
                        label: const Text('Vamos!'),
                        icon: Icon(Icons.location_on),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

_goToMaps(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
