import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.search),
          title: Text(
            "Búsqueda",
            style: TextStyle(color: Colors.black, wordSpacing: 3),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.amberAccent,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image:
                AssetImage("assets/images/backgrounds/background_search_2.png"),
            fit: BoxFit.cover,
          )),
          child: test(),
        ));
  }
}

class Search_body extends StatefulWidget {
  @override
  _Search_bodyState createState() => _Search_bodyState();
}

class _Search_bodyState extends State<Search_body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AnimSearchBar(
            width: MediaQuery.of(context).size.width / 1.05,
            helpText: "Busca sin miedo...",
            closeSearchOnSuffixTap: true,
            onSuffixTap: () {},
          ),
        ),
        Expanded(
          child: ListView(
            children: [Text("asdasdasdas")],
          ),
        )
      ],
    );
  }
}

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class test extends StatelessWidget {
  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(search.length, (int index) {
      return Post(
        "Title : $search $index",
        "Description :$search $index",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SearchBar<Post>(
        onSearch: search,
        onItemFound: (Post post, int index) {
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.description),
          );
        },
      ),
    );
  }
}
