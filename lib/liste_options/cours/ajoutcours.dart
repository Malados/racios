import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';

class AjoutCours extends StatefulWidget {
  AjoutCours({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AjoutCours createState() => _AjoutCours();
}

var currentUser = FirebaseAuth.instance.currentUser;
var fireref = FirebaseFirestore.instance.collection('users');

class _AjoutCours extends State<AjoutCours> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  final bddcours = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('cours');
  final auth = FirebaseAuth.instance;
  var quit = false;
  bool booltemp = false;
  void addcours() async {
    _jour = capitalize(_jour);
    bddcours.child(_jour + _debut + convertcourt(_court)).update({
      "Court séance": _court,
      "Prénom Prof Séance": capitalize(_prenom),
      "Nom Prof Séance": capitalize(_nom),
      "Début séance": _debut,
      "Fin séance": _fin,
      "Professeur séance": capitalize(_prenom) + ' ' + _nom.toUpperCase(),
      "Jour séance": _jour,
      "Nom Eleve": ['vide'],
      "Prénom Eleve": ['vide'],
      "Temp": ['vide'],
    });

    var user = await fireref
        .where("Nom", isEqualTo: capitalize(_nom))
        .where('Prénom', isEqualTo: capitalize(_prenom))
        .get();

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.docs[0].id)
        .collection('cours')
        .add({
      'Début séance': _debut,
      'Court séance': _court,
      'Fin séance': _fin,
      'Jour séance': _jour,
    });
  }

  void addcourstemp() async {
    _jour = capitalize(_jour);
    bddcours.child(_jour + _debut + convertcourt(_court)).update({
      "Court séance": _court,
      "Prénom Prof Séance": capitalize(_prenom),
      "Nom Prof Séance": capitalize(_nom),
      "Début séance": _debut,
      "Fin séance": _fin,
      "Professeur séance": capitalize(_prenom) + _nom.toUpperCase(),
      "Jour séance": _jour,
      "Nom Eleve": ['vide'],
      "Prénom Eleve": ['vide'],
      "Temp": ['vide'],
    });

    var user = await fireref
        .where("Nom", isEqualTo: _nom)
        .where('Prénom', isEqualTo: _prenom)
        .get();

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.docs[0].id)
        .collection('cours')
        .add({
      'Début séance': _debut,
      'Court séance': _court,
      'Fin séance': _fin,
      'Jour séance': _jour,
    });
  }

  var _courtcontroll = TextEditingController();
  String _court = "";
  var _debutcontroll = TextEditingController();
  String _debut = "";
  var _fincontroll = TextEditingController();
  String _fin = "";
  var _jourcontroll = TextEditingController();
  String _jour = "";
  var _nomcontroll = TextEditingController();
  String _nom = "";
  var _prenomcontroll = TextEditingController();
  String _prenom = "";

  var marge = EdgeInsets.fromLTRB(25, 5, 25, 5);

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(centerTitle: true,
        backgroundColor: bleufonce,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  margin: marge,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Jour',
                            style: TextStyle(
                              fontSize: 16,
                              color: noirecrit,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          width: 175,
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            controller: _jourcontroll,
                            decoration: InputDecoration(
                              hintText: 'Jour',
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(color: bleufonce),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _jour = value.trim();
                              });
                            },
                          ),
                        ),
                      ])),
              Container(
                margin: marge,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Début (hh:mm)',
                          style: TextStyle(fontSize: 16, color: noirecrit),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        width: 175,
                        margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                          controller: _debutcontroll,
                          decoration: InputDecoration(
                            hintText: 'Début du cours',
                            focusedBorder: new UnderlineInputBorder(
                              borderSide: BorderSide(color: bleufonce),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _debut = value.trim();
                            });
                          },
                        ),
                      ),
                    ]),
              ),
              Container(
                  margin: marge,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Fin (hh:mm)',
                            style: TextStyle(fontSize: 16, color: noirecrit),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          width: 175,
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            keyboardType: TextInputType.datetime,
                            controller: _fincontroll,
                            decoration: InputDecoration(
                                hintText: 'Fin du cours',
                                focusedBorder: new UnderlineInputBorder(
                                  borderSide: BorderSide(color: bleufonce),
                                )),
                            onChanged: (value) {
                              setState(() {
                                _fin = value.trim();
                              });
                            },
                          ),
                        ),
                      ])),
              Container(
                  margin: marge,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Court',
                            style: TextStyle(fontSize: 16, color: noirecrit),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          width: 175,
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            controller: _courtcontroll,
                            decoration: InputDecoration(
                              hintText: 'Court',
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(color: bleufonce),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _court = value.trim();
                              });
                            },
                          ),
                        ),
                      ])),
              Container(
                  margin: marge,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Nom',
                            style: TextStyle(fontSize: 16, color: noirecrit),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          width: 175,
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            controller: _nomcontroll,
                            decoration: InputDecoration(
                              hintText: 'Nom du prof',
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(color: bleufonce),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _nom = value.trim();
                              });
                            },
                          ),
                        ),
                      ])),
              Container(
                  margin: marge,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Prénom',
                            style: TextStyle(fontSize: 16, color: noirecrit),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          width: 175,
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            controller: _prenomcontroll,
                            decoration: InputDecoration(
                              hintText: 'Prénom du prof',
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(color: bleufonce),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _prenom = value.trim();
                              });
                            },
                          ),
                        ),
                      ])),
              SizedBox(height: 15),
              if (booltemp == true)
                Container(
                    margin: marge,
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Date (jj/mm)',
                              style: TextStyle(fontSize: 16, color: noirecrit),
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            width: 175,
                            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              controller: _prenomcontroll,
                              decoration: InputDecoration(
                                hintText: 'Date',
                                focusedBorder: new UnderlineInputBorder(
                                  borderSide: BorderSide(color: bleufonce),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _prenom = value.trim();
                                });
                              },
                            ),
                          ),
                        ])),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: bleuclair,
                  ),
                  child: Text("Créer le cours"),
                  onPressed: () async {
                    quit = true;
                    if (booltemp == true) {
                      addcourstemp();
                    } else {
                      addcours();
                    }

                    _courtcontroll.clear();
                    _debutcontroll.clear();
                    _fincontroll.clear();
                    _nomcontroll.clear();
                    _prenomcontroll.clear();
                    _jourcontroll.clear();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
