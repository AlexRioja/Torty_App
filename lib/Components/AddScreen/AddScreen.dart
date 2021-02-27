import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:torty_test_1/Components/place_service.dart';
import 'package:torty_test_1/FirebaseInterface.dart';
import 'package:torty_test_1/Tortilla.dart';
import 'package:geolocator/geolocator.dart';
import "package:google_maps_webservice/places.dart";
import 'AddScreen_fields.dart';

//TODO Clean-up code!!!!
//TODO Implement this https://github.com/AndreHaueisen/flushbar for location sites nearby
//TODO add user info to know who uploaded the tortilla

class AddScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                  nameField(controllers: _controllers, decorator: _decorator),
                  _locationField(_controllers),
                ],
              ),
              descField(controllers: _controllers, decorator: _decorator),
              priceField(controllers: _controllers, decorator: _decorator),
              qualityField(controllers: _controllers, decorator: _decorator),
              tortyField(controllers: _controllers, decorator: _decorator),
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
                          print(_controllers[2].text);
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
                            location: _controllers[2].text,
                            address: _controllers[4].text,
                            id:_controllers[5].text,
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

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');

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
                        onTap: () {
                          //TODO take the selected and show snackbar in addScreen
                          print("Ha seleccionado ${p.name}");
                          List<String> res = [p.name, p.url,p.formatted_address,p.id];
                          Navigator.pop(context, res);
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
  List<TextEditingController> controllers;

  __locationFieldState(this.controllers);

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
                  backgroundColor: Colors.transparent,
                  elevation: 20,
                  context: context,
                  builder: (context) => SingleChildScrollView(
                      child: BottomSheet(controllers[2], value))).then((value) {
                controllers[2].value = TextEditingValue(text: value[1]);
                controllers[4].value = TextEditingValue(text: value[2]);
                controllers[5].value = TextEditingValue(text: value[3]);

                return Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Has seleccionado: ${value[0]}"),
                  behavior: SnackBarBehavior.floating,
                  shape: StadiumBorder(),
                  elevation: 10,
                ));
              });
            });
          },
        ));
  }
}
