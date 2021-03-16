import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:torty_test_1/Components/ModifyBottomSheet.dart';
import 'package:torty_test_1/Constants/ColorsConstants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FirebaseInterface.dart';
import 'Tortilla.dart';
import 'place_service.dart';
import 'package:rive/rive.dart' as rive;
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//TODO Crear un archivo de colores a parte, donde sean constantes estáticas a ver si ayuda al rendimiento

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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    _riveArtboard.addController(_controller = rive.SimpleAnimation('Idle'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amberAccent,
          boxShadow: [
            BoxShadow(
                color: Colors.black54, blurRadius: 5, offset: Offset(0, 4))
          ]),
      child: DescribedFeatureOverlay(
        contentLocation: ContentLocation.below,
        overflowMode: OverflowMode.extendBackground,
        tapTarget: Icon(Icons.add),
        backgroundColor: Colors.amberAccent[100],
        textColor: Colors.black,
        featureId: 'add',
        title: Text("Añadir Tortillas"),
        description: Text(
            "Pincha aquí si te acabas de comer un buen pintxo y quieres guardarlo!"),
        child: TextButton(
          onPressed: () {
            _crack();
            Future.delayed(const Duration(milliseconds: 950), () {
              Navigator.of(context).pushNamed('/add').then((value) => _idle());
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.add,
                color: Colors.black,
              ),
              const Text(
                "Añadir",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Expanded(
                child: rive.Rive(
                  artboard: _riveArtboard,
                ),
              ),
            ],
          ),
        ),
      ),
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
                decoration: const BoxDecoration(
                    image: const DecorationImage(
                        image: const AssetImage(
                            "assets/images/backgrounds/test.jpg"),
                        fit: BoxFit.cover),
                    color: Colors.amberAccent,
                    gradient: const LinearGradient(
                      colors: [Colors.amberAccent, Colors.amber],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: const Radius.circular(60),
                      bottomRight: const Radius.circular(60),
                    ),
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black54,
                          offset: Offset(1, 5),
                          blurRadius: 10)
                    ]),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: InkWell(
                      child: Text(
                        "Torty",
                        style: TextStyle(
                            fontFamily: 'Lobster',
                            fontSize: 80,
                            shadows: [
                              BoxShadow(
                                  color: amber700,
                                  blurRadius: 20,
                                  offset: Offset(10, 10))
                            ]),
                      ),
                      onTap: (){
                          Navigator.of(context).pushNamed("/chat");
                      },
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
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Body extends StatelessWidget {
  Body(this.size, this.phrase, this.email);

  final Size size;
  final String phrase, email;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/backgrounds/background_search.png"),
        fit: BoxFit.cover,
      )),
      child: Column(
        children: [
          CoolAppBar(size: size),
          Padding(
            padding: const EdgeInsets.only(top: 36.0, bottom: 15),
            child: Text(
              phrase,
              style: const TextStyle(
                  fontFamily: "Lobster",
                  fontSize: 32,
                  shadows: [
                    const BoxShadow(
                        color: amber700, blurRadius: 10, offset: Offset(10, 10))
                  ]),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
              child: DescribedFeatureOverlay(
                child: cards(email, _size),
                backgroundColor: Colors.lightGreen,
                textColor: Colors.black,
                targetColor: Colors.yellow,
                contentLocation: ContentLocation.below,
                overflowMode: OverflowMode.extendBackground,
                featureId: 'cards',
                tapTarget: Icon(Icons.local_pizza),
                title: Text("Tortillas mejor valoradas"),
                description:
                    Text("Aquí aparecerán tus 5 tortillas mejor valoradas!\n"
                        "Pincha en ellas para obtener más información!"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class cards extends StatelessWidget {
  final String email;
  final Size _size;
  Stream<QuerySnapshot> s;

  cards(this.email, this._size) {
    s = getFavs(email);
  }

  double cast2double(num input) {
    return input.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: s,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data.docs;
          List<FlipCard_Tortilla> cards = [];
          for (int i = 0; i < docs.length; i++) {
            Map<String, dynamic> info = docs[i].data();
            Place place = Place(
              id: info['id'],
              url: info['location']['url'],
              coordinates_lat: info['location']['coordinates_lat'],
              coordinates_lon: info['location']['coordinates_lon'],
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
              amount: this.cast2double(info['amount'])
            );
            cards.add(FlipCard_Tortilla(tortilla: t));
          }
          return CarouselSlider(
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
        });
  }
}

class FlipCard_Tortilla extends StatelessWidget {
  final Color first_color, second_color;
  Tortilla tortilla;

  FlipCard_Tortilla(
      {this.first_color = Colors.amber,
      this.second_color = const Color(0xFFFFE57F),
      this.tortilla});

  static const BoxShadow _cardShadow = const BoxShadow(
      color: Colors.black26,
      blurRadius: 14.0, // soften the shadow
      spreadRadius: 4.0, //extend the shadow
      offset: Offset(
        4.0, // Move to right 10  horizontally
        4.0, // Move to bottom 10 Vertically
      ));
  static const BorderRadius _cardBorder_first = const BorderRadius.only(
    topRight: Radius.circular(65),
    topLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  );
  static const BorderRadius _cardBorder_second = const BorderRadius.only(
    topLeft: Radius.circular(65),
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: _size.width / 1.6,
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          front: Front_flipCard(
              first_color: first_color,
              cardBorder_first: _cardBorder_first,
              cardShadow: _cardShadow,
              tortilla: tortilla),
          back: Back_flipCard(
              second_color: second_color,
              cardBorder_second: _cardBorder_second,
              cardShadow: _cardShadow,
              tortilla: tortilla),
        ),
      ),
    );
  }
}

class Back_flipCard extends StatelessWidget {
  const Back_flipCard({
    Key key,
    @required this.second_color,
    @required BorderRadius cardBorder_second,
    @required BoxShadow cardShadow,
    @required this.tortilla,
  })  : _cardBorder_second = cardBorder_second,
        _cardShadow = cardShadow,
        super(key: key);

  final Color second_color;
  final BorderRadius _cardBorder_second;
  final BoxShadow _cardShadow;
  final Tortilla tortilla;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: _cardBorder_second, boxShadow: [_cardShadow]),
      child: Card(
        color: this.second_color,
        shape: RoundedRectangleBorder(
          borderRadius: _cardBorder_second,
        ),
        elevation: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(
                  Icons.local_pizza_outlined,
                  size: 40,
                ),
                title: Text(
                  tortilla.location.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    const Text("Torty:  ", style: TextStyle(fontSize: 16),),
                    RatingBarIndicator(
                      rating: tortilla.torty_points,
                      itemBuilder: (context, index) => Icon(
                        Icons.whatshot_outlined,
                        color: Colors.amber[600],
                      ),
                      itemCount: 5,
                      itemSize: 18.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 22, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Precio: ${tortilla.price} €",
                      style: const TextStyle(color: blackwopa06),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Sabrosura: ",
                          style: TextStyle(color: blackwopa06),
                        ),
                        RatingBarIndicator(
                          rating: tortilla.quality,
                          itemBuilder: (context, index) => Icon(
                            Icons.restaurant_menu,
                            color: Colors.amber[600],
                          ),
                          itemCount: 5,
                          itemSize: 18.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),Row(
                      children: [
                        const Text(
                          "Cantidad: ",
                          style: TextStyle(color: blackwopa06),
                        ),
                        RatingBarIndicator(
                          rating: tortilla.amount,
                          itemBuilder: (context, index) => Icon(
                            Icons.free_breakfast,
                            color: Colors.amber[600],
                          ),
                          itemCount: 5,
                          itemSize: 18.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                    Text(
                      "Descripción: ${tortilla.description}",
                      style: const TextStyle(color: blackwopa06),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            ButtonBar_Back_flipCard(tortilla: tortilla),
          ],
        ),
      ),
    );
  }
}


class ButtonBar_Back_flipCard extends StatelessWidget {
  const ButtonBar_Back_flipCard({
    Key key,
    @required this.tortilla,
  }) : super(key: key);

  final Tortilla tortilla;

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      // this will take space as minimum as posible(to center)
      children: [
        FlatButton.icon(
          textColor: const Color(0xFF6200EE),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              elevation: 20,
              context: context,
              builder: (context) => SingleChildScrollView(
                child: ModifyBottomSheet(
                  id: tortilla.id,
                  t_p: tortilla.torty_points,
                  q_p: tortilla.quality,
                  p: tortilla.price,
                  name: tortilla.location.name,
                  amount: tortilla.amount,
                ),
              ),
            );
          },
          label: const Text('Cambiar'),
          icon: const Icon(
            Icons.update_rounded,
            size: 24,
          ),
        ),
        FlatButton.icon(
          textColor: const Color(0xFF6200EE),
          onPressed: () {
            _goToMaps(tortilla.location.url);
          },
          label: const Text('Vamos!'),
          icon: const Icon(
            Icons.location_on,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class Front_flipCard extends StatelessWidget {
  const Front_flipCard({
    Key key,
    @required this.first_color,
    @required BorderRadius cardBorder_first,
    @required BoxShadow cardShadow,
    @required this.tortilla,
  })  : _cardBorder_first = cardBorder_first,
        _cardShadow = cardShadow,
        super(key: key);

  final Color first_color;
  final BorderRadius _cardBorder_first;
  final BoxShadow _cardShadow;
  final Tortilla tortilla;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.first_color,
        image: DecorationImage(
          image: AssetImage("assets/images/tortilladepatatas.jpg"),
          fit: BoxFit.fitHeight,
          colorFilter: const ColorFilter.mode(whitewopa025, BlendMode.dstATop),
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
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 30, wordSpacing: 3),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              tortilla.location.formatted_address,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 12,
            ),
            const Text('Pincha aquí para saber más!',
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
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

class StarRating extends StatelessWidget {
  final double rating;
  final Color color;

  const StarRating({this.rating = .0, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(
        Icons.star,
        color: blackwopa05,
        size: 18,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = const Icon(
        Icons.star_half,
        color: amber600,
        size: 18,
      );
    } else {
      icon = const Icon(
        Icons.star,
        color: amber600,
        size: 18,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        children: List.generate(5, (index) => buildStar(context, index)));
  }
}
