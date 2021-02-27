import 'package:flutter/material.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';


class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Profile(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/backgrounds/test_2.jpg"),
                fit: BoxFit.cover)),
      ),
      appBar: AppBar(
        leading: Icon(Icons.person),
        title: Text(
          "Perfil de usuario",
          style: TextStyle(color: Colors.black,wordSpacing: 3),textAlign: TextAlign.center,
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
    GoogleSignInAccount account =
        Provider.of<LogState>(context, listen: false).currentUser;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 90,
          width: 90,
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
              image: DecorationImage(image: NetworkImage(account.photoUrl))),
        ),
        SizedBox(height: 15),
        Text(
          account.displayName,
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        Text(
          account.email,
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
      children: [
        RaisedButton(
            onPressed: () {
              Provider.of<LogState>(context, listen: false).logout();
              Navigator.of(context).pop();
            },
            child: Icon(Icons.logout))
      ],
    );
  }
}
