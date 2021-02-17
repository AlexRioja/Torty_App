import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../Tortilla.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
                height: size.height * 0.25 - 20, //Clave para clipear cosas
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/backgrounds/test.jpg"),
                    fit: BoxFit.cover
                  ),
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
                      offset: Offset(1,5),
                      blurRadius: 10
                    )
                  ]
                ),
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
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: "btn1",
                      label: Text("Añadir",
                          style: TextStyle(shadows: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black45,
                                offset: Offset(2, 2))
                          ], color: Colors.black87)),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/add');
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.black87,
                      ),
                      backgroundColor: Colors.amberAccent[700],
                    ),
                    FloatingActionButton.extended(
                      heroTag: "btn2",
                      label: Text("Consultar",
                          style: TextStyle(shadows: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black45,
                                offset: Offset(2, 2))
                          ], color: Colors.black87)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Colors.black87,
                      ),
                      backgroundColor: Colors.amberAccent[700],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Navegacion extends StatelessWidget {
  //TODO ¿Quitarlo?
  const Navegacion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text("gene.brooks@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile_example.jpg"),
            ),
            accountName: Text("Gene Brooks"),
            onDetailsPressed: () {
              //TODO Implementar una pantalla o un alertDialog con más info del perfil
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Añadir una súpertortilla!"),
            onTap: () {
              Navigator.of(context).pushNamed('/add');
            },
          ),
          ListTile(
            leading: Icon(Icons.dangerous),
            title: Text("Test Screen"),
            onTap: () {
              Navigator.of(context).pushNamed('/test');
            },
          )
        ],
      ),
    );
  }
}

class Body extends StatelessWidget {
  //TODO Llamar a una función asíncrona para cargar datos desde red!(firebase)
  const Body({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(image: DecorationImage(
        image: AssetImage("assets/images/backgrounds/test_2.jpg"),
        fit: BoxFit.cover,
      )),
      child: Column(
        children: [
          CoolAppBar(size: size),
          Padding(
            padding: const EdgeInsets.only(top: 36.0, bottom: 15),
            child: Text(
              "Sus tortillas favoritas!", //TODO ...hacerlo bien...
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
            child: CarouselSlider(
              items: [FlipCard_Tortilla(), FlipCard_Tortilla()],
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: _size.height / 2,
                viewportFraction: 0.82,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: Duration(seconds: 12),
                autoPlayAnimationDuration: Duration(milliseconds: 1800),
              ),
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
    if (tortilla == null) {
      tortilla = Tortilla(
          name: "TestTilla",
          description:
              "Esta tortilla está increible!, De verdad no te la puedes perder",
          price: 3.0,
          quality: 2.5,
          torty_points: 3.5);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: _size.width / 1.6,
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          front: Container(
            decoration: BoxDecoration(
              color: this.first_color,
              borderRadius: _cardBorder_first,
              boxShadow: [_cardShadow],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(tortilla.name,
                    style: Theme.of(context).textTheme.headline5),
                Text('Pincha aquí para saber más!',
                    style: Theme.of(context).textTheme.bodyText2),
              ],
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
                      tortilla.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Torty: ' + tortilla.torty_points.toString(),
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
                          //TODO Lanzar Maps para que le lleve a la tortilla
                        },
                        label: const Text('Llévame!'),
                        icon: Icon(Icons.gps_fixed),
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
