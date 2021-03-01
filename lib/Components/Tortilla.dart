import 'package:flutter/material.dart';
import 'package:torty_test_1/Components/place_service.dart';

class User {
  String name, email;

  User({this.name, this.email});
}

class Tortilla {
  String description, id;
  Place location;

//TODO Variable location, con la información de la localización del bar
  double quality, price, torty_points;
  User user;

  Tortilla(
      {@required this.location,
      @required this.description,
      @required this.quality,
      @required this.price,
      @required this.torty_points,
      @required this.id,
      @required this.user});
}