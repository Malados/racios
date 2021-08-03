
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/liste_options/eleve/ajouteleve.dart';
import 'package:racpresence/problemes/pbniveau.dart';
import 'package:racpresence/problemes/pbquitte.dart';

// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class Jaiunpb extends StatefulWidget {
  Jaiunpb({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Jaiunpb createState() => _Jaiunpb();
}

class _Jaiunpb extends State<Jaiunpb> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        backgroundColor: bleufonce,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              children: [
                Column(
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
                                "Problème pour remplir la base de données",
                                textAlign: TextAlign.center,
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
                                "Problème avec les niveaux",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PbNiveau(title: "J'ai un problème")));
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
                                "Autre",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Pbquitte(title: "J'ai un problème")));
                              },
                            )),
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              'Dévelopée par Jean-Charles Fournier',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
