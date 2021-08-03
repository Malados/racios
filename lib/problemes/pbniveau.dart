import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';

// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class PbNiveau extends StatefulWidget {
  PbNiveau({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PbNiveau createState() => _PbNiveau();
}

class _PbNiveau extends State<PbNiveau> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleufonce,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Container(
                    color: blancfond,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 3, color: orange),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            width: 350,
                            child: Text(
                              'Il y a un problème:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: noirecrit,
                                fontSize: 18.0,
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Supprimer un niveau: maintenir le bouton qui contient son nom.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Le niveau n'est pas reconnu: attention aux subtilités, le nom du niveau doit être comme le nom du niveau qu'il y a dans le fichier excel utilisé ( les majuscules sont gérées automatiquement ).",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
