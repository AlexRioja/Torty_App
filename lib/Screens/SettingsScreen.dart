import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torty_test_1/Components/SharedPreferencesInterface.dart';
import 'package:rive/rive.dart' as rive;
import 'package:slimy_card/slimy_card.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import 'package:feature_discovery/feature_discovery.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> friends;

  @override
  void didChangeDependencies() async {
    getEmails().then((value) {
      setState(() {
        friends = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.settings),
        title: Text(
          "Ajustes",
          style: TextStyle(color: Colors.black, wordSpacing: 3),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.amberAccent,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Container(
        child: Profile(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/backgrounds/background_search.png"),
                fit: BoxFit.cover)),
      ),
    );
  }
}

class Settings_column extends StatelessWidget {
  const Settings_column({
    Key key,
    @required this.friends,
  }) : super(key: key);

  final List<String> friends;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          About_app(),
          Add_friend_share(),
          Delete_friend_share(),
          Privacy_policy(),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/chat');
              },
              child: Text("¿Curioso? ;)")),

        ],
      ),
    );
  }
}

class About_app extends StatelessWidget {
  const About_app({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showAboutDialog(
            context: context,
            applicationName: "Torty",
            applicationIcon: Icon(Icons.local_pizza),
            applicationVersion: "0.0.1",
            applicationLegalese: "Alejandro Martínez de Ternero Ruiz.",
            children: <Widget>[
              Text("Con todo el cariño del mundo hacia vosotros :)"),
            ]);
      },
      child: Text(
        'Acerca de la aplicación',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Add_friend_share extends StatefulWidget {
  Add_friend_share({
    Key key,
  }) : super(key: key);

  @override
  _Add_friend_shareState createState() => _Add_friend_shareState();
}

class _Add_friend_shareState extends State<Add_friend_share> {
  List<String> friends;

  @override
  void initState() {
    getEmails().then((value) {
      setState(() {
        friends = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            TextEditingController _controller = TextEditingController();
            return AlertDialog(
              backgroundColor: Colors.amberAccent[100],
              title: Text(
                'Ver tortillas de mis amigos!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Column(
                    children: [
                      friends.length == 0
                          ? Container(
                              height: 50,
                              color: Colors.amberAccent,
                              child: Text(
                                "No tienes ningún amigo todavía! :(",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(
                              height: 120,
                              child: Column(
                                children: [
                                  for (final f in friends)
                                    Text(
                                      f,
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                ],
                              ),
                            ),
                      Text(
                          'Introduce el correo del usuario en el siguiente apartado.\n'
                          'Podrás ver sus tortillas en el mapa!\n'
                          'Puedes tener hasta 5 amigos!'),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        onChanged: (value) {},
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: "Introduce el correo de tu amigo"),
                      ),
                      Text(
                        'Asegurate de escribirlo correctamente!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Enviar'),
                  onPressed: () {
                    setEmail(_controller.text).then((value) {
                      getEmails().then((value) {
                        setState(() {
                          friends = value;
                        });
                      });
                      Navigator.of(dialogContext).pop(value);
                    });
                    // Dismiss alert dialog
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        ).then((value) {
          if (value != null) {
            if (!value)
              print("cacacacaca");
            else
              print("BIEEEEEEEEN");
          }
        });
      },
      child: Text(
        '¿Cómo compartir tortillas con mis amigos?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Privacy_policy extends StatelessWidget {
  const Privacy_policy({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Colors.amberAccent[100],
              title: Text(
                'Privacidad Torty',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                  "Torty no almacena ningún dato a parte de las tortillas!\n"
                  "El inicio de sesión es seguro y los datos están gestionados enteramente por Google"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        'Política de privacidad',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Delete_friend_share extends StatefulWidget {
  const Delete_friend_share({
    Key key,
  }) : super(key: key);

  @override
  _Delete_friend_shareState createState() => _Delete_friend_shareState();
}

class _Delete_friend_shareState extends State<Delete_friend_share> {
  List<String> friends = [];
  String friend;
  rive.Artboard _riveArtboard;
  rive.RiveAnimationController _controller;
  bool playOnce;

  void _loadRiveFile() async {
    final bytes = await rootBundle.load("assets/rive/red_button.riv");
    final file = rive.RiveFile();
    file.import(bytes);
    _riveArtboard = file.mainArtboard;
    _idle();
  }

  @override
  void initState() {
    playOnce = true;
    friend = null;
    _loadRiveFile();
    getEmails().then((value) {
      setState(() {
        friends = value;
      });
    });
    super.initState();
  }

  void _crack() {
    _riveArtboard.addController(_controller = rive.SimpleAnimation('Crack'));
  }

  void _idle() {
    _riveArtboard.addController(_controller = rive.SimpleAnimation('Idle'));
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Colors.amberAccent[100],
              title: const Text(
                '¿Cómo puedo borrar a mis amigos?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                children: [
                  Text("Para borrar a tus amigos, presiona el icono...\n"
                      "Te echarán de menos :("),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Aviso: Contenido sensible!",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      if (playOnce) _crack();
                      playOnce = false;
                      deleteFriends();
                      Future.delayed(const Duration(milliseconds: 3500), () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Enhorabuena! Te has ganado el título de 'Lobo Solitario' :( ",
                            textAlign: TextAlign.center,
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: StadiumBorder(),
                          elevation: 10,
                        ));
                      });
                    },
                    child: Container(
                      height: 250,
                      child: rive.Rive(
                        artboard: _riveArtboard,
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        '¿Cómo puedo borrar a mis amigos?',
        style: TextStyle(fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          DescribedFeatureOverlay(
            tapTarget: Icon(Icons.person),
            featureId: 'settings',
            title: Text("Perfil y Ajustes"),
            overflowMode: OverflowMode.wrapBackground,
            description: Text("Pincha para desvelar los ajustes y opciones para compartir tortillas!"),
            child: SlimyCard(
              color: Colors.amberAccent,
              width: size.width / 1.2,
              topCardHeight: size.height / 3.5,
              bottomCardHeight: size.height / 2,
              borderRadius: 20,
              topCardWidget: Profile_up(),
              bottomCardWidget: Profile_down(),
              slimeEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

class Profile_up extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;
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
              image: DecorationImage(image: NetworkImage(user.photoURL))),
        ),
        SizedBox(height: 2),
        Text(
          user.displayName,
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        Text(
          user.email,
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ],
    );
  }
}

class Profile_down extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Settings_column();
  }
}
/*
class Profile_down extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Settings_column
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
            onPressed: () {
              Provider.of<LogState>(context, listen: false).logout();
              //Navigator.of(context).pop();
            },
            child: Icon(Icons.logout))
      ],
    );
  }
}
*/
