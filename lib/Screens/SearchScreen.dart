import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:torty_test_1/Components/FirebaseInterface.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:torty_test_1/Components/ModifyBottomSheet.dart';
import 'package:torty_test_1/Components/location_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'package:feature_discovery/feature_discovery.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount account =
        Provider.of<LogState>(context, listen: false).currentUser;
    return Scaffold(
        floatingActionButton: DescribedFeatureOverlay(
          featureId: 'map',
          tapTarget: Icon(Icons.map),
          title: Text("Vista de mapa"),
          overflowMode: OverflowMode.extendBackground,
          contentLocation: ContentLocation.above,
          description: Text(
              "Aquí podrás ver las localizaciones de tus tortillas y las de tus amigos!"),
          child: FloatingActionButton.extended(
            onPressed: () {
              determinePosition();
              Navigator.of(context).pushNamed('/map');
            },
            label: Text("Ver el mapa!"),
            icon: Icon(Icons.map),
          ),
        ),
        appBar: AppBar(
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: DescribedFeatureOverlay(
                  featureId: "info",
                  tapTarget: Icon(Icons.info_outline),
                  title: Text("Iconos de información"),
                  description: Text(
                      "Pincha en estos iconos siempre que necesites algo de info!"),
                  overflowMode: OverflowMode.extendBackground,
                  contentLocation: ContentLocation.below,
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
                              'Pantalla de Búsqueda',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                                'Aquí encontrarás todas tus tortillas. '
                                'Puedes filtrar los resultados por el nombre de la '
                                'ciudad, de la calle o del restaurante!\n'
                                'Desliza los items hacia izquierda y derecha para ver las opciones.'),
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
                  ),
                ))
          ],
          leading: Icon(Icons.search),
          title: Text(
            "Búsqueda",
            style: TextStyle(color: Colors.black, wordSpacing: 3),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.amberAccent,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image:
                AssetImage("assets/images/backgrounds/background_search_2.png"),
            fit: BoxFit.cover,
          )),
          child: Search_body(email: account.email),
        ));
    //child: test_2(email: account.email)));
  }
}

class Search_body extends StatefulWidget {
  String email;

  Search_body({this.email});

  @override
  _Search_bodyState createState() => _Search_bodyState();
}

class _Search_bodyState extends State<Search_body> {
  List _allResults = [];
  List _filteredResults = [];
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    getAllTortillas(widget.email).then((value) {
      _allResults = value;
      _filterList();
    });
    _controller.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_controller.text);
    _filterList();
  }

  _filterList() {
    var showResults = [];
    if (_controller.text != "") {
      for (var t in _allResults) {
        String name = t['location']['name'].toLowerCase();
        String address = t['location']['address'].toLowerCase();
        if (name.contains(_controller.text.toLowerCase()) ||
            address.contains(_controller.text.toLowerCase())) {
          showResults.add(t);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _filteredResults = showResults;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DescribedFeatureOverlay(
            featureId: "search",
            tapTarget: Icon(Icons.search),
            overflowMode: OverflowMode.extendBackground,
            contentLocation: ContentLocation.below,
            title: Text("Filtra los resultados"),
            description: Text(
                "Puedes buscar por ciudad, calle o nombre del bar.\n"
                "No olvides que puedes deslizar hacia izquierda o derecha para ver las opciones!!"),
            backgroundColor: Colors.blueAccent,
            textColor: Colors.black,
            child: AnimSearchBar(
              width: MediaQuery.of(context).size.width / 1.05,
              helpText: "Busca sin miedo...",
              closeSearchOnSuffixTap: true,
              onSuffixTap: () {
                _controller.clear();
              },
              textController: _controller,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
          child: Text(
            "Desliza los items hacia izquierda y derecha para ver las opciones.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return SlidableTile(
                data: _filteredResults, index: index, email: widget.email);
          },
          itemCount: _filteredResults.length,
        ))
      ],
    );
  }
}

class SlidableTile extends StatelessWidget {
  List data = [];
  int index;
  String email;

  SlidableTile({this.data, this.index, this.email});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: ListTile(
        title: Text(data[index]["location"]["name"]),
        subtitle: Text(data[index]["location"]["address"]),
        onTap: () {},
        leading: const Icon(Icons.restaurant),
        isThreeLine: true,
      ),
      actionPane: const SlidableDrawerActionPane(),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Llévame',
          color: Colors.blue,
          icon: Icons.location_on,
          onTap: () {
            _goToMaps(data[index]['location']['url']);
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Modificar',
          color: Colors.black45,
          icon: Icons.update,
          onTap: () => {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              elevation: 20,
              context: context,
              builder: (context) => SingleChildScrollView(
                child: ModifyBottomSheet(
                  id: data[index]['id'],
                  p: data[index]['price'],
                  q_p: data[index]['quality'],
                  t_p: data[index]['torty_points'],
                  name: data[index]['location']['name'],
                  amount: data[index]['amount'],
                ),
              ),
            )
          },
        ),
        IconSlideAction(
          caption: 'Borrar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            delete(data[index]['id'] + '_' + email);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                'Borrado. La lista se actualizará al volver a esta pantalla...',
                textAlign: TextAlign.center,
              ),
              behavior: SnackBarBehavior.floating,
              shape: StadiumBorder(),
              elevation: 10,
            ));
          },
        ),
      ],
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
