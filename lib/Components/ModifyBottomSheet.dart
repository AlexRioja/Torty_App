import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../main.dart';
import 'FirebaseInterface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SlidersState with ChangeNotifier {
  double _q_state = 2.5, _t_state = 2.5, _amount_state = 2.5;

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

  get amount_state => _amount_state;

  set amount_state(value) {
    _amount_state = value;
  }
}

class ModifyBottomSheet extends StatefulWidget {
  String id, name;
  double t_p, q_p, p, amount;

  ModifyBottomSheet(
      {this.id, this.q_p, this.t_p, this.p, this.name, this.amount});

  @override
  _ModifyBottomSheetState createState() => _ModifyBottomSheetState();
}

double torty;
double amount;
double quality;

class _ModifyBottomSheetState extends State<ModifyBottomSheet> {
  List<TextEditingController> _controllers;
  InputDecoration _decorator;
  final _formKey = GlobalKey<FormState>();
  rive.RiveAnimationController _controller;
  rive.Artboard _riveArtboard;
  User user ;
  @override
  void initState() {
    user= FirebaseAuth.instance.currentUser;
    quality = torty = amount = 2.5;
    _decorator = InputDecoration(
        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(),
    ));
    _controllers = [for (int i = 0; i < 3; i++) TextEditingController()];
    rootBundle.load('assets/rive/eyes_search.riv').then(
      (data) async {
        final file = rive.RiveFile();
        if (file.import(data)) {
          final artboard = file.mainArtboard;
          artboard.addController(_controller = rive.SimpleAnimation('Idle'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration _decorator = InputDecoration(
        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(),
    ));
    return Container(
        height: MediaQuery.of(context).size.height / 1.2,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.2,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amberAccent[100],
            image: DecorationImage(
                image:
                    AssetImage("assets/images/backgrounds/background_home.jpg"),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: rive.Rive(
                        artboard: _riveArtboard,
                      ),
                    ),
                  ),
                  priceField(
                    controller: _controllers[0],
                    decorator: _decorator,
                    p: widget.p,
                  ),
                  quantityField(
                    value: widget.amount,
                  ),
                  qualityField(value: widget.q_p),
                  tortyField(value: widget.t_p),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            update(double.tryParse(_controllers[0].text), torty,
                                quality,amount,  widget.id + '_' + user.email);
                            Navigator.of(context).pop();
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
                        icon: Icon(Icons.cancel_outlined),
                        label: Text("Cancelar"),
                        shape: StadiumBorder(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class priceField extends StatelessWidget {
  const priceField(
      {Key key,
      @required TextEditingController controller,
      @required InputDecoration decorator,
      @required double p})
      : _controller = controller,
        _decorator = decorator,
        _p = p,
        super(key: key);

  final TextEditingController _controller;
  final InputDecoration _decorator;
  final double _p;

  bool _isNumericUsing_tryParse(String string) {
    if (string == null || string.isEmpty) {
      return false;
    }
    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 3, bottom: 3),
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        controller: _controller,
        validator: (value) {
          if (value.isEmpty || !this._isNumericUsing_tryParse(value)) {
            return 'Introduce un precio por favor';
          }
        },
        decoration: _decorator.copyWith(
            labelText: "Anterior precio: $_p",
            prefixIcon: Icon(Icons.attach_money)),
      ),
    );
  }
}

class tortyField extends StatefulWidget {
  double value;

  tortyField({this.value});

  @override
  _tortyFieldState createState() => _tortyFieldState();
}

class _tortyFieldState extends State<tortyField> {
  double _currValue;

  @override
  void initState() {
    _currValue = widget.value;
    super.initState();
  }

  double getValue() {
    return _currValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 13),
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
                initialRating: _currValue,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.whatshot_outlined,
                  //TODO Cambiar el icono para que sean tortillas o tenedores !
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _currValue = rating;
                  setState(() {
                    torty = _currValue;
                  });
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

class qualityField extends StatefulWidget {
  double value;

  qualityField({this.value});

  @override
  _qualityFieldState createState() => _qualityFieldState();
}

class _qualityFieldState extends State<qualityField> {
  double _currValue;

  @override
  void initState() {
    _currValue = widget.value;
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
                initialRating: _currValue,
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
                  setState(() {
                    quality = _currValue;
                  });
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

class quantityField extends StatefulWidget {
  double value;

  quantityField({this.value});

  @override
  _quantityFieldState createState() => _quantityFieldState();
}

class _quantityFieldState extends State<quantityField> {
  double _currValue;

  @override
  void initState() {
    _currValue = widget.value;
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
            Text("Cantidad",
                style: TextStyle(color: Colors.black54, fontSize: 16)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RatingBar.builder(
                itemSize: 37,
                glowColor: Colors.amber,
                initialRating: _currValue,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.free_breakfast,
                  //TODO Cambiar el icono para que sean tortillas o tenedores !
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _currValue = rating;
                  setState(() {
                    amount = _currValue;
                  });
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
