import 'package:flutter/material.dart';
import 'package:torty_test_1/Components/place_service.dart';

class UserT {
  String name, email;

  UserT({this.name, this.email});
}

class Tortilla {
  String description, id;
  Place location;

//TODO Variable location, con la información de la localización del bar
  double quality, price, torty_points, amount;
  UserT user;

  Tortilla(
      {@required this.location,
      @required this.description,
      @required this.quality,
      @required this.price,
      @required this.amount,
      @required this.torty_points,
      @required this.id,
      @required this.user});
}
