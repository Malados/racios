import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/liste_options/compte.dart';
import 'package:racpresence/liste_options/edt.dart';
import 'package:racpresence/liste_options/annonces.dart';
import 'package:racpresence/liste_options/option_persos.dart';
import 'package:racpresence/connexion.dart';
import 'package:racpresence/liste_options/niveaux.dart';
import 'package:racpresence/liste_options/excelbdd.dart';
import 'package:racpresence/organisation.dart';
import 'package:racpresence/jaiunpb.dart';
import 'package:racpresence/variables.dart';
import 'liste_options/cours.dart';
import 'liste_options/eleve.dart';

// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class Parametre extends StatefulWidget {
  Parametre({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Parametre createState() => _Parametre();
}

class _Parametre extends State<Parametre> {
  final fireref = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  bool adminclik = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blancfond,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: bleufonce,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Jaiunpb(title: "J'ai un problème")));
                },
                icon: Icon(Icons.contact_support)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          id_,
                          style: TextStyle(
                              color: noirecrit,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        if (admin_ == true)
                          Container(
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: bleufonce,
                                            side: BorderSide(
                                                color: Colors.black, width: 2),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          onPressed: () {
                                            if (adminclik == true) {
                                              adminclik = false;
                                            } else {
                                              adminclik = true;
                                            }
                                            setState(() {});
                                          },
                                          child: Text(
                                            'Partie admin:',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                              if (adminclik == true)
                                Column(children: [
                                  Row(children: [
                                    Expanded(
                                      child: Container(
                                          height: 45,
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: bleuclair,
                                              side: BorderSide(
                                                  color: Colors.blue[800]!,
                                                  width: 2),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            child: Text(
                                              "Nouvelle base de données",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: noirecrit,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ExcelBDD(
                                                              title:
                                                                  'Upload nouvelle bdd')));
                                            },
                                          )),
                                    ),
                                  ]),
                                  Row(children: [
                                    Expanded(
                                      child: Container(
                                          height: 45,
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: bleuclair,
                                              side: BorderSide(
                                                  color: Colors.blue[800]!,
                                                  width: 2),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            child: Text(
                                              "Compte",
                                              style: TextStyle(
                                                  color: noirecrit,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => Compte(
                                                          title:
                                                              'Options compte')));
                                            },
                                          )),
                                    ),
                                  ]),
                                  Row(children: [
                                    Expanded(
                                      child: Container(
                                          height: 45,
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: bleuclair,
                                              side: BorderSide(
                                                  color: Colors.blue[800]!,
                                                  width: 2),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            child: Text(
                                              "Gérer les niveaux",
                                              style: TextStyle(
                                                  color: noirecrit,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => Niveaux(
                                                          title:
                                                              'Gérer les niveaux')));
                                            },
                                          )),
                                    ),
                                  ]),
                                ]),
                            ]),
                          ),
                        if (admin_ == true)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    decoration: BoxDecoration(
                                        color: bleufonce,
                                        border: Border.all(
                                            width: 2, color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Text(
                                      'Partie utilisateur:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                        Row(children: [
                          Expanded(
                            child: Container(
                                height: 45,
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: bleuclair,
                                    side: BorderSide(
                                        color: Colors.blue[800]!, width: 2),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    "Emploi du temps",
                                    style: TextStyle(
                                        color: noirecrit,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Edt(title: 'Emploi du temps')));
                                  },
                                )),
                          ),
                        ]),
                        if (orga_ == true)
                          Row(children: [
                            Expanded(
                              child: Container(
                                  height: 45,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: bleuclair,
                                      side: BorderSide(
                                          color: Colors.blue[800]!, width: 2),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: Text(
                                      "Organisation",
                                      style: TextStyle(
                                          color: noirecrit,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      var forma = await FirebaseDatabase(
                                              databaseURL:
                                                  'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
                                          .reference()
                                          .child('Formations')
                                          .once();
                                      var groupe = List.from(forma.value);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Organisation(
                                                      title: 'Organisation',
                                                      liste: groupe)));
                                    },
                                  )),
                            ),
                          ]),
                        Row(children: [
                          Expanded(
                            child: Container(
                                height: 45,
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: bleuclair,
                                    side: BorderSide(
                                        color: Colors.blue[800]!, width: 2),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    "Élève",
                                    style: TextStyle(
                                        color: noirecrit,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Eleve(title: "Élève")));
                                  },
                                )),
                          ),
                        ]),
                        Row(children: [
                          Expanded(
                            child: Container(
                                height: 45,
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: bleuclair,
                                    side: BorderSide(
                                        color: Colors.blue[800]!, width: 2),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    "Cours",
                                    style: TextStyle(
                                        color: noirecrit,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Cours(title: 'Cours')));
                                  },
                                )),
                          ),
                        ]),
                        Row(children: [
                          Expanded(
                            child: Container(
                                height: 45,
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: bleuclair,
                                    side: BorderSide(
                                        color: Colors.blue[800]!, width: 2),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    "Annonces",
                                    style: TextStyle(
                                        color: noirecrit,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Annonces(title: 'Annonces')));
                                  },
                                )),
                          ),
                        ]),
                        Row(children: [
                          Expanded(
                            child: Container(
                                height: 45,
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: bleuclair,
                                    side: BorderSide(
                                        color: Colors.blue[800]!, width: 2),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    "Options perso",
                                    style: TextStyle(
                                        color: noirecrit,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Options_Perso(
                                                title: 'Options perso')));
                                  },
                                )),
                          ),
                        ]),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  primary: orange,
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              child: Text(
                                "Déconnexion",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                setState(() {});
                                await Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Connexion(
                                            title: 'Connexion',
                                          )),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            )),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
