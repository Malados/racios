import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racpresence/couleur.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'main.dart';

class Appel extends StatefulWidget {
  Appel(
      {Key? key,
      required this.title,
      required this.terrain,
      required this.datos,
      required this.heure})
      : super(key: key);

  final String title;
  final String terrain;
  final String datos;
  final String heure;

  @override
  _Appel createState() => _Appel(datos: datos, heure: heure, terrain: terrain);
}

List justif = ['non justifiée', 'justifiée'];

class _Appel extends State<Appel> {
  final String datos;
  final String heure;
  final String terrain;

  // receive data from the FirstScreen as a parameter
  _Appel({required this.datos, required this.heure, required this.terrain});

  final firerefe = FirebaseFirestore.instance;
  bool quit = false;
  @override
  void initState() {
    super.initState();
    listeleves(datos);
  }

  List<int> nbprof = [];
  List numterrain = [];
  List nomjoueurs = [];
  var jourcours;
  var court = '';
  var jouros = DateTime.now();
  var profid = '';
  List tabprof = [];
  List prof = [];
  List profpresent = [];
  String multisms = "";
  Map<dynamic, dynamic> mapresult = {};
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
  final abs = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference();
  void presence() async {
    var tabstring = datos.split(" ");
    var jouros = tabstring[1];

    var tabtemp = [jouros];
    var jour = tabstring[0];

    for (var i in nomjoueurs) {
      var docref = await bddeleves.child(i['nom'] + i['prenom']).once();
      var map = docref.value['Présence'];

      var just;
      if (i['presence'] == false) {
        just = "absence " + i['justification'];
        if (tabtemp.contains(i['nom'] + i['prenom'])) {
          tabtemp.remove(i['nom'] + i['prenom']);
        }
        if (i['justification'] == 'non justifiée') {
          if (docref.value['NbAbs'] == 0) {
            bddeleves.child(i['nom'] + i['prenom']).update({
              'NbAbs': 1,
              'ListeAbsence': [heure + ' ' + jouros + ' ' + tabstring[3]]
            });
          } else {
            var listabsence = List.from(docref.value['ListeAbsence']);
            var nbabs = docref.value['NbAbs'];
            if (listabsence
                    .contains(heure + ' ' + jouros + ' ' + tabstring[3]) ==
                false) {
              listabsence.add(heure + ' ' + jouros + ' ' + tabstring[3]);
              nbabs++;
            }
            bddeleves
                .child(i['nom'] + i['prenom'])
                .update({'NbAbs': nbabs, 'ListeAbsence': listabsence});

            if (nbabs >= 3) {
              var list3abs = await abs.child('3abs').once();
              var listabsence2 = List.from(list3abs.value);
              listabsence2.add(i['nom'] + i['prenom']);
              abs.update({'3abs': listabsence2});
            }
          }
        }
      } else {
        if (docref.value['NbAbs'] != 0) {
          var listabsence = List.from(docref.value['ListeAbsence']);
          var nbabs = docref.value['NbAbs'];
          if (listabsence.contains(heure + ' ' + jouros + ' ' + tabstring[3])) {
            listabsence.remove(heure + ' ' + jouros + ' ' + tabstring[3]);
            nbabs--;
            bddeleves
                .child(i['nom'] + i['prenom'])
                .update({'NbAbs': nbabs, 'ListeAbsence': listabsence});

            if (nbabs == 2) {
              var list3abs = await abs.child('3abs').once();
              var listabsence2 = List.from(list3abs.value);
              listabsence2.remove(i['nom'] + i['prenom']);
              abs.update({'3abs': listabsence2});
            }
          }
        }
        tabtemp.add(i['nom'] + i['prenom']);
        just = "présent";
      }

      bddeleves
          .child(i['nom'] + i['prenom'])
          .child('Présence')
          .update({heure + ' ' + jouros + ' ' + tabstring[3]: just});

      if (map.containsKey('vide')) {
        bddeleves
            .child(i['nom'] + i['prenom'])
            .child('Présence')
            .child('vide')
            .remove();
      }
    }
    bddcours.child(jour + heure + terrain).update({'Temp': tabtemp});
  }

  var jourojd;
  Future listeleves(String datos) async {
    var tabstring = datos.split(" ");
    var jour = tabstring[0];
    var result = await bddcours.child(jour + heure + terrain).once();
    var temptab = List.from(result.value['Temp']);
    var key = [];
    var tabnom = List.from(result.value['Nom Eleve']);
    var tabprenom = List.from(result.value['Prénom Eleve']);
    profid = result.value['Prénom Prof Séance'] +
        ' ' +
        result.value['Nom Prof Séance'];
    court = 'Terrain ' + result.value['Court séance'];
    for (var i in tabnom) {
      var id = {
        'nom': i,
        'prenom': tabprenom[tabnom.indexOf(i)],
      };
      key.add(id);
    }
    var resultmap = [];
    for (var i in key) {
      var resulteleve = await bddeleves.child(i['nom'] + i['prenom']).once();
      Map<dynamic, dynamic> mapvalue = resulteleve.value;

      resultmap.add({
        'Nom': mapvalue['Nom'],
        'Prénom': mapvalue['Prénom'],
        'Tel Portable': mapvalue['Tel Portable'],
        'Tel Portable 2': mapvalue['Tel Portable 2'],
        'Court séance': i['court'],
        'NbAbs': mapvalue['NbAbs'],
      });
    }
    resultmap.forEach((res) {
      if (res['Tel Portable'] != ' ') {
        multisms = multisms + res['Tel Portable'] + ',';
      } else if (res['Tel Portable 2'] != ' ') {
        multisms = multisms + res['Tel Portable 2'] + ',';
      }
      var jouros = tabstring[1];
      var tbool = false;
      if (temptab.contains(jouros)) {
        if (temptab.contains(res['Nom'] + res['Prénom'])) {
          tbool = true;
        }
      }
      nomjoueurs.add({
        'prenom': res['Prénom'],
        'nom': res['Nom'],
        'presence': tbool,
        'justification': 'non justifiée',
        'numero1': res['Tel Portable'],
        'numero2': res['Tel Portable 2'],
        'NbAbs': res['NbAbs'],
      });
    });
    setState(() {});
    quit = true;
  }

  bool valuefirst = false;
  bool valuesecond = false;
  var selected;

  var tailleterrain = 100.0;

  bool ajoutjoueur = false;

  var a = "";

  void getProf(String nom) {
    setState(() {
      nbprof.removeLast();
      for (var i in prof) if (i['nom'] == nom) prof.add(i);
    });
  }

  void changepresence(joueur) {
    setState(() {
      if (joueur['presence'] == false) joueur['presence'] = true;
      if (joueur['presence'] == true) joueur['presence'] = false;
    });
  }

  void changetel(joueur) {
    setState(() {});
  }

  void ajoutjoueurlist(String nom) {
    setState(() {
      nomjoueurs.add(nom);
    });
  }

  void cherchejoueur() {
    setState(() {
      ajoutjoueur = true;
    });
  }

  void chercheplusjoueur() {
    setState(() {
      ajoutjoueur = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleufonce,
        leading: quit == true
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              )
            : IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {},
              ),
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          presence();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route<dynamic> route) => false,
          );
        },
        label: Text('Valider'),
        icon: Icon(Icons.check),
      ),
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                      // Red border with the width is equal to 5
                      ),
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  bottomLeft: Radius.circular(18))),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            "Terrain : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: noirecrit,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                            child: Text(
                              court,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: noirecrit,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                      // Red border with the width is equal to 5
                      ),
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  bottomLeft: Radius.circular(18))),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            "Prof : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: noirecrit,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                            child: Text(
                              profid,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: noirecrit,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                      // Red border with the width is equal to 5
                      ),
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Text(
                              "Joueurs : ",
                              style: TextStyle(
                                color: noirecrit,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                            child: Icon(Icons.message_rounded),
                            style: ElevatedButton.styleFrom(
                              primary: bleuclair,
                              side: BorderSide(color: Colors.black, width: 1),
                              elevation: 0,
                              fixedSize: Size(20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              launch('sms:' + multisms);
                            },
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      Column(
                        children: nomjoueurs.map((joueurs) {
                          var idjoueur =
                              joueurs['nom'] + " " + joueurs['prenom'];
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 2, color: noirecrit),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))
                                // Red border with the width is equal to 5
                                ),
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    child: FlutterSwitch(
                                      activeColor: bleufonce,
                                      width: 60,
                                      height: 30,
                                      value: joueurs['presence'],
                                      borderRadius: 30.0,
                                      onToggle: (val) {
                                        setState(() {
                                          joueurs['presence'] = val;
                                        });
                                      },
                                    ),
                                  ),
                                  if (joueurs['NbAbs'] > 2)
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Text(
                                          idjoueur + (' (3 abs)'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: noirecrit,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (joueurs['NbAbs'] < 3)
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Text(
                                          idjoueur,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: noirecrit,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: joueurs['presence'] == false
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                              Container(
                                                child: DropdownButton(
                                                  hint: Text('Justification'),
                                                  value:
                                                      joueurs['justification'],
                                                  onChanged: (newvalue) {
                                                    setState(() {
                                                      joueurs['justification'] =
                                                          newvalue;
                                                    });
                                                  },
                                                  items:
                                                      justif.map((valueItem) {
                                                    return DropdownMenuItem(
                                                      value: valueItem,
                                                      child: Text(valueItem),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(0, 0, 8, 0),
                                                      child: joueurs[
                                                                  'numero1'] !=
                                                              " "
                                                          ? ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary:
                                                                    bleuclair,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1),
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                              ),
                                                              child: Icon(
                                                                  Icons.sms),
                                                              onPressed: () {
                                                                launch('sms:' +
                                                                    joueurs['numero1']
                                                                        .toString());
                                                              },
                                                            )
                                                          : ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .white,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1),
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                              ),
                                                              child: Text(''),
                                                              onPressed: () {},
                                                            )),
                                                  Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(0, 0, 8, 0),
                                                      child: joueurs[
                                                                  'numero2'] !=
                                                              " "
                                                          ? ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary:
                                                                    bleuclair,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1),
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                              ),
                                                              child: Icon(
                                                                  Icons.sms),
                                                              onPressed: () {
                                                                launch('sms:' +
                                                                    joueurs['numero2']
                                                                        .toString());
                                                              },
                                                            )
                                                          : ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .white,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1),
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                              ),
                                                              child: Text(''),
                                                              onPressed: () {},
                                                            )),
                                                ],
                                              ),
                                            ])
                                      : Container()),
                            ]),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 60)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
