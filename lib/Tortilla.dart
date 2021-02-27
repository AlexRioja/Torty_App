import 'package:flutter/cupertino.dart';

class Tortilla_bar {
  String name, description;

  //TODO Variable location, con la información de la localización del bar
  Tortilla_bar({
    @required this.name,
    this.description = '',
  });
}

class Tortilla {
  String name, description,location,address, id;

//TODO Variable location, con la información de la localización del bar
  double quality, price, torty_points;

  Tortilla(
      {@required this.name,
      @required this.description,
      @required this.quality,
      @required this.price,
      @required this.torty_points,
      @required this.location,
      @required this.address,
      @required this.id,
      });
}
