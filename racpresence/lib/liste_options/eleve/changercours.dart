
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';

class CoursEleve extends StatefulWidget {
  CoursEleve({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CoursEleve createState() => _CoursEleve();
}

final admin = FirebaseAuth.instance;
var listeprenom = [];
var listenom = [];
var nom = '';
var prenom = '';

class _CoursEleve extends State<CoursEleve> {
  bool elevetrouve = false;

  TextEditingController _searchController = TextEditingController();
  var couros = [];
  final bddeleves = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('eleves');
  final bddcours = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('cours');
  var _courtcontroll = TextEditingController();
  String _court = "";
  var _jourcontroll = TextEditingController();
  String _jour = "";
  var _heurecontroll = TextEditingController();
  String _heure = "";

  void supprimercours(var courtos, var heuros, var jouros) async {
    var cours = await bddcours.child(jouros + heuros + courtos).once();
    var nomlist = List.from(cours.value['Nom Eleve']);
    var prenomlist = List.from(cours.value['Prénom Eleve']);
    nomlist.remove(nom);
    prenomlist.remove(prenom);
    bddcours
        .child(capitalize(_jour) + _heure + convertcourt(_court))
        .update({'Nom Eleve': nomlist, 'Prénom Eleve': prenomlist});
    var index = 0;
    for (var i in couros) {
      if (i['Court séance'] == courtos &&
          i['Début séance'] == heuros &&
          i['Jour séance'] == jouros) {
        couros.removeAt(index);
        break;
      }
      index++;
    }
    bddeleves.child(nom + prenom).update({'Cours': couros});
    setState(() {});
  }

  void ajoutercours() async {
    var cours = await bddcours
        .child(capitalize(_jour) + _heure + convertcourt(_court))
        .once();
    var nomlist;
    var prenomlist;
    if (cours.value['Nom Eleve'] == null) {
      nomlist = [];
      prenomlist = [];
    } else {
      nomlist = List.from(cours.value['Nom Eleve']);
      prenomlist = List.from(cours.value['Prénom Eleve']);
    }
    nomlist.add(nom);
    prenomlist.add(prenom);
    bddcours
        .child(capitalize(_jour) + _heure + convertcourt(_court))
        .update({'Nom Eleve': nomlist, 'Prénom Eleve': prenomlist});

    couros.add({
      'Court séance': cours.value['Court séance'],
      'Début séance': cours.value['Début séance'],
      'Fin séance': cours.value['Fin séance'],
      'Jour séance': cours.value['Jour séance'],
      'Nom Prof Séance': cours.value['Nom Prof Séance'],
      'Prénom Prof Séance': cours.value['Prénom Prof Séance'],
      'Professeur séance': cours.value['Professeur séance'],
    });
    bddeleves.child(nom + prenom).update({'Cours': couros});
    setState(() {});
  }

  var listos = [];
  void remplirliste() async {
    var snapnom = await bddeleves
        .orderByChild("Nom")
        .equalTo(capitalize(_searchController.text))
        .once();

    if (snapnom.value != null) {
      Map<dynamic, dynamic> mapnom = snapnom.value;
      var listemp = [];
      mapnom.forEach((key, value) {
        listemp.add([value['Nom'], value['Prénom']]);
      });
      listenom = listemp;
    }
    var snapprenom = await bddeleves
        .orderByChild("Prénom")
        .equalTo(capitalize(_searchController.text))
        .once();
    if (snapprenom.value != null) {
      Map<dynamic, dynamic> mapprenom = snapprenom.value;
      var listemp = [];
      mapprenom.forEach((key, value) {
        listemp.add([value['Nom'], value['Prénom']]);
      });
      listeprenom = listemp;
    }
    listos = listenom + listeprenom;
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  var source;
  bool affiche = false;

  Widget build(BuildContext context) {
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
            child: elevetrouve == false
                ? Column(children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: bleufonce,
                                ),
                                hintText: 'Chercher nom ou prénom',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: bleufonce, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: bleuclair,
                              ),
                              child: Icon(Icons.search),
                              onPressed: () async {
                                setState(() {
                                  remplirliste();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      //height: MediaQuery.of(context).size.height - 250,
                      fit: FlexFit.loose,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (var i in listos)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: bleuclair,
                                      ),
                                      onPressed: () async {
                                        nom = i[0];
                                        prenom = i[1];
                                        var result = await bddeleves
                                            .child(nom + prenom)
                                            .once();
                                        setState(() {
                                          couros =
                                              List.from(result.value['Cours']);
                                          elevetrouve = true;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(i[0] + " ",
                                                style: TextStyle(
                                                    color: noirecrit,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            child: Text(i[1],
                                                style: TextStyle(
                                                  color: noirecrit,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ])
                : Center(
                    child: ListView(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: bleuclair,
                        ),
                        onPressed: () {
                          elevetrouve = false;
                          setState(() {});
                        },
                        child: Text('Arrêter avec cet élève'),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: bleuclair,
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))
                              // Red border with the width is equal to 5
                              ),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            '$nom $prenom',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: noirecrit, fontSize: 18),
                          )),
                      Column(children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))
                              // Red border with the width is equal to 5
                              ),
                          child: Text('Ajouter un cours:',
                              style: TextStyle(color: noirecrit, fontSize: 18)),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))
                              // Red border with the width is equal to 5
                              ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(children: [
                                  Expanded(
                                      child: Text('Jour: ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: noirecrit, fontSize: 18))),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: TextField(
                                        controller: _jourcontroll,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: bleufonce, width: 2.0),
                                          ),
                                          hintText: "Jour",
                                          hintStyle: TextStyle(fontSize: 20),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 12, 10, 12),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _jour = value.trim();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(children: [
                                  Expanded(
                                      child: Text(
                                          'Heure début (format hh:mm): ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: noirecrit, fontSize: 18))),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: TextField(
                                        controller: _heurecontroll,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: bleufonce, width: 2.0),
                                          ),
                                          hintText: "Horaire début cours",
                                          hintStyle: TextStyle(fontSize: 20),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 12, 10, 12),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _heure = value.trim();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(children: [
                                  Expanded(
                                    child: Text('Court: (pour le 4B -> 04B)',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: noirecrit, fontSize: 18)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: TextField(
                                        controller: _courtcontroll,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: bleufonce, width: 2.0),
                                          ),
                                          hintText: "Court",
                                          hintStyle: TextStyle(fontSize: 20),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 12, 10, 12),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _court = value.trim();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: bleuclair,
                                ),
                                child: Text('Ajouter le cours'),
                                onPressed: () {
                                  ajoutercours();
                                },
                              )
                            ],
                          ),
                        ),
                      ]),
                      Container(
                          child: Column(
                        children: [
                          for (var i in couros)
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 1, color: Colors.blue),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))
                                  // Red border with the width is equal to 5
                                  ),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Séance: ' +
                                            i['Jour séance'] +
                                            " de " +
                                            i['Début séance'] +
                                            " à " +
                                            i['Fin séance'],
                                        style: TextStyle(
                                          color: noirecrit,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Avec " +
                                            i['Prénom Prof Séance'] +
                                            " " +
                                            i['Nom Prof Séance'],
                                        style: TextStyle(
                                          color: noirecrit,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        "sur le terain " + i['Court séance'],
                                        style: TextStyle(
                                          color: noirecrit,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              titlePadding:
                                                  const EdgeInsets.all(0.0),
                                              contentPadding:
                                                  const EdgeInsets.all(0.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              content: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                height: 150,
                                                child: Column(children: [
                                                  Container(
                                                      child: Text(
                                                    'Supprimer le cours "' +
                                                        i['Jour séance'] +
                                                        " de " +
                                                        i['Début séance'] +
                                                        " à " +
                                                        i['Fin séance'] +
                                                        ' sur le court ' +
                                                        i['Court séance'] +
                                                        '"',
                                                    style: TextStyle(
                                                      color: noirecrit,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(0, 10, 0, 15),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.red,
                                                        side: BorderSide(
                                                            color: Colors.black,
                                                            width: 1),
                                                        elevation: 0,
                                                        fixedSize:
                                                            Size(150, 30),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      child: Text('Supprimer'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        supprimercours(
                                                            i['Court séance'],
                                                            i['Début séance'],
                                                            i['Jour séance']);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            );
                                          });

                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        side: BorderSide(
                                            color: Colors.black, width: 1),
                                        elevation: 0,
                                        fixedSize: Size(30, 30),
                                        shape: CircleBorder()),
                                    child: Icon(Icons.close),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ))
                    ],
                  ))));
  }
}
