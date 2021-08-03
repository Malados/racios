import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/liste_options/eleve/ajouteleve.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:racpresence/problemes/pborga.dart';

class Organisation extends StatefulWidget {
  Organisation({Key? key, required this.title, required this.liste})
      : super(key: key);

  final String title;
  final liste;

  @override
  _Organisation createState() => _Organisation(groupedispo: liste);
}

String chercheelevos = '';
var cherchoscontroll_ = TextEditingController();
List magique = [];
Map mappareleve = {};
var courssup = [];
var tailleajout = 25.0;
var maptestaffiche = {};
var groupeselec = [];
bool afficheedt = false;
var listeleve = [];
var map = {};
double tailletab = 0.0;
bool addereleve = false;
var nomcontroll_ = TextEditingController();
String nom_ = "";
var prenomcontroll_ = TextEditingController();
String prenom_ = "";
var debutc_ = TextEditingController();
String debut_ = "";
var nb30c_ = TextEditingController();
String nb30_ = "";
var jourc_ = TextEditingController();
String jour_ = '';
var courtc_ = TextEditingController();
String court_ = '';
bool extendbutton = false;

class _Organisation extends State<Organisation> {
  final colonneheure = GlobalKey();
  var groupedispo;
  final bddcours = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('cours');
  final bddeleves = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('eleves');
  final bdd = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference();
  _Organisation({required this.groupedispo});

  void update() {
    setState(() {});
  }

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
  var listejour = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];
  chercheeleve() async {
    for (var i in groupeselec) {
      var groupe = await bddeleves.orderByChild("Formation").equalTo(i).once();
      var mapos = Map.from(groupe.value);
      mapos.forEach((v, k) {
        listeleve.add({
          'nom': k['Nom'],
          'prenom': k['Prénom'],
          'cours': List.from(k['Cours']),
          'formation': k['Formation'],
        });
      });
    }
  }

  List supervide = [];
  var mapcouros = [];
  void construction() async {
    var mapconst = {};
    for (var eleve in listeleve) {
      if (eleve['cours'][0] != 'vide') {
        for (var c in eleve['cours']) {
          if (mapconst.containsKey(c['Jour séance'] +
              ' ' +
              c['Début séance'] +
              ' ' +
              c['Professeur séance'])) {
            var ttt = mapconst[c['Jour séance'] +
                ' ' +
                c['Début séance'] +
                ' ' +
                c['Professeur séance']];
            var ttteleve = ttt['ListeEleve'];
            ttteleve.add(eleve['nom'] + " " + eleve['prenom']);
            mapconst[c['Jour séance'] +
                    ' ' +
                    c['Début séance'] +
                    ' ' +
                    c['Professeur séance']]
                .update(
              'ListeEleve',
              (existingValue) => ttteleve,
            );
          } else {
            var np = eleve['nom'] + " " + eleve['prenom'];
            mapconst[c['Jour séance'] +
                ' ' +
                c['Début séance'] +
                ' ' +
                c['Professeur séance']] = {
              'Professeur séance': c['Professeur séance'],
              'Jour séance': c['Jour séance'],
              'Début séance': c['Début séance'],
              'Fin séance': c['Fin séance'],
              'ListeEleve': [np],
              'Court séance': c['Court séance'],
              'Nom Prof Séance': c['Nom Prof Séance'],
              'Prénom Prof Séance': c['Prénom Prof Séance']
            };
          }
        }
      }
    }
    maptestaffiche = mapconst;
    await Future.delayed(
        const Duration(
          seconds: 1,
        ),
        () {});
    for (var jour in listejour) {
      var listvide = [];
      var mapjour = {};
      var nblignes = 1;
      var tempkey = [];
      var trouve = [];
      for (var hor in horaire) {
        if (tempkey.length > 0) {
          var tempos = [];
          for (var tk in tempkey) {
            if (tk['fin'] == hor) {
              tk.update(
                'nbcase',
                (existingValue) => tk['nbcase'] + 1,
              );
              if (mapjour[tk['ligne']] == null) {
                mapjour[tk['ligne']] = List.from(listvide);
                var zzz = 1;
                while (zzz < tk['nbcase']) {
                  zzz++;
                  mapjour[tk['ligne']].removeLast();
                }
              }
              var check = mapconst[tk['clef']];
              var splitos = tk['clef'].split(' ');
              var tempmap = {
                'nbcase': tk['nbcase'],
                'élève': check['ListeEleve'],
                'court': check['Court séance'],
                'prof': check['Professeur séance'],
                'nom': check['Nom Prof Séance'],
                'prénom': check['Prénom Prof Séance'],
                'début': splitos[1],
                'fin': tk['fin'],
                'jour': splitos[0],
              };
              var lignos = mapjour[tk['ligne']];
              lignos.add(tempmap);
              mapjour.update(tk['ligne'], (value) => lignos);
              mapjour.remove(tk['clef']);
              mapconst.remove(check['Jour séance'] +
                  ' ' +
                  check['Début séance'] +
                  ' ' +
                  check['Professeur séance']);
              trouve = [];
              mapjour.forEach((key, value) {
                trouve.add(key);
              });
            } else {
              trouve.remove(tk['ligne']);
              tk.update(
                'nbcase',
                (existingValue) => tk['nbcase'] + 1,
              );
              tempos.add(tk);
            }
          }
          tempkey = tempos;
        }

        mapconst.forEach((key, value) {
          if (value['Début séance'] == hor && value['Jour séance'] == jour) {
            trouve.remove(tempkey.length);
            tempkey.add({
              'clef': key,
              'fin': value['Fin séance'],
              'nbcase': 1,
              'ligne': tempkey.length
            });

            if (tempkey.length > nblignes) nblignes = tempkey.length;
          }
        });

        mapjour.forEach((key, value) {
          if (trouve.contains(key)) {
            var ll = value;
            ll.add('vide');
            mapjour[key] = ll;
          }
        });

        trouve = [];
        mapjour.forEach((key, value) {
          trouve.add(key);
        });
        listvide.add('vide');
      }
      supervide = listvide;
      List lignemax = [];
      mapjour.forEach((key, value) {
        lignemax.add(value);
      });
      if (lignemax.isEmpty) {
        lignemax.add(listvide);
      }
      var mapgne = {"Nbpara": nblignes, 'Jour': jour, 'Lignes': lignemax};

      mapcouros.add(mapgne);
    }

    for (var i in mapcouros) {
      for (var s in i['Lignes']) {
        for (var j in s) {
          if (j != "vide") {
            for (var z in j['élève']) {
              if (courssup.contains(j['jour'] + j['début'] + j['court']) ==
                  false) {
                courssup.add(j['jour'] + j['début'] + j['court']);
              }
            }
          }
        }
      }
    }
    setState(() {});
  }

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

  var largeurhoraire = 50.0;
  var largeur = 150.0;
  var hauteurcours = 42.0;
  var hauteurjour = 30.0;
  var hauteurheure = 42.0;

  void export() {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    var mapeleve = {};
    for (var i in mapcouros) {
      for (var s in i['Lignes']) {
        for (var j in s) {
          if (j != "vide") {
            for (var z in j['élève']) {
              if (mapeleve.containsKey(z) == false) {
                mapeleve[z] = [
                  {
                    'fin': j['fin'],
                    'debut': j['début'],
                    'court': j['court'],
                    'prof': j['prof'],
                    'jour': j['jour'],
                  }
                ];
              } else {
                mapeleve[z].add({
                  'fin': j['fin'],
                  'debut': j['début'],
                  'court': j['court'],
                  'prof': j['prof'],
                  'jour': j['jour'],
                });
              }
            }
          }
        }
      }
    }
    List l = [
      'Nom et prénom',
      'Cours 1',
      'Cours 2',
      'Cours 3',
      'Cours 4',
      'Cours 5'
    ];
    sheetObject.appendRow(l);
    mapeleve.forEach((key, value) {
      var eleve = [];
      eleve.add(key);
      value.forEach((val) {
        eleve.add('Jour: ' +
            val["jour"] +
            ' , début: ' +
            val["debut"] +
            ' , fin: ' +
            val["fin"] +
            ' , Prof: ' +
            val["prof"] +
            ', court: ' +
            val["court"]);
      });
      sheetObject.appendRow(eleve);
    });

    excel.encode().then((onValue) {
      File(Path.join("/storage/emulated/0/Download/EDT RAC EXCEL.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
    final snackBar = SnackBar(
      content: Text('Export terminé'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void creercours() {
    int idxLi = 0;
    List rechange = [];
    bool newline = true;
    jour_ = capitalize(jour_);
    for (var gne in mapcouros) {
      if (gne['Jour'] == jour_) {
        String finos = '';
        for (var Li in gne['Lignes']) {
          int compteur = 0;
          int idx = 0;
          for (var li in Li) {
            if (li != 'vide') {
              compteur++;
            }
            bool breakos = false;
            if (idx >= 28) {
              break;
            }
            if (horaire[idx].toString() == debut_.toString()) {
              for (var y = idx - compteur;
                  y < idx - compteur + int.parse(nb30_);
                  y += 1) {
                if (Li[y] != 'vide') {
                  breakos = true;
                }
                if (y == (idx - compteur + int.parse(nb30_) - 1)) {
                  finos = horaire[y + compteur + 1];
                }
              }
              if (breakos == true)
                break;
              else {
                rechange = List.from(Li);
                for (var y = 0; y < int.parse(nb30_); y += 1) {
                  rechange.removeAt(idx - compteur);
                }
                rechange.insert(idx - compteur, {
                  'nbcase': int.parse(nb30_) + 1,
                  'élève': [],
                  'court': convertcourt(court_),
                  'prof': nom_.toUpperCase() + ' ' + capitalize(prenom_),
                  'nom': capitalize(nom_),
                  'prénom': capitalize(prenom_),
                  'début': debut_,
                  'fin': finos,
                  'jour': jour_,
                });
                idxLi = gne['Lignes'].indexOf(Li);
                newline = false;
                break;
              }
            } else {
              idx++;
            }
          }
          if (newline == false) break;
        }
        int idxxxx = 0;
        if (newline == true) {
          rechange = List.from(supervide);
          for (var li in rechange) {
            if (horaire[idxxxx].toString() == debut_.toString()) {
              for (var y = 0; y < int.parse(nb30_); y += 1) {
                rechange.removeAt(idxxxx);
              }
              rechange.insert(idxxxx, {
                'nbcase': int.parse(nb30_) + 1,
                'élève': [],
                'court': court_,
                'prof': nom_.toUpperCase() + ' ' + capitalize(prenom_),
                'nom': capitalize(nom_),
                'prénom': capitalize(prenom_),
                'début': debut_,
                'fin': finos,
                'jour': jour_,
              });
              break;
            }
            idxxxx++;
          }
        }
        break;
      }
    }
    for (var gne in mapcouros) {
      if (gne['Jour'] == jour_) {
        if (newline == true) {
          var copymap = Map.from(gne);
          var copylistes = copymap['Lignes'];
          copylistes.add(rechange);
          gne.update('Lignes', (existingValue) => copylistes);
        } else {
          var copymap = Map.from(gne);
          var copylistes = copymap['Lignes'];
          copylistes[idxLi] = rechange;
          gne.update('Lignes', (existingValue) => copylistes);
        }
        break;
      }
    }
    nom_ = "";
    prenom_ = "";
    debut_ = "";
    nb30_ = "";
    jour_ = '';
    court_ = '';

    nomcontroll_.clear();

    prenomcontroll_.clear();

    debutc_.clear();

    nb30c_.clear();

    jourc_.clear();

    courtc_.clear();
    setState(() {});
  }

  void sauvegarder() async {
    List allprof = [];
    var mapeleve = {};
    var mapcours = {};
    for (var i in mapcouros) {
      for (var s in i['Lignes']) {
        for (var j in s) {
          if (j != "vide") {
            for (var z in j['élève']) {
              if (allprof.contains(j['prof']) == false) {
                allprof.add([j['nom'], j['prénom']]);
              }
              if (mapcours[j['jour'] + j['début'] + j['court']].toString() ==
                  null.toString()) {
                var tabnpel = j['élève'];
                var tabnom = [];
                var tabprenom = [];
                for (var nono in tabnpel) {
                  var splitexos = nono.split(' ');
                  tabnom.add(splitexos[0]);
                  tabprenom.add(splitexos[1]);
                }
                mapcours[j['jour'] + j['début'] + j['court']] = {
                  'Nom Eleve': tabnom,
                  'Prénom Eleve': tabprenom,
                  'Fin séance': j['fin'],
                  'Début séance': j['début'],
                  'Court séance': j['court'],
                  'Professeur séance': j['prof'],
                  'Jour séance': j['jour'],
                  'Prénom Prof Séance': j['prénom'],
                  'Nom Prof Séance': j['nom'],
                  'Temp': ['vide'],
                };
              }
              if (mapeleve.containsKey(z) == false) {
                mapeleve[z] = [
                  {
                    'Fin séance': j['fin'],
                    'Début séance': j['début'],
                    'Court séance': j['court'],
                    'Professeur séance': j['prof'],
                    'Jour séance': j['jour'],
                    'Prénom Prof Séance': j['prénom'],
                    'Nom Prof Séance': j['nom'],
                  }
                ];
              } else {
                mapeleve[z].add({
                  'Fin séance': j['fin'],
                  'Début séance': j['début'],
                  'Court séance': j['court'],
                  'Professeur séance': j['prof'],
                  'Jour séance': j['jour'],
                  'Prénom Prof Séance': j['prénom'],
                  'Nom Prof Séance': j['nom'],
                });
              }
            }
          }
        }
      }
    }

    allprof.forEach((element) async {
      var resultos = await FirebaseFirestore.instance
          .collection('users')
          .where('Nom', isEqualTo: element[0])
          .where('Prénom', isEqualTo: element[1])
          .get();
      if (resultos.docs.length != 0) {
        if (resultos.docs[0].data()['edt'] == true) {
          var resultos2 = await FirebaseFirestore.instance
              .collection('users')
              .doc(resultos.docs[0].id)
              .collection('cours')
              .get();
          resultos2.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(resultos.docs[0].id)
                .collection('cours')
                .doc(element.id)
                .delete();
          });

          FirebaseFirestore.instance
              .collection('users')
              .doc(resultos.docs[0].id)
              .update({
            'edt': false,
          });
        }
      }
    });
    mapeleve.forEach((key, value) {
      var nnpp = key.split(' ');
      bddeleves.child(nnpp[0] + nnpp[1]).child('Cours').remove();
      bddeleves.child(nnpp[0] + nnpp[1]).update({'Cours': value});
    });
    courssup.forEach((element) {
      bddcours.child(element).remove();
    });
    mapcours.forEach((key, value) {
      bddcours.update({key: value});
    });
    setState(() {});
    final snackBar = SnackBar(
      content: Text('Sauvegarde effectuée'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.add,
      activeIcon: Icons.remove,
      buttonSize: 56.0,
      visible: afficheedt == true ? true : false,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: bleuclair,
      foregroundColor: noirecrit,
      elevation: 8.0,
      shape: CircleBorder(),
      gradientBoxShape: BoxShape.circle,
      children: [
        SpeedDialChild(
          child: Icon(Icons.sports_tennis),
          backgroundColor: Colors.amber,
          label: 'Créer un cours',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  titlePadding: const EdgeInsets.all(0.0),
                  contentPadding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  content: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: 450,
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Nom prof',
                            hintStyle: TextStyle(fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: bleufonce, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          ),
                          textInputAction: TextInputAction.next,
                          controller: nomcontroll_,
                          onChanged: (value) {
                            setState(() {
                              nom_ = value.trim();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Prénom prof',
                            hintStyle: TextStyle(fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: bleufonce, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          ),
                          textInputAction: TextInputAction.next,
                          controller: prenomcontroll_,
                          onChanged: (value) {
                            setState(() {
                              prenom_ = value.trim();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Jour',
                            hintStyle: TextStyle(fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: bleufonce, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          ),
                          textInputAction: TextInputAction.next,
                          controller: jourc_,
                          onChanged: (value) {
                            setState(() {
                              jour_ = value.trim();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Début du cours',
                            hintStyle: TextStyle(fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: bleufonce, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          ),
                          textInputAction: TextInputAction.next,
                          controller: debutc_,
                          onChanged: (value) {
                            setState(() {
                              debut_ = value.trim();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Durée (en nb de 30 min)',
                            hintStyle: TextStyle(fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: bleufonce, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          ),
                          textInputAction: TextInputAction.next,
                          controller: nb30c_,
                          onChanged: (value) {
                            setState(() {
                              nb30_ = value.trim();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Terrain',
                            hintStyle: TextStyle(fontSize: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: bleufonce, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          ),
                          textInputAction: TextInputAction.next,
                          controller: courtc_,
                          onChanged: (value) {
                            setState(() {
                              court_ = value.trim();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            side: BorderSide(color: Colors.black, width: 1),
                            elevation: 0,
                            fixedSize: Size(250, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'Ajouter le cours',
                            style: TextStyle(color: noirecrit, fontSize: 20),
                          ),
                          onPressed: () {
                            creercours();
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        ),
                      ),
                    ]),
                  ),
                );
              });
            },
          ),
        ),
        SpeedDialChild(
          child: Icon(Icons.accessibility),
          backgroundColor: Colors.blue,
          label: 'Créer un élève',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AjoutEleve(title: 'Créer un élève'))),
        ),
        SpeedDialChild(
            child: Icon(Icons.search),
            backgroundColor: Colors.purple[200],
            label: 'Afficher par élève',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              mappareleve = {};
              magique.clear();
              for (var i in mapcouros) {
                for (var s in i['Lignes']) {
                  for (var j in s) {
                    if (j != "vide") {
                      for (var z in j['élève']) {
                        if (mappareleve.containsKey(z) == false) {
                          mappareleve[z] = [
                            {
                              'Fin séance': j['fin'],
                              'Début séance': j['début'],
                              'Court séance': j['court'],
                              'Professeur séance': j['prof'],
                              'Jour séance': j['jour'],
                              'Prénom Prof Séance': j['prénom'],
                              'Nom Prof Séance': j['nom'],
                            }
                          ];
                        } else {
                          mappareleve[z].add({
                            'Fin séance': j['fin'],
                            'Début séance': j['début'],
                            'Court séance': j['court'],
                            'Professeur séance': j['prof'],
                            'Jour séance': j['jour'],
                            'Prénom Prof Séance': j['prénom'],
                            'Nom Prof Séance': j['nom'],
                          });
                        }
                      }
                    }
                  }
                }
              }
              mappareleve.forEach((key, value) {
                mappareleve[key].insert(0, {'nom': key});
                magique.add(value);
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      content: Container(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Chercher un élève',
                                  hintStyle: TextStyle(fontSize: 20),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: bleufonce, width: 2.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                ),
                                textInputAction: TextInputAction.next,
                                controller: cherchoscontroll_,
                                onChanged: (value) {
                                  setState(() {
                                    chercheelevos = value.trim();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            for (var eleve in magique)
                              Container(
                                  child: (eleve[0]['nom'].toLowerCase())
                                          .contains(chercheelevos.toLowerCase())
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    child: Text(eleve[0]
                                                            ['nom'] +
                                                        " / Nb cours: " +
                                                        (eleve.length - 1)
                                                            .toString())),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                for (var couriros in eleve)
                                                  Container(
                                                      child: couriros['nom'] ==
                                                              null
                                                          ? Text(couriros[
                                                                  'Jour séance'] +
                                                              " " +
                                                              couriros[
                                                                  'Début séance'] +
                                                              " " +
                                                              couriros[
                                                                  'Nom Prof Séance'])
                                                          : Container()),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            ),

                                            // Container(child: Text(eleve[]),)
                                          ],
                                        )
                                      : Container()),
                          ]),
                        ),
                      ),
                    );
                  });
                },
              );
            }),
        SpeedDialChild(
          child: Icon(Icons.table_rows),
          backgroundColor: Colors.green,
          label: 'Exporter en excel',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => export(),
        ),
        SpeedDialChild(
          child: Icon(Icons.save),
          backgroundColor: Colors.white,
          label: 'Enregistrer',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => sauvegarder(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PbOrga(title: "J'ai un problème")));
              },
              icon: Icon(Icons.contact_support)),
        ],
        leading: afficheedt == true
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        content: Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          height: 100,
                          child: Column(children: [
                            Container(
                                child: Text(
                              'Vous êtes sûr de vouloir quitter ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: noirecrit,
                              ),
                            )),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  side:
                                      BorderSide(color: Colors.black, width: 1),
                                  elevation: 0,
                                  fixedSize: Size(150, 30),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  'Fermer',
                                  style: TextStyle(
                                    color: noirecrit,
                                  ),
                                ),
                                onPressed: () {
                                  maptestaffiche = {};
                                  groupeselec = [];
                                  afficheedt = false;
                                  listeleve = [];
                                  map = {};
                                  tailletab = 0.0;
                                  addereleve = false;
                                  mapcouros = [];
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                  );

                  setState(() {});
                })
            : IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
        backgroundColor: bleufonce,
        centerTitle: true,
        title: Text(widget.title),
      ),
      floatingActionButton: buildSpeedDial(),
      body: afficheedt == false
          ? Center(
              child: Column(
                children: [
                  Container(
                    height: 450,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        for (var i in groupedispo)
                          Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(i),
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    value: groupeselec.contains(i),
                                    onChanged: (value) {
                                      if (groupeselec.contains(i)) {
                                        groupeselec.remove(i);
                                      } else {
                                        groupeselec.add(i);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ))
                      ],
                    ),
                  ),
                  SizedBox(height: 125),
                  Row(children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: bleuclair,
                            ),
                            child: Text(
                              "Organiser ces groupes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              afficheedt = true;
                              await chercheeleve();
                              construction();
                              setState(() {});
                            },
                          )),
                    ),
                  ]),
                ],
              ),
            )
          : Column(children: [
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: largeurhoraire,
                                  height: hauteurheure,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        side: BorderSide(
                                            color: Colors.black, width: 0),
                                        elevation: 0,
                                        shape: CircleBorder()),
                                    child: Icon(Icons.refresh),
                                    onPressed: () {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                for (var i in horaire2)
                                  Container(
                                      height: hauteurheure,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 11, 0, 10),
                                      width: largeurhoraire,
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
                            Container(
                              color: Colors.black,
                              width: MediaQuery.of(context).size.width - 50,
                              height: hauteurheure * horaire2.length +
                                  horaire2.length * 22,
                              child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (var jouros in mapcouros)
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        width:
                                            largeur * jouros['Lignes'].length,
                                        height: hauteurjour,
                                        color: Colors.amber[100],
                                        child: Column(
                                          children: [
                                            Container(
                                              height: hauteurcours,
                                              color: Colors.purple[200],
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Center(
                                                      child: Text(
                                                        jouros['Jour'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 22),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  for (var lignetos
                                                      in jouros['Lignes'])
                                                    Column(
                                                      children: [
                                                        Container(
                                                          height:
                                                              hauteurheure / 2 +
                                                                  10,
                                                          width: 1,
                                                        ),
                                                        for (var casos
                                                            in lignetos)
                                                          Container(
                                                              child: casos !=
                                                                      'vide'
                                                                  ? Container(
                                                                      height: (hauteurcours) *
                                                                              casos[
                                                                                  'nbcase'] +
                                                                          ((casos['nbcase'] - 3) *
                                                                              21),
                                                                      width:
                                                                          largeur,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onLongPress:
                                                                            () {
                                                                          tailletab = casos['élève']
                                                                              .length
                                                                              .toDouble();

                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return StatefulBuilder(builder: (context, setState) {
                                                                                return AlertDialog(
                                                                                  titlePadding: const EdgeInsets.all(0.0),
                                                                                  contentPadding: const EdgeInsets.all(0.0),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(0.0),
                                                                                  ),
                                                                                  content: Container(
                                                                                    height: 250 + 50 * casos['élève'].length.toDouble() + tailleajout,
                                                                                    child: Column(children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Container(
                                                                                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                                                            child: ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                primary: Colors.red,
                                                                                                side: BorderSide(color: Colors.black, width: 1),
                                                                                                elevation: 0,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                              ),
                                                                                              child: Text(
                                                                                                'Supprimer le cours',
                                                                                                style: TextStyle(
                                                                                                  color: noirecrit,
                                                                                                ),
                                                                                              ),
                                                                                              onPressed: () async {
                                                                                                addereleve = false;
                                                                                                var id = lignetos.indexOf(casos);
                                                                                                var nb = casos['nbcase'];
                                                                                                lignetos.removeAt(id);
                                                                                                for (var zzz = 0; zzz < nb - 1; zzz++) {
                                                                                                  lignetos.insert(id, 'vide');
                                                                                                }
                                                                                                if (lignetos == supervide) {
                                                                                                  jouros['Lignes'].remove(supervide);
                                                                                                }
                                                                                                Navigator.of(context).pop();
                                                                                                update();
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Container(
                                                                                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                                                          child: Text(
                                                                                            'Prof: ' + casos['prof'],
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                              color: noirecrit,
                                                                                            ),
                                                                                          )),
                                                                                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                        Text(
                                                                                          'Élève(s):',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            color: noirecrit,
                                                                                          ),
                                                                                        ),
                                                                                        for (var el in casos['élève'])
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                            children: [
                                                                                              Text(el, textAlign: TextAlign.center, style: TextStyle(color: noirecrit)),
                                                                                              ElevatedButton(
                                                                                                style: ElevatedButton.styleFrom(primary: Colors.red, side: BorderSide(color: Colors.black, width: 1), elevation: 0, fixedSize: Size(30, 30), shape: CircleBorder()),
                                                                                                child: Icon(Icons.close),
                                                                                                onPressed: () {
                                                                                                  casos['élève'].remove(el);
                                                                                                  setState(() {});
                                                                                                },
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                      ]),
                                                                                      if (addereleve == false)
                                                                                        Container(
                                                                                          child: ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              primary: Colors.green,
                                                                                              side: BorderSide(color: Colors.black, width: 1),
                                                                                              elevation: 0,
                                                                                              fixedSize: Size(30, 30),
                                                                                              shape: CircleBorder(),
                                                                                            ),
                                                                                            child: Icon(Icons.add),
                                                                                            onPressed: () {
                                                                                              addereleve = true;
                                                                                              tailleajout = 160;
                                                                                              setState(() {});
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      if (addereleve == true)
                                                                                        Column(
                                                                                          children: [
                                                                                            Container(
                                                                                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                                                                                              child: TextField(
                                                                                                decoration: InputDecoration(
                                                                                                  filled: true,
                                                                                                  fillColor: Colors.white,
                                                                                                  hintText: 'Nom',
                                                                                                  hintStyle: TextStyle(fontSize: 20),
                                                                                                  focusedBorder: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    borderSide: BorderSide(color: bleufonce, width: 2.0),
                                                                                                  ),
                                                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                                                                ),
                                                                                                textInputAction: TextInputAction.next,
                                                                                                controller: nomcontroll_,
                                                                                                onChanged: (value) {
                                                                                                  setState(() {
                                                                                                    nom_ = value.trim();
                                                                                                  });
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 5,
                                                                                            ),
                                                                                            Container(
                                                                                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                                                                                              child: TextField(
                                                                                                decoration: InputDecoration(
                                                                                                  filled: true,
                                                                                                  fillColor: Colors.white,
                                                                                                  hintText: 'Prénom',
                                                                                                  hintStyle: TextStyle(fontSize: 20),
                                                                                                  focusedBorder: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    borderSide: BorderSide(color: bleufonce, width: 2.0),
                                                                                                  ),
                                                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                                                                ),
                                                                                                textInputAction: TextInputAction.next,
                                                                                                controller: prenomcontroll_,
                                                                                                onChanged: (value) {
                                                                                                  setState(() {
                                                                                                    prenom_ = value.trim();
                                                                                                  });
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                              children: [
                                                                                                ElevatedButton(
                                                                                                  onPressed: () {
                                                                                                    addereleve = false;
                                                                                                    tailleajout = 25;
                                                                                                    setState(() {});
                                                                                                  },
                                                                                                  style: ElevatedButton.styleFrom(
                                                                                                    primary: Colors.red,
                                                                                                    side: BorderSide(color: Colors.black, width: 1),
                                                                                                    elevation: 0,
                                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                                                  ),
                                                                                                  child: Text('annuler', style: TextStyle(color: noirecrit, fontSize: 20.0)),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 15,
                                                                                                  width: 1,
                                                                                                ),
                                                                                                ElevatedButton(
                                                                                                  onPressed: () {
                                                                                                    addereleve = false;
                                                                                                    tailleajout = 25;
                                                                                                    casos['élève'].add(capitalize(nom_) + ' ' + capitalize(prenom_));
                                                                                                    setState(() {});
                                                                                                  },
                                                                                                  style: ElevatedButton.styleFrom(
                                                                                                    primary: Colors.green,
                                                                                                    side: BorderSide(color: Colors.black, width: 1),
                                                                                                    elevation: 0,
                                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                                                  ),
                                                                                                  child: Text('ajouter', style: TextStyle(color: noirecrit, fontSize: 20.0)),
                                                                                                ),
                                                                                              ],
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      Container(
                                                                                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                                                          child: Text(
                                                                                            'Terrain: ' + casos['court'],
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                              color: noirecrit,
                                                                                            ),
                                                                                          )),
                                                                                      Container(
                                                                                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                                                          child: Text(
                                                                                            'Durée: ' + (casos['nbcase'] - 1).toString() + " * 30 minutes",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                              color: noirecrit,
                                                                                            ),
                                                                                          )),
                                                                                      Container(
                                                                                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                                                                                        child: ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            primary: Colors.red,
                                                                                            side: BorderSide(color: Colors.black, width: 1),
                                                                                            elevation: 0,
                                                                                            fixedSize: Size(150, 30),
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                          ),
                                                                                          child: Text(
                                                                                            'Fermer',
                                                                                            style: TextStyle(
                                                                                              color: noirecrit,
                                                                                            ),
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            addereleve = false;
                                                                                            Navigator.of(context).pop();
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ]),
                                                                                  ),
                                                                                );
                                                                              });
                                                                            },
                                                                          );
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              bleufonce,
                                                                          side: BorderSide(
                                                                              color: Colors.black,
                                                                              width: 1),
                                                                          elevation:
                                                                              0,
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                        ),
                                                                        child:
                                                                            ListView(
                                                                          shrinkWrap:
                                                                              true,
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.fromLTRB(0, 3, 0, 2),
                                                                              child: Text(
                                                                                casos['prof'],
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                                                                              padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                                                              decoration: BoxDecoration(
                                                                                color: bleuclair,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: Column(
                                                                                children: [
                                                                                  for (var el in casos['élève']) Text(el, textAlign: TextAlign.center, style: TextStyle(color: noirecrit)),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        onPressed:
                                                                            () {},
                                                                      ))
                                                                  : Container(
                                                                      height:
                                                                          hauteurheure,
                                                                      margin: const EdgeInsets
                                                                              .fromLTRB(
                                                                          0,
                                                                          11,
                                                                          0,
                                                                          10),
                                                                      width:
                                                                          largeur,
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            jouros[
                                                                                'Jour'],
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(color: Colors.grey)),
                                                                      ),
                                                                    ))
                                                      ],
                                                    ),
                                                ]),
                                          ],
                                        ),
                                      )
                                  ]),
                            ),
                          ]),
                    ],
                  ))
            ]),
    );
  }
}
