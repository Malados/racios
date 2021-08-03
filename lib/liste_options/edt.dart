import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';

class Edt extends StatefulWidget {
  Edt({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Edt createState() => _Edt();
}

class _Edt extends State<Edt> {
  @override
  void initState() {
    chargement();
    //if (edt == true) {
    afficheedt();
    //}
    super.initState();
  }

  var Prenom;
  var Nom;
  var edt;
  var currentUser = FirebaseAuth.instance.currentUser;
  var fireref = FirebaseFirestore.instance.collection('users');
  void chargement() async {
    var user = await fireref.where("uid", isEqualTo: currentUser!.uid).get();
    user.docs.forEach((res) {
      Prenom = res.data()['Prénom'];
      Nom = res.data()['Nom'];
      edt = res.data()['edt'];
    });
    setState(() {});
  }

  var id = '';
  final auth = FirebaseAuth.instance;
  var hauteurcaseterrain = 60.0;
  var paddinghaut = 10.0;
  var hauteurhoraire = 40.0;
  var largeur = 80.0;
  List jour = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];
  final List horaire = [
    "08:00",
    "08:30",
    "09:00",
    "09:30",
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
    "08:00",
    "08:30",
    "09:00",
    "09:30",
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
  final bddcours = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('cours');
  var mapcours = [];
  void afficheedt() async {
    var listemap = [];
    var user = await fireref.where("uid", isEqualTo: currentUser!.uid).get();
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.docs[0].id)
        .collection('cours')
        .get();
    var listjour = [];

    result.docs.forEach((res) {
      if (!listjour.contains(res.data()['Jour séance'])) {
        listjour.add(res.data()['Jour séance']);
      }
      listemap.add({
        'Jour séance': res.data()['Jour séance'],
        'Début séance': res.data()['Début séance'],
        'Fin séance': res.data()['Fin séance'],
        'Court séance': res.data()['Court séance'],
      });
    });
    for (var i in jour) {
      if (listjour.contains(i)) {
        var taille = 0;
        var listcours = [];
        var tempfin = '';
        for (var h in horaire) {
          var vidos = true;
          for (var d in listemap) {
            if (tempfin != '') {
              vidos = false;
              if (h == tempfin) {
                listcours.add([taille, d['Court séance']]);
                tempfin = '';
                var vide = false;
                for (var lm in listemap) {
                  if (lm['Début séance'] == h) {
                    taille = 1;
                    tempfin = lm['Fin séance'];
                    vide = true;
                    break;
                  }
                }
                if (vide == false) {
                  vidos = true;
                }
                break;
              } else {
                taille++;
              }
              break;
            } else if (d['Jour séance'] == i) {
              if (d['Début séance'] == h) {
                vidos = false;
                taille = 1;
                tempfin = d['Fin séance'];
                break;
              }
            }
          }
          if (vidos == true) {
            listcours.add('vide');
          }
        }
        mapcours.add({'jour': i, 'cours': listcours});
      }
    }
    print(mapcours);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blancfond,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: bleufonce,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: ListView(scrollDirection: Axis.horizontal, children: <
                    Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(width: largeur, child: Text("")),
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
                                          textAlign: TextAlign.center,
                                        ))),
                            ],
                          ),
                        ),
                        Flexible(
                            flex: 9,
                            fit: FlexFit.loose,
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(children: [
                                      for (var z in mapcours)
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, paddinghaut, 0, 15),
                                                  height: hauteurcaseterrain,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[400],
                                                  ),
                                                  width: largeur * 1.5,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(z['jour'],
                                                        textAlign:
                                                            TextAlign.center),
                                                  )),
                                              for (var j in z['cours'])
                                                Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(0, 10, 0, 15),
                                                    height: hauteurcaseterrain,
                                                    child: j is List
                                                        ? Container(
                                                            width:
                                                                largeur * j[0],
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    primary:
                                                                        Colors
                                                                            .red,
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            2),
                                                                    elevation:
                                                                        0,
                                                                    minimumSize: Size(
                                                                        largeur *
                                                                            j[0],
                                                                        hauteurcaseterrain),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                  ),
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                      "Court " +
                                                                          j[1],
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                )),
                                                          )
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
                                                                  z['jour'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          noirecrit),
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
        ));
  }
}
