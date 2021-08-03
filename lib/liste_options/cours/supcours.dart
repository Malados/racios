import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';

class SupCours extends StatefulWidget {
  SupCours({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SupCours createState() => _SupCours();
}

var currentUser = FirebaseAuth.instance.currentUser;
var fireref = FirebaseFirestore.instance.collection('users');

class _SupCours extends State<SupCours> {
  final bddcours = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('cours');
  var quit = false;
  bool booltemp = false;
  bool pascours = false;

  void supp() async {
    _jour = capitalize(_jour);
    _court = convertcourt(_court);

    bddcours.child(_jour + _debut + convertcourt(_court)).remove();
  }

  var _courtcontroll = TextEditingController();
  String _court = "";
  var _debutcontroll = TextEditingController();
  String _debut = "";
  var _jourcontroll = TextEditingController();
  String _jour = "";

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
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: BoxDecoration(
                    color: bleuclair,
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text('Cours à supprimer :',
                    style: TextStyle(fontSize: 18, color: noirecrit)),
              ),
              Container(
                  margin: marge,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Jour',
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
                            keyboardType: TextInputType.emailAddress,
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
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: bleuclair,
                  ),
                  child: Text("Supprimer le cours"),
                  onPressed: () async {
                    quit = true;
                    supp();
                    _courtcontroll.clear();
                    _debutcontroll.clear();
                    _jourcontroll.clear();
                    setState(() {});
                  },
                ),
              ),
            ])))));
  }
}
