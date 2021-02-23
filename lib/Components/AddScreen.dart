import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:torty_test_1/Components/place_service.dart';
import 'package:torty_test_1/FirebaseInterface.dart';
import '../Tortilla.dart';
import 'package:geolocator/geolocator.dart';
import "package:google_maps_webservice/places.dart";
import 'package:flutter_google_places/flutter_google_places.dart';

//TODO Clean-up code!!!!
//TODO Implement this https://github.com/AndreHaueisen/flushbar for location sites nearby
//TODO add user info to know who uploaded the tortilla
class SlidersState with ChangeNotifier {
  double _q_state = 2.5, _t_state = 2.5;

  double get q_state => _q_state;

  double get t_state => _t_state;

  set q_state(double value) {
    _q_state = value;
    notifyListeners();
  }

  set t_state(value) {
    _t_state = value;
    notifyListeners();
  }
}

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "add_btn",
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Añade tu tortilla',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amberAccent,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider<SlidersState>(
          create: (_) => SlidersState(),
          child: AddForm(),
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

  @override
  void initState() {
    _controllers = [for (int i = 0; i < 6; i++) TextEditingController()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseInterface f = FirebaseInterface();
    InputDecoration _decorator = InputDecoration(
        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(),
    ));
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/backgrounds/test_2.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.linearToSrgbGamma())),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _nameField(controllers: _controllers, decorator: _decorator),
                  _locationField(_controllers[2]),
                ],
              ),
              _descField(controllers: _controllers, decorator: _decorator),
              _priceField(controllers: _controllers, decorator: _decorator),
              _qualityField(controllers: _controllers, decorator: _decorator),
              _tortyField(controllers: _controllers, decorator: _decorator),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // Si el formulario es válido, muestre un snackbar. En el mundo real, a menudo
                          // desea llamar a un servidor o guardar la información en una base de datos
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Procesando...'),
                            behavior: SnackBarBehavior.floating,
                            shape: StadiumBorder(),
                            elevation: 10,
                          ));
                          f.pushTortilla(Tortilla(
                            name: _controllers[0].text,
                            description: _controllers[1].text,
                            price: double.tryParse(_controllers[3].text),
                            quality: Provider.of<SlidersState>(context,
                                    listen: false)
                                .q_state,
                            torty_points: Provider.of<SlidersState>(context,
                                    listen: false)
                                .t_state,
                          ));
                          Future.delayed(const Duration(milliseconds: 2500),
                              () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          });
                        }
                      },
                      icon: Icon(Icons.check),
                      label: Text("Aceptar"),
                      shape: StadiumBorder(),
                    ),
                    RaisedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.cancel),
                      label: Text("Cancelar"),
                      shape: StadiumBorder(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

class _nameField extends StatelessWidget {
  const _nameField({
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15, right: 0, bottom: 3),
        child: TextFormField(
          controller: _controllers[0],
          validator: (value) {
            if (value.isEmpty) {
              return 'Introduce el nombre por favor';
            }
          },
          decoration: _decorator.copyWith(
              labelText: "Nombre",
              prefixIcon: Icon(Icons.drive_file_rename_outline)),
        ),
      ),
    );
  }
}

class _descField extends StatelessWidget {
  const _descField({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: TextFormField(
        controller: _controllers[1],
        validator: (value) {
          if (value.isEmpty) {
            return 'Introduce algo de descripción por favor';
          }
        },
        decoration: _decorator.copyWith(
            labelText: "Descripción", prefixIcon: Icon(Icons.description)),
      ),
    );
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
    await Geolocator.openAppSettings();
    await Geolocator.openLocationSettings();
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }
  try {
    return await Geolocator.getCurrentPosition(
        timeLimit: Duration(seconds: 7),
        desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    return await Geolocator.getLastKnownPosition();
  }
}

Future<PlacesSearchResponse> _determinePlaces(Position p) async {
  final places = GoogleMapsPlaces(
    apiKey: "AIzaSyB-ZtCLpanxJjBDUOLNWVo4zrloB32S1k4",
  );
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
      color: Colors.grey,
      child: Container(
        height: MediaQuery.of(context).size.height / 1.2,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Text(
              "Elige el creador de la tortilla...",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
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
                        onTap: (){
                          //TODO take the selected and show snackbar in addScreen
                        },
                        shape: StadiumBorder(),
                        tileColor: Colors.amberAccent,
                        title: Text(p.name),
                        subtitle: Text(p.formatted_address),
                        leading: Image(
                          image: NetworkImage(p.icon),
                        ),
                      )
                  ],
                )
                /*child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suggestions[index].name),
                      subtitle: Text(suggestions[index].formatted_address),
                      leading: Image(
                        image: NetworkImage(suggestions[index].icon),
                      ),
                    );
                  },
                  itemCount: suggestions.length,
              ),*/
                ),
          ],
        ),
      ),
    );
  }
}

_callDetailId(PlaceApiProvider prov, List<Suggestion> list) async {
  List<Place> places = [];
  for (Suggestion s in list) {
    Place p = await prov.getPlaceDetailFromId(s.placeId);
    places.add(p);
  }
  return places;
}

class _locationField extends StatefulWidget {
  TextEditingController controller;

  _locationField(this.controller);

  @override
  __locationFieldState createState() => __locationFieldState(controller);
}

class __locationFieldState extends State<_locationField> {
  TextEditingController controller;

  __locationFieldState(this.controller);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 30, left: 10, right: 15, bottom: 3),
        child: OutlineButton.icon(
          shape: StadiumBorder(),
          borderSide: BorderSide(color: Colors.black45),
          padding: EdgeInsets.all(18),
          icon: Icon(
            Icons.location_on,
            color: Colors.black54,
          ),
          label: Text("Localización"),
          onPressed: () {
            _determinePosition().then((value) {
              print(value);
              showModalBottomSheet(
                  isScrollControlled: true,
                  elevation: 20,
                  context: context,
                  builder: (context) => SingleChildScrollView(
                      child: BottomSheet(controller, value)));
            });
          },
        ));
  }
}

class _priceField extends StatelessWidget {
  const _priceField({
    Key key,
    @required List<TextEditingController> controllers,
    @required InputDecoration decorator,
  })  : _controllers = controllers,
        _decorator = decorator,
        super(key: key);

  final List<TextEditingController> _controllers;
  final InputDecoration _decorator;

  bool isNumericUsing_tryParse(String string) {
    // Null or empty string is not a number
    if (string == null || string.isEmpty) {
      return false;
    }

    // Try to parse input string to number.
    // Both integer and double work.
    // Use int.tryParse if you want to check integer only.
    // Use double.tryParse if you want to check double only.
    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        controller: _controllers[3],
        validator: (value) {
          if (value.isEmpty || !this.isNumericUsing_tryParse(value)) {
            return 'Introduce un precio por favor';
          }
        },
        decoration: _decorator.copyWith(
            labelText: "Precio", prefixIcon: Icon(Icons.attach_money)),
      ),
    );
  }
}

class _tortyField extends StatefulWidget {
  const _tortyField({
    Key key,
    @required List<TextEditingController> controllers,
    @required InputDecoration decorator,
  })  : _controllers = controllers,
        _decorator = decorator,
        super(key: key);

  final List<TextEditingController> _controllers;
  final InputDecoration _decorator;

  @override
  __tortyFieldState createState() => __tortyFieldState(_controllers);
}

class __tortyFieldState extends State<_tortyField> {
  double _currValue;
  List<TextEditingController> _controllers;

  __tortyFieldState(List<TextEditingController> _controllers);

  @override
  void initState() {
    _currValue = 2.5;
    super.initState();
  }

  double getValue() {
    return _currValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Puntos Torty",
                style: TextStyle(color: Colors.black54, fontSize: 16)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RatingBar.builder(
                itemSize: 37,
                glowColor: Colors.amber,
                initialRating: 2.5,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.restaurant_menu,
                  //TODO Cambiar el icono para que sean tortillas o tenedores !
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _currValue = rating;
                  Provider.of<SlidersState>(context, listen: false).t_state =
                      _currValue;
                },
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black38)),
      ),
    );
  }
}

class _qualityField extends StatefulWidget {
  const _qualityField({
    Key key,
    @required List<TextEditingController> controllers,
    @required InputDecoration decorator,
  })  : _controllers = controllers,
        _decorator = decorator,
        super(key: key);

  final List<TextEditingController> _controllers;
  final InputDecoration _decorator;

  @override
  __qualityFieldState createState() => __qualityFieldState();
}

class __qualityFieldState extends State<_qualityField> {
  double _currValue;

  @override
  void initState() {
    _currValue = 2.5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Calidad",
                style: TextStyle(color: Colors.black54, fontSize: 16)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RatingBar.builder(
                itemSize: 37,
                glowColor: Colors.amber,
                initialRating: 2.5,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  //TODO Cambiar el icono para que sean tortillas o tenedores !
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _currValue = rating;
                  Provider.of<SlidersState>(context, listen: false).q_state =
                      _currValue;
                },
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black38)),
      ),
    );
  }
}
