import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/liste_options/cours/supcours.dart';
import 'package:racpresence/liste_options/cours/ajoutcours.dart';
import 'cours/modifcours.dart';

// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class Cours extends StatefulWidget {
  Cours({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Cours createState() => _Cours();
}

class _Cours extends State<Cours> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(centerTitle: true,
        backgroundColor: bleufonce,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: bleuclair,
                          ),
                          child: Text(
                            "Créer un cours",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AjoutCours(title: 'Créer un cours')));
                          },
                        )),
                  ),
                ]),
                Row(children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: bleuclair,
                          ),
                          child: Text(
                            "Modifier un cours",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ModifCours(title: 'Modifier un cours')));
                          },
                        )),
                  ),
                ]),
                Row(children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: bleuclair,
                          ),
                          child: Text(
                            "Supprimer un cours",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SupCours(title: 'Supprimer un cours')));
                          },
                        )),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
