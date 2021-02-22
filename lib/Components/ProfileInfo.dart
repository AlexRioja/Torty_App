import 'package:flutter/material.dart';
import 'package:slimy_card/slimy_card.dart';

//TODO show the actual profile of the user && be able to logout

class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Profile(),
        decoration:
            BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/backgrounds/test_2.jpg"),fit: BoxFit.cover)),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: Icon(Icons.person),
            ),
            Text(
              "Perfil de usuario",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.amberAccent,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: ListView(
        children: <Widget>[
          SlimyCard(
            color: Colors.amberAccent,
            width: size.width / 1.2,
            borderRadius: 15,
            topCardWidget: Profile_up(),
            bottomCardWidget: Profile_down(),
            slimeEnabled: true,
          ),
        ],
      ),
    );
  }
}

class Profile_up extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage("assets/images/profile_example.jpg"))),
        ),
        SizedBox(height: 15),
        Text(
          'Nombre del usuario',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        Text(
          'Correo del usuario',
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
      ],
    );
  }
}

class Profile_down extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [RaisedButton(onPressed: () {}, child: Icon(Icons.logout))],
    );
  }
}
