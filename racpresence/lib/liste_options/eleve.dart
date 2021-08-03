import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/liste_options/eleve/ajouteleve.dart';
import 'package:racpresence/liste_options/eleve/changercours.dart';
import 'package:racpresence/liste_options/eleve/supeleve.dart';
import 'eleve/abseleve.dart';
import 'eleve/modifeleve.dart';

// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class Eleve extends StatefulWidget {
  Eleve({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Eleve createState() => _Eleve();
}

class _Eleve extends State<Eleve> {
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
                            "Créer un élève",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AjoutEleve(title: 'Créer un élève')));
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
                            "Changer cours d'un élève",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CoursEleve(
                                    title: "Modifier les cours d'un élève")));
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
                            "Modifier un élève",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ModifEleve(title: "Modifier un élève")));
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
                            "Supprimer un élève",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Supeleve(title: "Supprimer un élève")));
                          },
                        )),
                  ),
                ]),
                SizedBox(height: 50),
                Row(children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: bleuclair,
                          ),
                          child: Text(
                            "Voir les élèves avec 3 absences",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AbsEleve(title: "Élèves avec 3 absences")));
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
