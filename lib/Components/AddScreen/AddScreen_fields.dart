import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

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

class nameField extends StatelessWidget {
  const nameField({
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

class descField extends StatelessWidget {
  const descField({
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
      padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 3),
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

class priceField extends StatelessWidget {
  const priceField({
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
    return Expanded(
      child: Padding(
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
      ),
    );
  }
}

class tortyField extends StatefulWidget {
  const tortyField({
    Key key,
    @required List<TextEditingController> controllers,
    @required InputDecoration decorator,
  })  : _controllers = controllers,
        _decorator = decorator,
        super(key: key);

  final List<TextEditingController> _controllers;
  final InputDecoration _decorator;

  @override
  _tortyFieldState createState() => _tortyFieldState(_controllers);
}

class _tortyFieldState extends State<tortyField> {
  double _currValue;
  List<TextEditingController> _controllers;

  _tortyFieldState(List<TextEditingController> _controllers);

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

class qualityField extends StatefulWidget {
  const qualityField({
    Key key,
    @required List<TextEditingController> controllers,
    @required InputDecoration decorator,
  })  : _controllers = controllers,
        _decorator = decorator,
        super(key: key);

  final List<TextEditingController> _controllers;
  final InputDecoration _decorator;

  @override
  _qualityFieldState createState() => _qualityFieldState();
}

class _qualityFieldState extends State<qualityField> {
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
