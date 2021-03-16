import 'dart:async';
import 'package:torty_test_1/Components/FirebaseInterface.dart';
import 'package:torty_test_1/Components/SharedPreferencesInterface.dart';
import 'package:torty_test_1/Components/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount account =
        Provider.of<LogState>(context, listen: false).currentUser;
    return Scaffold(
      body: Mapa(account),
      appBar: AppBar(
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  size: 26.0,
                ),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        backgroundColor: Colors.amberAccent[100],
                        title: Text(
                          'Pantalla de Búsqueda por mapa',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                            'Aquí encontrarás las ubicaciones de las mejores tortillas!\n'
                            'Los iconos de color más fuerte tienen más puntos!\n'
                            'En la esquina superior izquierda podrás seleccionar a tus amigos para ver sus tortillas!'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Dismiss alert dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                tooltip: "Información acerca de esta pantalla",
              ))
        ],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Navegando las tortillas",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
    );
  }
}

class Mapa extends StatefulWidget {
  GoogleSignInAccount account;

  Mapa(this.account);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  final Map<String, Marker> _markers = {};
  List _allResults = [];
  List<String> friends;
  String friend;
  Map<String, double> friends_colors = {};
  List<double> colors;
  Map<String, Color> friends_colors_bottom = {};
  List<Color> colors_bottom;

  @override
  void initState() {
    friend = null;

    getEmails().then((value) {
      colors = [
        BitmapDescriptor.hueRed,
        BitmapDescriptor.hueBlue,
        BitmapDescriptor.hueGreen,
        BitmapDescriptor.hueOrange,
        BitmapDescriptor.hueYellow,
      ];
      colors_bottom = [
        Colors.redAccent[100],
        Color(0xFF63AEFF),
        Colors.lightGreen[100],
        Colors.orangeAccent[100],
        Colors.yellow,
      ];
      setState(() {
        friends = value;
        int i = 0;
        if (friends != null && friends.length > 0) {
          for (final f in friends) {
            friends_colors[f] = colors[i];
            friends_colors_bottom[f] = colors_bottom[i];
            i++;
          }
        }
        friends.add("Ver todas!");
      });
    });
    determinePosition().then((value) {
      setState(() {
        _location = CameraPosition(
            target: LatLng(value.latitude, value.longitude), zoom: 14.8);
      });
    });
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _location;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _location == null
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Cargando mapa...",
                      style: TextStyle(fontSize: 35),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            )
          : Stack(children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _location,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  if (friend != null) {
                  } else {
                    getAllTortillas(widget.account.email).then((value) {
                      setState(() {
                        _allResults = value;
                        for (final v in value) {
                          double opacity = v['torty_points'] / 10 + 0.5;
                          final marker = Marker(
                            markerId: MarkerId(v['location']['name']),
                            position: LatLng(
                                double.parse(v['location']['coordinates_lat']),
                                double.parse(v['location']['coordinates_lon'])),
                            infoWindow: InfoWindow(
                              title: v['location']['name'],
                            ),
                            alpha: opacity,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet,
                            ),
                          );
                          _markers[v['location']['name']] = marker;
                        }
                      });
                    });
                  }
                },
                myLocationEnabled: true,
                compassEnabled: true,
                zoomControlsEnabled: false,
                markers: _markers.values.toSet(),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        for (final r in _allResults)
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: _boxes(
                                  r['location']['name'],
                                  double.parse(
                                      r['location']['coordinates_lat']),
                                  double.parse(
                                      r['location']['coordinates_lon']),
                                  r['price'],
                                  r['quality'],
                                  r['torty_points'],
                                  r['amount'],
                                  r['location']['url'],
                                  friends_colors_bottom
                                          .containsKey(r['users'][0])
                                      ? friends_colors_bottom[r['users'][0]]
                                      : Colors.deepPurpleAccent[100]))
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        icon: Icon(Icons.people_alt_outlined),
                        hint: Text("Amigos "),
                        items: friends.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        value: friend,
                        onChanged: (newValue) {
                          friend = newValue;
                          if (friend == "Ver todas!") {
                            getAllTortillasFriends(
                                    widget.account.email, friends)
                                .then((value) {
                              setState(() {
                                _allResults = value;
                                _markers.clear();
                                for (final v in value) {
                                  double opacity = v['torty_points'] / 10 + 0.5;
                                  Marker marker = Marker();
                                  if (friends_colors
                                      .containsKey(v['users'][0])) {
                                    marker = Marker(
                                      markerId: MarkerId(v['location']['name']),
                                      position: LatLng(
                                          double.parse(
                                              v['location']['coordinates_lat']),
                                          double.parse(v['location']
                                              ['coordinates_lon'])),
                                      infoWindow: InfoWindow(
                                        title: v['location']['name'],
                                      ),
                                      alpha: opacity,
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                        friends_colors[v['users'][0]],
                                      ),
                                    );
                                  } else {
                                    marker = Marker(
                                      markerId: MarkerId(v['location']['name']),
                                      position: LatLng(
                                          double.parse(
                                              v['location']['coordinates_lat']),
                                          double.parse(v['location']
                                              ['coordinates_lon'])),
                                      infoWindow: InfoWindow(
                                        title: v['location']['name'],
                                      ),
                                      alpha: opacity,
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueViolet,
                                      ),
                                    );
                                  }
                                  _markers[v['location']['name']] = marker;
                                }
                              });
                            });
                          } else {
                            getAllTortillasFriends(
                                widget.account.email, [friend])
                                .then((value) {
                              setState(() {
                                _allResults = value;
                                _markers.clear();
                                for (final v in value) {
                                  double opacity = v['torty_points'] / 10 + 0.5;
                                  Marker marker = Marker();
                                  if (friends_colors
                                      .containsKey(v['users'][0])) {
                                    marker = Marker(
                                      markerId: MarkerId(v['location']['name']),
                                      position: LatLng(
                                          double.parse(
                                              v['location']['coordinates_lat']),
                                          double.parse(v['location']
                                          ['coordinates_lon'])),
                                      infoWindow: InfoWindow(
                                        title: v['location']['name'],
                                      ),
                                      alpha: opacity,
                                      icon:
                                      BitmapDescriptor.defaultMarkerWithHue(
                                        friends_colors[v['users'][0]],
                                      ),
                                    );
                                  } else {
                                    marker = Marker(
                                      markerId: MarkerId(v['location']['name']),
                                      position: LatLng(
                                          double.parse(
                                              v['location']['coordinates_lat']),
                                          double.parse(v['location']
                                          ['coordinates_lon'])),
                                      infoWindow: InfoWindow(
                                        title: v['location']['name'],
                                      ),
                                      alpha: opacity,
                                      icon:
                                      BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueViolet,
                                      ),
                                    );
                                  }
                                  _markers[v['location']['name']] = marker;
                                }
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              )
            ]),
    );
  }

  Widget _boxes(String name, double lat, double long, double price,
      double quality, double torty,double amount,  String url, Color mine) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: Material(
            color: mine,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x80BB21F3),
            child: Container(
              padding: EdgeInsets.all(8),
              height: 130,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Torty: ",
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      RatingBarIndicator(
                        rating: torty,
                        itemBuilder: (context, index) => Icon(
                          Icons.whatshot_outlined,
                          color: Colors.amber[600],
                        ),
                        itemCount: 5,
                        itemSize: 16.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sabrosura: ",
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      RatingBarIndicator(
                        rating: quality,
                        itemBuilder: (context, index) => Icon(
                          Icons.restaurant_menu,
                          color: Colors.amber[600],
                        ),
                        itemCount: 5,
                        itemSize: 16.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cantidad: ",
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      RatingBarIndicator(
                        rating: amount,
                        itemBuilder: (context, index) => Icon(
                          Icons.breakfast_dining,
                          color: Colors.amber[600],
                        ),
                        itemCount: 5,
                        itemSize: 16.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                  Text(
                    "Precio: ${price} €",
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  Expanded(
                    child: FlatButton.icon(
                        onPressed: () {
                          _goToMaps(url);
                        },
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.purple,
                        ),
                        label: Text(
                          "Llévame!",
                          style: TextStyle(color: Colors.purple),
                        )),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}

_goToMaps(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
