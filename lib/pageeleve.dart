// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path/path.dart';

import 'capitalize.dart';
import 'couleur.dart';

// ignore: must_be_immutable
class PageEleve extends StatefulWidget {
  var nom;
  var prenom;
  PageEleve({required this.nom, required this.prenom});
  @override
  _PageEleve createState() => _PageEleve(nom: nom, prenom: prenom);
}

var nbabsj = 0;
var nbabsi = 0;
var nbpresence = 0;

class _PageEleve extends State<PageEleve> {
  final String nom;
  final String prenom;

  var affichecours = false;
  _PageEleve({required this.nom, required this.prenom});
  var naissance = '';
  var tel1 = '';
  var tel2 = '';
  var sexe = '';
  var _image = '';
  var _sortie = '';
  var niveau;
  var couros;
  var mail1 = '';
  var mail2 = '';
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

  Map<dynamic, dynamic> map = {};
  List presence = [];

  List epvalide = [];

  void export() {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    var date = [];
    var motif = [];
    var stat = [];
    for (var i in presence) {
      date.add(i[0] + ' ' + i[1]);
      motif.add(i[2]);
    }
    stat.add('Nb absence injustifiée: ' + nbabsi.toString());
    stat.add('Nb absence justifiée: ' + nbabsj.toString());
    stat.add('Nb de présence: ' + nbpresence.toString());
    stat.add('Nb de cours: ' + presence.length.toString());
    sheetObject.appendRow(date);
    sheetObject.appendRow(motif);
    sheetObject.appendRow(stat);

    excel.encode().then((onValue) {
      File(join("/storage/emulated/0/Download/$nom$prenom.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
  }

  void enregistrerchangements() async {
    bddeleves.child(this.nom + this.prenom).update({'Epreuves': epvalide});
  }

  void changementdeniveau() async {
    var niv = await FirebaseFirestore.instance
        .collection('niveaux')
        .where('nom', isEqualTo: niveau)
        .get();

    var nbniveau = niv.docs[0]['ordre'];

    var newniv = await FirebaseFirestore.instance
        .collection('niveaux')
        .orderBy('ordre')
        .get();
    var nivoxtrouve = false;
    newniv.docs.forEach((res) {
      if (nivoxtrouve == false) {
        if (res.data()['ordre'] > nbniveau) {
          niveau = res.data()['nom'];
          nivoxtrouve = true;
        }
      }
    });
    epvalide = ['vide'];
    bddeleves
        .child(this.nom + this.prenom)
        .update({'Epreuves': epvalide, 'Niveau présumé': niveau});
    setState(() {});
  }

  void remplirmap() async {
    var result = await bddeleves.child(this.nom + this.prenom).once();
    map = Map.from(result.value['Présence']);
    if (result.value['Niveau présumé'] == null) {
      niveau = 'null';
    } else {
      niveau = capitalize(result.value['Niveau présumé']);
    }

    epvalide = List.from(result.value['Epreuves']);

    naissance = result.value['Date Naissance'];
    tel1 = result.value['Tel Portable'];
    tel2 = result.value['Tel Portable 2'];
    mail1 = result.value['Email 1'];
    mail2 = result.value['Email 2'];

    sexe = result.value['Sexe'];
    _image = result.value['Droit image'];
    _sortie = result.value['Autorisation sortie'];

    couros = List.from(result.value['Cours']);

    map.forEach((key, value) {
      if (key != 'vide') {
        var tabstring = key.split(" ");
        var horaire = tabstring[0];
        var date = tabstring[1] + '/' + tabstring[2];
        var laoupas = value;
        presence.add([date, horaire, laoupas]);
      }
    });
    for (var z in presence) {
      if (z[2] == 'absence non justifiée') {
        nbabsi++;
      }
      if (z[2] == 'présent') {
        nbpresence++;
      }
      if (z[2] == 'absence justifiée') {
        nbabsj++;
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    remplirmap();

    super.initState();
  }

  var bool = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: bleufonce,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      color: Colors.grey[300],
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: bleuclair,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  nom + " " + prenom + ' ($sexe)',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.blue),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Date de naissance: ' + naissance,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Droit image: ' + _image,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Autorisation de sortie: ' + _sortie,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    if (tel1 != ' ')
                                      Row(children: [
                                        Text(
                                          'Portable: ' + tel1,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: bleufonce,
                                            side: BorderSide(
                                                color: Colors.black, width: 1),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: Icon(Icons.sms),
                                          onPressed: () {
                                            launch('sms:' + tel1.toString());
                                          },
                                        )
                                      ]),
                                    if (tel2 != ' ')
                                      Row(children: [
                                        Text(
                                          'Portable 2: ' + tel2,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: bleufonce,
                                            side: BorderSide(
                                                color: Colors.black, width: 1),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: Icon(Icons.sms),
                                          onPressed: () {
                                            launch('sms:' + tel2.toString());
                                          },
                                        )
                                      ]),
                                    if (mail1 != null)
                                      Row(children: [
                                        Text(
                                          'Email 1: ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: bleufonce,
                                            side: BorderSide(
                                                color: Colors.black, width: 1),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: Icon(Icons.mail),
                                          onPressed: () {
                                            launch('mailto:' + mail1);
                                          },
                                        )
                                      ]),
                                    if (mail2 != null)
                                      Row(children: [
                                        Text(
                                          'Email 2: ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: bleufonce,
                                            side: BorderSide(
                                                color: Colors.black, width: 1),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: Icon(Icons.mail),
                                          onPressed: () {
                                            launch('mailto:' + mail2);
                                          },
                                        )
                                      ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: presence.isNotEmpty
                                ? ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 200,
                                    ),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: orange,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        margin: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 10),
                                        child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          30, 0, 30, 5),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: bleufonce,
                                                      side: BorderSide(
                                                          color: Colors.black,
                                                          width: 1),
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                    ),
                                                    child: Text(
                                                        'Exporter les présences en excel'),
                                                    onPressed: () {
                                                      export();
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            'Export terminé, fichier dans votre dossier "Download"'),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                  )),
                                              for (var i in presence)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            0, 5, 0, 5),
                                                        child: Text(
                                                          i[0] +
                                                              " " +
                                                              i[1] +
                                                              ": " +
                                                              i[2],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.0,
                                                          ),
                                                        )),
                                                  ],
                                                )
                                            ])))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          decoration: BoxDecoration(
                                              color: orange,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          margin: const EdgeInsets.fromLTRB(
                                              20, 20, 20, 0),
                                          child: Text(
                                            "Il n'y a pas encore eu de cours!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        )),
                                      ]),
                          ),
                          Container(
                              child: Text('Nb de présence: ' +
                                  nbpresence.toString() +
                                  '/' +
                                  presence.length.toString())),
                          Container(
                              child: Text("Nb d'absence injustifiée: " +
                                  nbabsi.toString() +
                                  '/' +
                                  presence.length.toString())),
                          Container(
                              child: Text("Nb d'absence justifiée: " +
                                  nbabsj.toString() +
                                  '/' +
                                  presence.length.toString())),
                          if (presence.length != 0)
                            Container(
                                child: Text("Taux de présence: " +
                                    (nbpresence / presence.length * 100)
                                        .round()
                                        .toString() +
                                    '%')),
                        ],
                      )),
                  SizedBox(height: 10),
                  Container(
                      child: (niveau != 'null' && niveau != null)
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('niveaux')
                                  .where('nom', isEqualTo: niveau)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: snapshot.data!.docs
                                        .map(
                                          (e) => Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          35, 5, 35, 5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              child: Text(
                                                                  'Niveau: ' +
                                                                      e['nom'] +
                                                                      ' (' +
                                                                      e['ordre']
                                                                          .toString() +
                                                                      ')',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          20.0)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      for (var i
                                                          in e['epreuve'])
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 5, 0, 5),
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 5, 0, 5),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey[
                                                                      300],
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Text(
                                                                i['epreuve'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                              Expanded(
                                                                  child: Text(
                                                                i['nombre']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                child:
                                                                    FlutterSwitch(
                                                                  activeColor:
                                                                      bleufonce,
                                                                  width: 60,
                                                                  height: 30,
                                                                  value: epvalide
                                                                      .contains(
                                                                          i['epreuve']),
                                                                  borderRadius:
                                                                      30.0,
                                                                  onToggle:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      if (epvalide
                                                                          .contains(
                                                                              i['epreuve'])) {
                                                                        epvalide
                                                                            .remove(i['epreuve']);
                                                                      } else {
                                                                        epvalide
                                                                            .add(i['epreuve']);
                                                                      }
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 0, 10, 5),
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                primary: Colors
                                                                    .green,
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            child: Text(
                                                                "Enregistrer les changements"),
                                                            onPressed: () {
                                                              enregistrerchangements();
                                                              setState(() {});
                                                            },
                                                          )),
                                                      if (e['epreuve'].length +
                                                              1 ==
                                                          epvalide.length)
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    5),
                                                            child:
                                                                ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  primary: Colors
                                                                      .yellow,
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              child: Text(
                                                                "Passer le prochain niveau",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              onPressed: () {
                                                                changementdeniveau();
                                                                setState(() {});
                                                              },
                                                            )),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          : Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.blue),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Cet élève n'a pas encore de niveau défini",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: bleuclair,
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: Text("Afficher les cours"),
                        onPressed: () {
                          if (affichecours == true) {
                            affichecours = false;
                          } else {
                            affichecours = true;
                          }

                          setState(() {});
                        },
                      )),
                  if (affichecours == true)
                    Container(
                        color: Colors.grey[300],
                        child: Column(
                          children: [
                            for (var i in couros)
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                                            color: Colors.black,
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
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Text(
                                          "sur le terrain " + i['Court séance'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ))
                ]),
          ),
        ));
  }
}
