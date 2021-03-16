import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class Conversations {
  List<Widget> conversation1 = <Widget>[
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('Hola, ¿Quieres aprender algo nuevo? :)'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Claro!', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text(
          'Sabías que...¿Vitoria-Gasteiz, en 2014, consigue el título a la mayor tortilla de patata del mundo?'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('¿Enserio?', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Si!, Tuvieron que utilizar 1.600kg de patatas, 16.000 huevos, 150l de aceite, 26kg de cebollas y 15kg de sal!'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Vaya, menuda tortillada se pegaron...',
          textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Desde luego, a alguien le tuvo que doler la barriga después...'),
    ),
  ];

  List<Widget> conversation2 = <Widget>[
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text(
          'Hola, ¿Te cuento un truco para que no se te pegue la tortilla a la sartén? :)'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Desde luego!', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('Pon la sartén con aceite muy caliente'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('¿Sólo eso?', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'No, impaciente! También tienes que asegurarte de repartirlo bien por toda la superficie!'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Buen consejo Torty, lo pondré en práctica!',
          textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Me alegra oir eso, y no te olvides de tener un plato a mano para darle la vuelta!'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Ooooido cocina ;)', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text('Venga, a pelar patatas!'),
    ),
  ];
  List<Widget> conversation3 = <Widget>[
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('Tssss, eh tú!'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('¿Yo?', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('Sí claro, ¿Quién va a ser?'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Vale vale, ¿Qué quieres?', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          '¿Sabías que el 9 de marzo se celebra el Dia Internacional de la Tortilla de Patata?'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('No tenía ni idea!', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Si bueno, depende de la comunidad la fecha varía...pero suele coincidir con jueves Lardero, el comienzo del carnaval'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Wow, y qué hacen?', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Tradicionalmente se solía ir a pasar el día en el campo con un buen bocata de tortilla...ñam'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Torty, eres una autentica caja de sorpresas...',
          textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text('Si tú supieras... ;)'),
    ),
  ];
  List<Widget> conversation4 = <Widget>[
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('Hey!, ¿Quieres escuchar algo gracioso?'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Venga!', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('Conoces la "tortilla francesa" no?'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Sí, claro', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Já! Pues de francesa nada...la tortilla francesa es ESPAÑOLA!!!!!!!'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Emm...Torty...¿Estás bien?...', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Como lo oyes! Se inventó en España durante la guerra de la independencia'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Entonces...¿Por qué se llama tortilla francesa?',
          textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Bueno...cuando fue el asedio de los franceses, escaseaban los alimentos...y entre ellos las ricas patatas...así que las tortillas se hacían sólo con huevos'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Jodeta!', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text('Sí sí, de ahí el nombre de tortilla francesa'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Tiene huevos la cosa!', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text('Y que lo digas... ;)'),
    ),
  ];
  List<Widget> conversation5 = <Widget>[
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('Camarada!, ¿Tienes ganas de aprender?'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Bueno...estoy algo cansado...', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text('Sandeces!! Te voy a contar de cuándo data la primera tortilla!'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Bueno vale...', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Bueno, resulta que se fecha en el siglo XVII, en la localidad extremeña de Villanueva de la Serena'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Anda! Yo conozco a alguien de extremadura!', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Pues seguro que te prepara una buena tortilla!'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Y se sabe quién la inventó?',
          textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text(
          'Dicen las malas lenguas que fueron dos, Joseph de Tena Godoy y el marqués de Robledo'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Y cómo dieron con la fórmula?', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text('Bueno... Al final estaba compuesta de productos económicos y alimentaba de maravilla. A parte claro está, del magnifico sabor.'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('Ahá', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text('Y ahora hay hasta helado de tortilla de patata!...Estos hipsters...'),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightBottom,
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Text('...(usuario se acicala su larga barba sin saber qué decir)...', textAlign: TextAlign.right),
    ),
    Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      child: Text('Bueno, hasta la próxima!'),
    ),
  ];
  List<String> texts1 = <String>[
    'Claro!',
    '¿Enserio?',
    'Vaya, menuda tortillada se pegaron...',
    'Gracias por la info Torty!'
  ];
  List<String> texts2 = <String>[
    'Desde luego!',
    '¿Sólo eso?',
    'Buen consejo Torty, lo pondré en práctica!',
    'Ooooido cocina ;)',
    'Gracias por la info Torty!'
  ];
  List<String> texts3 = <String>[
    '¿Yo?',
    'Vale vale, ¿Qué quieres?',
    'No tenía ni idea!',
    'Wow, y qué hacen?',
    "Torty, eres una autentica caja de sorpresas...",
    'Gracias por la info Torty!'
  ];
  List<String> texts4 = <String>[
    'Venga!',
    'Sí, claro',
    'Emm...Torty...¿Estás bien?...',
    'Entonces...¿Por qué se llama tortilla francesa?',
    "Jodeta!",
    "Tiene huevos la cosa!",
    'Gracias por la info Torty!'
  ];
  List<String> texts5 = <String>[
    'Bueno...estoy algo cansado...',
    'Bueno vale...',
    'Anda! Yo conozco a alguien de extremadura!',
    'Y se sabe quién la inventó?',
    'Y cómo dieron con la fórmula?',
    "Ahá",
    "...(usuario se acicala su larga barba sin saber qué decir)...",
    'Gracias por la info Torty!'
  ];

  getConversation(int index) {
    if (index == 1) return conversation1;
    if (index == 2) return conversation2;
    if (index == 3) return conversation3;
    if (index == 4) return conversation4;
    if (index == 5) return conversation5;
  }

  List<String> getTexts(int index) {
    if (index == 1) return texts1;
    if (index == 2) return texts2;
    if (index == 3) return texts3;
    if (index == 4) return texts4;
    if (index == 5) return texts5;
  }
}
