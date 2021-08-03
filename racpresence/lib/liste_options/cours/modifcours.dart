import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';

class ModifCours extends StatefulWidget {
  ModifCours({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ModifCours createState() => _ModifCours();
}

var currentUser = FirebaseAuth.instance.currentUser;
var fireref = FirebaseFirestore.instance.collection('users');

class _ModifCours extends State<ModifCours> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return bleufonce;
  }

  final bddcours = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('cours');
  var quit = false;
  bool booltemp = false;
  bool pascours = false;

  void modification() async {
    _jour = capitalize(_jour);
    _court = convertcourt(_court);
    _court2 = convertcourt(_court2);
    _jour2 = capitalize(_jour2);

    var coursdeplace =
        await bddcours.child(_jour + _debut + convertcourt(_court)).once();
    if (coursdeplace.value != null) {
      pascours = false;

      var courtos = coursdeplace.value['Court séance'];
      var prenomos = coursdeplace.value['Prénom Prof Séance'];
      var nomos = coursdeplace.value['Nom Prof Séance'];
      var debutos = coursdeplace.value['Début séance'];
      var fintos = coursdeplace.value['Fin séance'];
      var profos = coursdeplace.value['Professeur séance'];
      var jouros = coursdeplace.value['Jour séance'];
      var nomeleve = coursdeplace.value['Nom Eleve'];
      var prenomeleve = coursdeplace.value['Prénom Eleve'];
      var tempos = coursdeplace.value['Temp'];

      var user = await fireref
          .where("Nom", isEqualTo: nomos)
          .where('Prénom', isEqualTo: prenomos)
          .get();
      var coursmort = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.docs[0].id)
          .collection('cours')
          .where('Jour séance', isEqualTo: jouros)
          .where('Court séance', isEqualTo: courtos)
          .where('Début séance', isEqualTo: debutos)
          .get();
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.docs[0].id)
          .collection('cours')
          .doc(coursmort.docs[0].id)
          .delete();

      await bddcours.child(_jour + _debut + _court).remove();

      if (Prof == true) {
        nomos = capitalize(_nom);
        prenomos = capitalize(_prenom);
        profos = capitalize(_prenom) + ' ' + _nom.toUpperCase();
      }
      if (Jour == true) {
        courtos = _court2;
        debutos = _debut2;
        fintos = _fin2;
        jouros = _jour2;
      }
      print('courtos: ' + courtos.toString());
      print('debut: ' + debutos.toString());
      print('fin: ' + fintos.toString());
      print('jour: ' + jouros.toString());
      await bddcours.child(jouros + debutos + courtos).update({
        "Court séance": courtos,
        "Prénom Prof Séance": prenomos,
        "Nom Prof Séance": nomos,
        "Début séance": debutos,
        "Fin séance": fintos,
        "Professeur séance": profos,
        "Jour séance": jouros,
        "Nom Eleve": nomeleve,
        "Prénom Eleve": prenomeleve,
        "Temp": tempos,
      });
      var user2 = await fireref
          .where("Nom", isEqualTo: nomos)
          .where('Prénom', isEqualTo: prenomos)
          .get();
      FirebaseFirestore.instance
          .collection('users')
          .doc(user2.docs[0].id)
          .collection('cours')
          .add({
        'Début séance': debutos,
        'Court séance': courtos,
        'Fin séance': fintos,
        'Jour séance': jouros,
      });
    }
    pascours = true;
    setState(() {});
  }

  bool Jour = true;
  bool Prof = false;
  var _courtcontroll = TextEditingController();
  String _court = "";
  var _debutcontroll = TextEditingController();
  String _debut = "";
  var _jourcontroll = TextEditingController();
  String _jour = "";
  var _courtcontroll2 = TextEditingController();
  String _court2 = "";
  var _debutcontroll2 = TextEditingController();
  String _debut2 = "";
  var _fincontroll2 = TextEditingController();
  String _fin2 = "";
  var _jourcontroll2 = TextEditingController();
  String _jour2 = "";
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
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: BoxDecoration(
                        color: bleuclair,
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text('Cours à déplacer :',
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
                  SizedBox(height: 15),
                  Container(
                    margin: marge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Modifier:'),
                        Row(
                          children: [
                            Text('Horaire : '),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: Jour,
                              onChanged: (bool? value) {
                                setState(() {
                                  Jour = value!;
                                });
                              },
                            ),
                            Text('Prof : '),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: Prof,
                              onChanged: (bool? value) {
                                setState(() {
                                  Prof = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: BoxDecoration(
                        color: bleuclair,
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child:
                        Text('Nouveau cours :', style: TextStyle(fontSize: 18, color: noirecrit)),
                  ),
                  if (Jour == true)
                    Column(children: [
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
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    controller: _jourcontroll2,
                                    decoration: InputDecoration(
                                      hintText: 'Jour',
                                      focusedBorder: new UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bleufonce),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _jour2 = value.trim();
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
                                  controller: _debutcontroll2,
                                  decoration: InputDecoration(
                                    hintText: 'Début',
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide: BorderSide(color: bleufonce),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _debut2 = value.trim();
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
                                  controller: _fincontroll2,
                                  decoration: InputDecoration(
                                    hintText: 'Fin du cours',
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide: BorderSide(color: bleufonce),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _fin2 = value.trim();
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
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _courtcontroll2,
                                    decoration: InputDecoration(
                                      hintText: 'Court',
                                      focusedBorder: new UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bleufonce),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _court2 = value.trim();
                                      });
                                    },
                                  ),
                                ),
                              ])),
                    ]),
                  if (Prof == true)
                    Column(children: [
                      Container(
                          margin: marge,
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    'Nom prof',
                                    style: TextStyle(fontSize: 16, color: noirecrit),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  width: 175,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    controller: _nomcontroll,
                                    decoration: InputDecoration(
                                      hintText: 'Nom prof',
                                      focusedBorder: new UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bleufonce),
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
                                    'Prénom prof',
                                    style: TextStyle(fontSize: 16, color: noirecrit),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  width: 175,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _prenomcontroll,
                                    decoration: InputDecoration(
                                      hintText: 'Prénom prof',
                                      focusedBorder: new UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bleufonce),
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
                    ]),
                  if (pascours == true) SizedBox(height: 30),
                  if (pascours == true)
                    Container(
                      child:
                          Text("Il n'y a pas de cours aux paramètres indiqués"),
                    ),
                  if (Prof != false || Jour != false)
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: bleuclair,
                        ),
                        child: Text("Déplacer le cours"),
                        onPressed: () async {
                          quit = true;
                          modification();
                          _courtcontroll.clear();
                          _debutcontroll.clear();
                          _jourcontroll.clear();
                          _nomcontroll.clear();
                          _prenomcontroll.clear();
                          _courtcontroll2.clear();
                          _debutcontroll2.clear();
                          _fincontroll2.clear();
                          _jourcontroll2.clear();
                          setState(() {});
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}
