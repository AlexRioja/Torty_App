import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Añade tu tortilla',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amberAccent,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: AddForm(),
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
    InputDecoration _decorator = InputDecoration(
        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(),
    ));
    List<String> _labels = [
      'Nombre',
      'Descripción',
      'Localización',
      'Calidad',
      'Precio',
      'Marcador Torty'
    ];
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backgrounds/test_2.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma()
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _nameField(controllers: _controllers, decorator: _decorator),
                _descField(controllers: _controllers, decorator: _decorator),
                _locationField(controllers: _controllers, decorator: _decorator),
                _qualityField(controllers: _controllers, decorator: _decorator),
                _priceField(controllers: _controllers, decorator: _decorator),
                _tortyField(controllers: _controllers, decorator: _decorator),
                //TODO implementar botones para confirmar y cancelar formulario y poner bonito (row)
              ],
            ),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 3),
      child: TextField(
        controller: _controllers[0],
        onSubmitted: (String Value) {},
        decoration: _decorator.copyWith(labelText: "Nombre"),
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
      child: TextField(
        controller: _controllers[1],
        onSubmitted: (String Value) {},
        decoration: _decorator.copyWith(labelText: "Descripcion"),
      ),
    );
  }
}

class _locationField extends StatelessWidget {
  const _locationField({
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
      child: TextField(
        controller: _controllers[2],
        onSubmitted: (String Value) {},
        decoration: _decorator.copyWith(
            labelText: "Localización", prefixIcon: Icon(Icons.location_on)),
      ),
    );
  }
}

class _qualityField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: TextField(
        controller: _controllers[3],
        onSubmitted: (String Value) {},
        decoration: _decorator.copyWith(
            labelText: "Calidad", prefixIcon: Icon(Icons.star)),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        controller: _controllers[4],
        onSubmitted: (String Value) {},
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
  __tortyFieldState createState() => __tortyFieldState();
}

class __tortyFieldState extends State<_tortyField> {
  double _currValue;

  @override
  void initState() {
    // TODO: implement initState
    _currValue = 3;
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
            Text("Puntos Torty",
                style: TextStyle(color: Colors.black54, fontSize: 16)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RatingBar.builder(
                initialRating: 3,
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
                  print(rating);
                  _currValue = rating;
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
/*
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10,left: 20),
              child: Align(
                child: Text(
                  "Marcador Torty",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Slider(
              value: _currValue,
              min: 0,
              max: 5,
              divisions: 5,
              label: _currValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }*/
}
