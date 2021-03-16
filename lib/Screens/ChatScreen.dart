import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:torty_test_1/Components/Conversations.dart';
import 'package:rive/rive.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  size: 26.0,
                ),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        backgroundColor: Colors.amberAccent[100],
                        title: Text(
                          '¿Curioso?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                            'Veamos qué se cuenta Torty...'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Dismiss alert dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                tooltip: "Información acerca de esta pantalla",
              ))
        ],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Curiosidades",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/backgrounds/background_search.png"),fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              torty(),
              Expanded(child: Chat()),
            ],
          ),
        ),
      ),
    );
  }
}
class torty extends StatefulWidget {
  @override
  _tortyState createState() => _tortyState();
}

class _tortyState extends State<torty> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  @override
  void initState() {
    rootBundle.load('assets/rive/torty_curioso.riv').then(
          (data) async {
        final file = RiveFile();
        if (file.import(data)) {
          final artboard = file.mainArtboard;
          artboard.addController(_controller = SimpleAnimation('Idle'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/3,
      child: Rive(
        artboard: _riveArtboard,
      ),
    );
  }
}

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Widget> conversation = <Widget>[];
  List<Widget> filtered_conversation = <Widget>[];
  List<String> texts = <String>[];
  Conversations c;
  String texto;
  int counter_t;
  int counter_u;
  final _controller = ScrollController();

  @override
  void initState() {
    var rng = new Random();
    int ran = rng.nextInt(5);
    counter_t = 0;
    counter_u = 0;
    c = Conversations();
    conversation = c.getConversation(ran+1);
    texts = c.getTexts(ran+1);
    texto = texts[counter_u];
    filtered_conversation.add(conversation[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          controller: _controller,
          itemCount: filtered_conversation.length,
          itemBuilder: (BuildContext context, int index) {
            return filtered_conversation[index];
          },
        ),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            try {
              filtered_conversation.add(conversation[counter_t + 1]);
              filtered_conversation.add(conversation[counter_t + 2]);
              counter_t = counter_t + 2;
              counter_u = counter_u + 1;
              texto = texts[counter_u];
            } catch (Exception) {
              filtered_conversation.add(Bubble(
                margin: BubbleEdges.only(top: 10),
                alignment: Alignment.topRight,
                nip: BubbleNip.rightBottom,
                color: Color.fromRGBO(225, 255, 199, 1.0),
                child: Text('Gracias por la info Torty!',
                    textAlign: TextAlign.right),
              ));
            }
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          });
        },
        child: Text(texto),
      )
    ]);
  }
}
