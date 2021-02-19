import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomWidgets.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Pruebas Firebase"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("pruebas").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<DocumentSnapshot> docs = snapshot.data.docs;
            return ListView.builder(
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    docs[index].data() ;
                return ListTile(
                  leading: Checkbox(
                    value: data['isLoaded'],
                  ),
                  title: Text(data['cosas']),
                );
              },
              itemCount: docs.length,
            );
          },
        ));
  }
}
