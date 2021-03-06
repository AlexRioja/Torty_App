import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:torty_test_1/Components/AddScreen_fields.dart';
import 'package:torty_test_1/Components/FirebaseInterface.dart';
import 'package:torty_test_1/Components/Tortilla.dart';
import 'package:torty_test_1/Components/location_service.dart';
import 'package:torty_test_1/Components/place_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rive/rive.dart';

//TODO Clean-up code!!!!
//TODO Implement this https://github.com/AndreHaueisen/flushbar for location sites nearby
//TODO add user info to know who uploaded the tortilla
//TODO Evitar más de una pulsación en localización
//TODO Cambiar localizacion para que aparezca una lista al principio, igual que en busqueda

class AddScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Añade tu tortilla',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amberAccent,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
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
                        'Añadir Tortilla',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text('Añade las tortillas, indica:\n'
                          ' -Precio\n'
                          ' -Sabrosura: Jugosidad de la tortilla\n'
                          ' -Cantidad: ¿Te ha llenado el pincho?\n'
                          ' -Puntos Torty: En general, ¿Cuál sería la puntuación?'),
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
          )
        ],
      ),
      body: ChangeNotifierProvider<SlidersState>(
        create: (_) => SlidersState(),
        child: AddForm(),
      ),
    );
  }
}

class riveAnim extends StatelessWidget {
  final Artboard _riveArtboard;

  riveAnim(this._riveArtboard);

  _getRandomPhrase() {
    List<String> phrases = [
      "Torty te vigila...",
      "No te pases de listo...",
      "Espero que le pongas buena nota...",
      "¿Qué miras?",
      "Eres un graciosillo...",
      "¿No tienes otra cosa que hacer más que tocarme?",
      "Aquí no hay nada que ver...",
      "Glurbrbb Glazorpt zhhh...",
      "Zzphhzzhzzpzph...",
      "如果您翻譯此內容，請告訴我我要吃雞蛋了",
      ".............................Tortilla............................",
      "Vosotros los humanos....",
      "¿Es verdad que los humanos descendeis de los monos?",
      "Molo un huevo...",
      "Espejito espejito, ¿Quién será el monstruo de tres ojos más bonito?",
    ];
    var rng = new Random();
    return phrases[rng.nextInt(phrases.length)];
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        var rng = new Random();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (rng.nextInt(20) == 1) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Has descubierto un secreto!"),
            behavior: SnackBarBehavior.floating,
            shape: StadiumBorder(),
            elevation: 10,
            duration: Duration(seconds: 50),
            action: SnackBarAction(
              label: "Llévame al secreto",
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed("/secret");
              },
            ),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              _getRandomPhrase(),
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
            shape: StadiumBorder(),
            elevation: 10,
          ));
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: MediaQuery.of(context).size.height / 3.5,
        child: Rive(
          artboard: _riveArtboard,
        ),
      ),
    );
  }
}

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _controllers;
  RiveAnimationController _controller;
  Artboard _riveArtboard;
  bool clicked;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    clicked = false;
    _controllers = [for (int i = 0; i < 8; i++) TextEditingController()];
    super.initState();
    rootBundle.load('assets/rive/eyes_search.riv').then(
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

  final InputDecoration _decorator = InputDecoration(
      border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(),
  ));

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/backgrounds/background_home.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.linearToSrgbGamma())),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              riveAnim(_riveArtboard),
              descField(controllers: _controllers, decorator: _decorator),
              price_location_row(
                  controllers: _controllers, decorator: _decorator),
              qualityField(controllers: _controllers, decorator: _decorator),
              quantityField(controllers: _controllers, decorator: _decorator),
              tortyField(controllers: _controllers, decorator: _decorator),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (_controllers[2].text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  'Por favor, introduce una localización.'),
                              behavior: SnackBarBehavior.floating,
                              shape: StadiumBorder(),
                              elevation: 10,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Procesando...'),
                              behavior: SnackBarBehavior.floating,
                              shape: StadiumBorder(),
                              elevation: 10,
                            ));
                            print(_controllers[2].text);
                            Place place = Place(
                                name: _controllers[2].text,
                                formatted_address: _controllers[4].text,
                                coordinates_lat: _controllers[5].text,
                                coordinates_lon: _controllers[7].text,
                                id: _controllers[0].text,
                                url: _controllers[6].text);
                            UserT u = UserT(
                                email: user.email,
                                name: user.displayName);
                            pushTortilla(Tortilla(
                                description: _controllers[1].text,
                                price: double.tryParse(_controllers[3].text),
                                quality: Provider.of<SlidersState>(context,
                                        listen: false)
                                    .q_state,
                                torty_points: Provider.of<SlidersState>(context,
                                        listen: false)
                                    .t_state,
                                amount: Provider.of<SlidersState>(context,
                                        listen: false)
                                    .amount_state,
                                location: place,
                                id: place.id,
                                user: u));
                            Future.delayed(const Duration(milliseconds: 1500),
                                () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text("Aceptar"),
                      shape: const StadiumBorder(),
                    ),
                    RaisedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancelar"),
                      shape: const StadiumBorder(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class price_location_row extends StatelessWidget {
  const price_location_row({
    Key key,
    @required List<TextEditingController> controllers,
    @required InputDecoration decorator,
  })  : _controllers = controllers,
        _decorator = decorator,
        super(key: key);

  final List<TextEditingController> _controllers;
  final InputDecoration _decorator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        priceField(controllers: _controllers, decorator: _decorator),
        _locationField(
          _controllers,
        ),
      ],
    );
  }
}

class BottomSheet extends StatefulWidget {
  TextEditingController _controller;
  Position _pos;

  BottomSheet(this._controller, this._pos);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  List<Place> suggestions = List<Place>();
  bool first = true;
  PlaceApiProvider prov = PlaceApiProvider("");

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.2,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.2,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.amber[50],
          //borderRadius: BorderRadius.all(Radius.circular(40)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        child: Column(
          children: [
            const Text(
              "Elige el creador de la tortilla...",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: widget._controller,
              onChanged: (text) async {
                Position x = widget._pos;
                prov
                    .fetchSuggestions(text, "Es", x.longitude.toString(),
                        x.latitude.toString())
                    .then((res) {
                  setState(() {
                    suggestions = res;
                  });
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(),
                  ),
                  hintText: "Empieza a teclear el nombre..."),
            ),
            Flexible(
                fit: FlexFit.tight,
                child: ListView(
                  padding: EdgeInsets.all(8),
                  children: [
                    for (Place p in suggestions)
                      ListTile(
                        onTap: () {
                          print("Ha seleccionado ${p.name}");
                          Navigator.pop(context, p);
                        },
                        shape: StadiumBorder(),
                        isThreeLine: true,
                        title: Text(p.name),
                        subtitle: Text(p.formatted_address),
                        leading: Image(
                          image: NetworkImage(p.icon),
                        ),
                      )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class _locationField extends StatefulWidget {
  List<TextEditingController> controllers;

  _locationField(this.controllers);

  @override
  __locationFieldState createState() => __locationFieldState(controllers);
}

class __locationFieldState extends State<_locationField> {
  bool clicked;
  List<TextEditingController> controllers;

  __locationFieldState(this.controllers);

  @override
  void initState() {
    clicked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: OutlineButton.icon(
          shape: const StadiumBorder(),
          borderSide: const BorderSide(color: Colors.black45),
          padding: const EdgeInsets.all(18),
          icon: const Icon(
            Icons.location_on,
            color: Colors.black54,
          ),
          label: const Text("Localización"),
          onPressed: () {
            if (clicked == true) return null;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Calculando ubicación...Por favor espere..."),
              behavior: SnackBarBehavior.floating,
              shape: StadiumBorder(),
              elevation: 10,
              duration: Duration(seconds: 2),
            ));
            setState(() {
              clicked = true;
            });
            determinePosition().then((value) {
              print(value);
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  elevation: 20,
                  context: context,
                  builder: (context) => SingleChildScrollView(
                      child: BottomSheet(controllers[2], value))).then((value) {
                if (value != null) {
                  controllers[2].value = TextEditingValue(text: value.name);
                  controllers[0].value = TextEditingValue(text: value.id);
                  controllers[6].value = TextEditingValue(text: value.url);
                  controllers[4].value =
                      TextEditingValue(text: value.formatted_address);
                  controllers[5].value =
                      TextEditingValue(text: value.coordinates_lat);
                  controllers[7].value =
                      TextEditingValue(text: value.coordinates_lon);
                  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Has seleccionado: ${value.name}"),
                    behavior: SnackBarBehavior.floating,
                    shape: StadiumBorder(),
                    elevation: 10,
                  ));
                }
              });
            }).then((value) {
              setState(() {
                clicked = false;
              });
            });
          },
        ));
  }
}
