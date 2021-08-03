import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:racpresence/main.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:racpresence/variables.dart';
import 'appel.dart';

class Coursdujour extends StatefulWidget {
  Coursdujour({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Coursdujour createState() => _Coursdujour(datos: title);
}

class _Coursdujour extends State<Coursdujour> {
  final String datos;
  _Coursdujour({required this.datos});

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
  var currentUser = FirebaseAuth.instance.currentUser;
  List coursoupas = [];
  var tempfin = "";

  var largeur = 85.0;
  final List horaire = [
    "8:00",
    "8:30",
    "9:00",
    "9:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00",
    "20:30",
    "21:00",
    "21:30",
  ];
  final List horaire2 = [
    "8:00",
    "8:30",
    "9:00",
    "9:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00",
    "20:30",
    "21:00",
    "21:30",
    "22:00",
  ];

  List tabterrain = [];
  List tab = [];
  List terrain = [];
  var taille = 0;
  var titre;
  final firerefe = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  var hauteurcaseterrain;
  var paddinghaut;
  var hauteurhoraire;
  var _iduser = "";
  @override
  void initState() {
    super.initState();
    mapJour(datos);
    hauteurcaseterrain = 60.0;
    paddinghaut = 10.0;
    hauteurhoraire = 30.0;
  }

  var ordrecourt = [];
  void mapJour(String jour) async {
    Map profcouleur = {};
    var tabstring = datos.split(" ");
    var jour = tabstring[0];

    var col = await firerefe.collection("users").get();
    col.docs.forEach((res) {
      var nomuser = res.data()['Nom'];
      nomuser = nomuser.toUpperCase();
      var _id = nomuser + ' ' + res.data()['Prénom'];
      Color couleurcase = Color(res.data()['couleurcase']);
      Color couleurecriture = Color(res.data()['couleurecriture']);
      profcouleur[_id] = [couleurcase, couleurecriture];
    });

    var result =
        await bddcours.orderByChild("Jour séance").equalTo(jour).once();
    Map<dynamic, dynamic> mapresult = result.value;
    await Future.delayed(
        const Duration(
          seconds: 0,
        ),
        () {});
    if (result.value != null) {
      mapresult.forEach((key, value) {
        var court = value['Court séance'];
        var debut = value['Début séance'];
        var fin = value['Fin séance'];
        var prof = value['Professeur séance'];
        var temp = value['Temp'];
        var fait = false;
        if (temp[0] == tabstring[1]) {
          fait = true;
        }
        if (!terrain.contains(court)) terrain.add(court);
        tab.add({
          'terrain': court,
          'debut': debut,
          'fin': fin,
          'prof': prof,
          'fait': fait,
        });
      });
    }

    bool boo = false;
    for (var i in terrain) {
      List terr = [];

      var nbcase = 0.0;
      var tempdebut = "";
      var tempfin = "";
      var tempprof = "";
      var tempfait = false;
      Color rouge = Color(4294901760);
      Color blanc = Color(4294967295);
      var couleur = [rouge, blanc];

      for (var h in horaire) {
        if (tempfin == "") {
          boo = false;
          for (var j in tab) {
            if (j['debut'] == h) {
              if (j['terrain'] == i) {
                nbcase = nbcase + 1.0;
                tempdebut = h;
                tempfin = j['fin'];
                tempprof = j['prof'];
                tempfait = j['fait'];

                if (profcouleur.containsKey(tempprof)) {
                  couleur = profcouleur[tempprof];
                } else {
                  couleur = [rouge, blanc];
                }

                boo = true;
                break;
              }
            }
          }
          if (boo != true) {
            terr.add('vide');
          }
        } else {
          if (tempfin == h) {
            terr.add([nbcase, tempprof, tempdebut, couleur, tempfait]);
            tempfin = "";
            nbcase = 0.0;
            boo = false;
            for (var j in tab) {
              if (j['debut'] == h) {
                if (j['terrain'] == i) {
                  tempdebut = h;
                  nbcase = nbcase + 1.0;
                  tempfin = j['fin'];
                  tempprof = j['prof'];
                  tempfait = j['fait'];
                  if (profcouleur.containsKey(tempprof)) {
                    couleur = profcouleur[tempprof];
                  } else {
                    couleur = [rouge, blanc];
                  }

                  boo = true;
                  break;
                }
              }
            }
            if (boo != true) {
              terr.add('vide');
            }
          } else {
            nbcase = nbcase + 1.0;
          }
        }
      }
      ordrecourt.add(i);
      tabterrain.add({
        'terrain': i,
        'horaire': []..addAll(terr),
      });
    }
    taille = tabterrain.length;
    ordrecourt.sort((a, b) => a.toString().compareTo(b.toString()));

    var maptemp = [];
    for (var o in ordrecourt) {
      for (var i in tabterrain) {
        if (o == i['terrain']) {
          maptemp.add(i);
        }
      }
    }
    tabterrain = maptemp;
    setState(() {});
    quit = true;
  }

  bool quit = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: blancfond,
      appBar: new AppBar(
        centerTitle: true,
        leading: quit == true
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                    (Route<dynamic> route) => false,
                  );
                })
            : IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {}),
        title: new Text(widget.title),
        backgroundColor: bleufonce,
      ),
      body: Column(children: [
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: largeur),
                            for (var i in horaire2)
                              Container(
                                  height: hauteurhoraire,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  width: largeur,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        i,
                                        style: TextStyle(
                                          color: noirecrit,
                                        ),
                                        textAlign: TextAlign.center,
                                      ))),
                          ],
                        ),
                        Flexible(
                            fit: FlexFit.loose,
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(children: [
                                      for (var z in tabterrain)
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  height: hauteurcaseterrain,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[400],
                                                  ),
                                                  width: largeur * 1.5,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        "Terrain " +
                                                            z['terrain'],
                                                        style: TextStyle(
                                                          color: noirecrit,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                  )),
                                              for (var j in z['horaire'])
                                                Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(0, 5, 0, 5),
                                                    height: hauteurcaseterrain,
                                                    child: j is List
                                                        ? Container(
                                                            child: j[4] == true
                                                                ? Container(
                                                                    width:
                                                                        largeur *
                                                                            j[0],
                                                                    child: Align(
                                                                        alignment: Alignment.center,
                                                                        child: ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            onPrimary:
                                                                                j[3][1],
                                                                            primary:
                                                                                j[3][0],
                                                                            side:
                                                                                BorderSide(color: Colors.green, width: 4),
                                                                            elevation:
                                                                                0,
                                                                            minimumSize:
                                                                                Size(largeur * j[0], hauteurcaseterrain),
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          ),
                                                                          onPressed: _iduser == j[1]
                                                                              ? () {
                                                                                  setState(() {
                                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                                        builder: (context) => Appel(
                                                                                              title: datos,
                                                                                              datos: datos,
                                                                                              terrain: z['terrain'],
                                                                                              heure: j[2],
                                                                                            )));
                                                                                  });
                                                                                }
                                                                              : admin_ == true
                                                                                  ? () {
                                                                                      setState(() {
                                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                                            builder: (context) => Appel(
                                                                                                  title: datos,
                                                                                                  datos: datos,
                                                                                                  terrain: z['terrain'],
                                                                                                  heure: j[2],
                                                                                                )));
                                                                                      });
                                                                                    }
                                                                                  : () {},
                                                                          child: Text(
                                                                              j[1],
                                                                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                                                              textAlign: TextAlign.center),
                                                                        )),
                                                                  )
                                                                : Container(
                                                                    width:
                                                                        largeur *
                                                                            j[0],
                                                                    child: Align(
                                                                        alignment: Alignment.center,
                                                                        child: ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            onPrimary:
                                                                                j[3][1],
                                                                            primary:
                                                                                j[3][0],
                                                                            side:
                                                                                BorderSide(color: Colors.black, width: 2),
                                                                            elevation:
                                                                                0,
                                                                            minimumSize:
                                                                                Size(largeur * j[0], hauteurcaseterrain),
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          ),
                                                                          onPressed: _iduser == j[1]
                                                                              ? () {
                                                                                  setState(() {
                                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                                        builder: (context) => Appel(
                                                                                              title: datos,
                                                                                              datos: datos,
                                                                                              terrain: z['terrain'],
                                                                                              heure: j[2],
                                                                                            )));
                                                                                  });
                                                                                }
                                                                              : admin_ == true
                                                                                  ? () {
                                                                                      setState(() {
                                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                                            builder: (context) => Appel(
                                                                                                  title: datos,
                                                                                                  datos: datos,
                                                                                                  terrain: z['terrain'],
                                                                                                  heure: j[2],
                                                                                                )));
                                                                                      });
                                                                                    }
                                                                                  : () {},
                                                                          child: Text(
                                                                              j[1],
                                                                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                                                              textAlign: TextAlign.center),
                                                                        )),
                                                                  ))
                                                        : Container(
                                                            color: Colors
                                                                .grey[400],
                                                            child: Container(
                                                              decoration:
                                                                  DottedDecoration(
                                                                shape:
                                                                    Shape.line,
                                                                linePosition:
                                                                    LinePosition
                                                                        .left,
                                                              ),
                                                              width: largeur,
                                                              child: Center(
                                                                child: Text(
                                                                  "- " +
                                                                      z['terrain'] +
                                                                      " -",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        noirecrit,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            )))
                                            ]),
                                    ]),
                                  ]),
                            )),
                      ])
                ]))
      ]),
    );
  }
}
