import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:racpresence/api/firebase_api.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/model/firebase_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/problemes/pbbdd.dart';

var cheminfichier = "";
var cell = "cell";

class ExcelBDD extends StatefulWidget {
  ExcelBDD({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ExcelBDD createState() => _ExcelBDD();
}

bool acollection = false;
var affiche = 0;
var listcours = [];
var listeformation = [];
List mailliste = [];

class _ExcelBDD extends State<ExcelBDD> {
  late Future<List<FirebaseFile>> futureFiles;
  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('files/');
  }

  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    List listeosef = [];
    List attributs = [];
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
    final bdd = FirebaseDatabase(
            databaseURL:
                'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
        .reference();
    void deletetout() async {
      bddeleves.remove();
      bddcours.remove();
      await bdd.update({
        '3abs': ['vide']
      });
      bdd.child('Formations').remove();

      final snackBar = SnackBar(
        content: Text('La base de donnée a été supprimée'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void remplirbdd() async {
      var filebdd = cheminfichier;
      var bytes = File(filebdd).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var tableabrutie;
      for (var table in excel.tables.keys) {
        tableabrutie = table;
        break;
      }
      for (var i in excel.tables[tableabrutie]!.rows[0]) {
        if (i == 'Nom') {
          attributs.add(i);
        } else if (i == 'Code formation') {
          attributs.add(i);
        } else if (i == 'Validité certificat médical') {
          attributs.add(i);
        } else if (i == 'Date Naiss') {
          attributs.add(i);
        } else if (i == 'Sexe') {
          attributs.add(i);
        } else if (i == 'Niveau présumé') {
          attributs.add(i);
        } else if (i == 'Classement') {
          attributs.add(i);
        } else if (i == 'Licence') {
          attributs.add(i);
        } else if (i == 'Droit image') {
          attributs.add(i);
        } else if (i == 'Autorisation sortie') {
          attributs.add(i);
        } else if (i == 'Jour séance') {
          attributs.add(i);
        } else if (i == 'Début séance' || i == 'Heure début') {
          attributs.add(i);
        } else if (i == 'Fin séance' || i == 'Heure fin') {
          attributs.add(i);
        } else if (i == 'Court séance' || i == 'Court') {
          attributs.add(i);
        } else if (i == 'Professeur séance' || i == 'Enseignant') {
          attributs.add(i);
        } else if (i == 'Prénom') {
          attributs.add(i);
        } else if (i == 'Adresse 2') {
          attributs.add(i);
        } else if (i == 'Email 1') {
          attributs.add(i);
        } else if (i == 'Email 2') {
          attributs.add(i);
        } else if (i == 'Tel Portable') {
          attributs.add(i);
        } else if (i == 'Tel Portable 2') {
          attributs.add(i);
        } else {
          attributs.add("vide");
        }
      }
      for (var row in excel.tables[tableabrutie]!.rows) {
        if (row[0] == null) break;
        List ligne = [];
        for (var attri in attributs) {
          if (attri != "vide") {
            ligne.add(row[attributs.indexOf(attri)]);
          }
        }
        listeosef.add(ligne);
      }

      List vide = [];
      for (var t in attributs) {
        if (t == 'vide') {
          vide.add(0);
        }
      }
      vide.forEach((element) {
        attributs.remove('vide');
      });

      for (var id in listeosef) {
        if (id[attributs.indexOf('Nom')] != 'Nom') {
          if (attributs.contains('Heure début')) {
            var eleve = await bddeleves
                .child(capitalize(id[attributs.indexOf('Nom')]) +
                    capitalize(id[attributs.indexOf('Prénom')]))
                .once();

            var couros = List.from(eleve.value['Cours']);
            if (couros[0] == 'vide') {
              couros = [];
            }
            couros.add({
              'Court séance': convertcourt(id[attributs.indexOf('Court')]),
              "Nom Prof Séance":
                  capitalizeNom(id[attributs.indexOf('Enseignant')]),
              "Prénom Prof Séance":
                  capitalizePrenom(id[attributs.indexOf('Enseignant')]),
              'Jour séance': id[attributs.indexOf('Jour séance')],
              'Début séance':
                  horairepoints(id[attributs.indexOf('Heure début')]),
              'Fin séance': horairepoints(id[attributs.indexOf('Heure fin')]),
              'Professeur séance': (id[attributs.indexOf('Enseignant')]),
            });
            bddeleves
                .child(capitalize(id[attributs.indexOf('Nom')]) +
                    capitalize(id[attributs.indexOf('Prénom')]))
                .update({'Cours': couros});

            var exist = await bddcours
                .child(id[attributs.indexOf('Jour séance')] +
                    horairepoints(id[attributs.indexOf('Heure début')]) +
                    convertcourt(id[attributs.indexOf('Court')]))
                .once();
            if (exist.value != null) {
              var nomos = List.from(exist.value['Nom Eleve']);
              nomos.add(capitalize(id[attributs.indexOf('Nom')]));
              var prenomos = List.from(exist.value['Prénom Eleve']);
              prenomos.add(capitalize(id[attributs.indexOf('Prénom')]));
              bddcours
                  .child(id[attributs.indexOf('Jour séance')] +
                      horairepoints(id[attributs.indexOf('Heure début')]) +
                      convertcourt(id[attributs.indexOf('Court')]))
                  .update({'Nom Eleve': nomos, 'Prénom Eleve': prenomos});
            } else {
              bddcours
                  .child(id[attributs.indexOf('Jour séance')] +
                      horairepoints(id[attributs.indexOf('Heure début')]) +
                      convertcourt(id[attributs.indexOf('Court')]))
                  .set({
                'Nom Eleve': [capitalize(id[attributs.indexOf('Nom')])],
                'Prénom Eleve': [capitalize(id[attributs.indexOf('Prénom')])],
                'Court séance': convertcourt(id[attributs.indexOf('Court')]),
                "Nom Prof Séance":
                    capitalizeNom(id[attributs.indexOf('Enseignant')]),
                "Prénom Prof Séance":
                    capitalizePrenom(id[attributs.indexOf('Enseignant')]),
                'Jour séance': id[attributs.indexOf('Jour séance')],
                'Début séance':
                    horairepoints(id[attributs.indexOf('Heure début')]),
                'Fin séance': horairepoints(id[attributs.indexOf('Heure fin')]),
                'Professeur séance': (id[attributs.indexOf('Enseignant')]),
                'Temp': ['vide'],
              });
            }

            listcours.add([
              convertcourt(id[attributs.indexOf('Court')]) +
                  id[attributs.indexOf('Jour séance')] +
                  horairepoints(id[attributs.indexOf('Heure début')])
            ]);
          } else {
            if (id[attributs.indexOf('Email 1')] != null) {
              if (mailliste.contains(id[attributs.indexOf('Email 1')])) {
                var result = await FirebaseFirestore.instance
                    .collection('parents')
                    .where('mail', isEqualTo: id[attributs.indexOf('Email 1')])
                    .get();
                var listos = result.docs[0].data()['enfants'];
                listos.add(capitalize(id[attributs.indexOf('Nom')]) +
                    ' ' +
                    capitalize(id[attributs.indexOf('Prénom')]));
                FirebaseFirestore.instance
                    .collection('parents')
                    .doc(result.docs[0].id)
                    .update({
                  'enfants': listos,
                });
              } else {
                var date = id[attributs.indexOf('Date Naiss')];
                var mdp = date.split('/');
                try {
                  await auth.createUserWithEmailAndPassword(
                      email: id[attributs.indexOf('Email 1')],
                      password: mdp[0] + mdp[1] + mdp[2]);
                } on FirebaseAuthException {}
                FirebaseFirestore.instance.collection('parents').add({
                  'mail': id[attributs.indexOf('Email 1')],
                  'enfants': [
                    capitalize(id[attributs.indexOf('Nom')]) +
                        ' ' +
                        capitalize(id[attributs.indexOf('Prénom')])
                  ],
                });
                mailliste.add(id[attributs.indexOf('Email 1')]);
              }
            }

            if (id[attributs.indexOf('Email 2')] != null) {
              if (mailliste.contains(id[attributs.indexOf('Email 2')])) {
                var result = await FirebaseFirestore.instance
                    .collection('parents')
                    .where('mail', isEqualTo: id[attributs.indexOf('Email 2')])
                    .get();
                var listos = result.docs[0].data()['enfants'];
                listos.add(capitalize(id[attributs.indexOf('Nom')]) +
                    ' ' +
                    capitalize(id[attributs.indexOf('Prénom')]));
                FirebaseFirestore.instance
                    .collection('parents')
                    .doc(result.docs[0].id)
                    .update({
                  'enfants': listos,
                });
              } else {
                var date = id[attributs.indexOf('Date Naiss')];
                var mdp = date.split('/');
                try {
                  await auth
                      .createUserWithEmailAndPassword(
                          email: id[attributs.indexOf('Email 2')],
                          password: mdp[0] + mdp[1] + mdp[2])
                      .then((newuser) {});
                } on FirebaseAuthException {}
                FirebaseFirestore.instance.collection('parents').add({
                  'mail': id[attributs.indexOf('Email 2')],
                  'enfants': [
                    capitalize(id[attributs.indexOf('Nom')]) +
                        ' ' +
                        capitalize(id[attributs.indexOf('Prénom')])
                  ],
                });
                mailliste.add(id[attributs.indexOf('Email 2')]);
              }
            }

            if (listeformation
                    .contains(id[attributs.indexOf('Code formation')]) ==
                false) {
              listeformation.add(id[attributs.indexOf('Code formation')]);
              bdd.update({'Formations': listeformation});
            }

            bddeleves
                .child(capitalize(id[attributs.indexOf('Nom')]) +
                    capitalize(id[attributs.indexOf('Prénom')]))
                .set({
              "Formation": id[attributs.indexOf('Code formation')],
              "Certificat":
                  id[attributs.indexOf('Validité certificat médical')],
              "Nom": capitalize(id[attributs.indexOf('Nom')]),
              "Prénom": capitalize(id[attributs.indexOf('Prénom')]),
              "Date Naissance": id[attributs.indexOf('Date Naiss')],
              "Sexe": id[attributs.indexOf('Sexe')],
              "Niveau présumé": id[attributs.indexOf('Niveau présumé')],
              "Classement": id[attributs.indexOf('Classement')],
              "Licence": id[attributs.indexOf('Licence')],
              "Droit image": id[attributs.indexOf('Droit image')],
              "Autorisation sortie":
                  id[attributs.indexOf('Autorisation sortie')],
              "Adresse": id[attributs.indexOf('Adresse 2')],
              "Email 1": id[attributs.indexOf('Email 1')],
              "Email 2": id[attributs.indexOf('Email 2')],
              "Tel Portable": id[attributs.indexOf('Tel Portable')],
              "Tel Portable 2": id[attributs.indexOf('Tel Portable 2')],
              'Présence': {'vide': 'vide'},
              'Epreuves': ['vide'],
              'Cours': ['vide'],
              'NbAbs': 0,
            });
          }
        }
      }
      final snackBar = SnackBar(
        content: Text('Transfert terminé'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void deleteeleve() async {
      bddeleves.remove();
    }

    void deletecours() async {
      bddcours.remove();
    }

    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        backgroundColor: bleufonce,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PbBdd(title: "J'ai un problème")));
              },
              icon: Icon(Icons.contact_support)),
        ],
      ),
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                final files = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(files.length),
                    const SizedBox(height: 12),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          return buildFile(context, file);
                        },
                      ),
                    ),
                    //UserInformation(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            child: acollection == false
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: bleuclair,
                                    ),
                                    child: Text(
                                      "Remplir bdd",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    onPressed: () {
                                      remplirbdd();
                                      acollection = true;
                                      setState(() {});
                                    })
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                    ),
                                    child: Text(
                                      "Remplir bdd",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    onPressed: () {})),
                        Container(
                            child: acollection == true
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: bleuclair,
                                    ),
                                    child: Text(
                                      "Nettoyer",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    onPressed: () {
                                      listeosef = [];
                                      listcours = [];
                                      attributs = [];
                                      cheminfichier = "";
                                      cell = "cell";
                                      acollection = false;
                                      setState(() {});
                                    },
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                    ),
                                    child: Text(
                                      "Nettoyer",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    onPressed: () {},
                                  )),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: bleuclair,
                                ),
                                child: Text("Supprimer bdd élèves"),
                                onPressed: () {
                                  deleteeleve();
                                }),
                          ),
                          Container(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: bleuclair,
                                ),
                                child: Text("Supprimer bdd cours"),
                                onPressed: () {
                                  deletecours();
                                }),
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  child: Text(
                                    "Nouvelle année",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () {
                                    deletetout();
                                  }),
                            ),
                          )
                        ]),
                    SizedBox(height: 10),
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                          child: Container(
                              color: blancfond,
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      margin:
                                          EdgeInsets.fromLTRB(15, 15, 15, 15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 3, color: orange),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))
                                          // Red border with the width is equal to 5
                                          ),
                                      width: 350,
                                      child: Text(
                                        'INSTRUCTIONS:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: noirecrit,
                                          fontSize: 18.0,
                                        ),
                                      )),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1, color: bleufonce),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))
                                          // Red border with the width is equal to 5
                                          ),
                                      width: 350,
                                      child: Text(
                                        '1) Sur ADSL: enseignement -> gestion des inscriptions -> sélectionner les groupes et export -> renommer le fichier "1" et le mettre en format ".xlsx" (marqué "Classeur Excel").',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      )),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1, color: bleufonce),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))
                                          // Red border with the width is equal to 5
                                          ),
                                      width: 350,
                                      child: Text(
                                        '2) Sur ADSL: requête récurrente -> envoyer à chaque adhérent un mail -> selectionner les groupes -> exécuter (tout en bas) -> export excel -> renommer le fichier "2" et le mettre en format ".xlsx".',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      )),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1, color: bleufonce),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))
                                          // Red border with the width is equal to 5
                                          ),
                                      width: 350,
                                      child: Text(
                                        "3) Dans un navigateur: se connecter sur google avec l'adresse ractennis.application@gmail.com (mdp: MotdepasseRAC) -> aller sur console.firebase.google.com -> cliquer sur 'Rac-presence' -> trouver sur la gauche storage -> aller dans files et importer les deux fichiers.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      )),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 35),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1, color: bleufonce),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))
                                          // Red border with the width is equal to 5
                                          ),
                                      width: 350,
                                      child: Text(
                                        "4) Dans l'application: quitter et revenir sur la page pour actualiser les fichiers -> appuyer sur le boutton 'Nouvelle année' pour réinitialiser les bases de données -> appuyer sur le doc 1 -> remplir bdd -> attendre quelques minutes (une barre apparaîtra en bas quand ça sera bon) -> nettoyer -> appuyer sur le doc 2 -> appuyer sur remplir bdd -> attendre que 'Transfert terminé' s'affiche.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      ))
                                ],
                              ))),
                    )
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: bleufonce,
          ),
        ),
        onTap: () async {
          await FirebaseApi.downloadFile(file.ref);

          final snackBar = SnackBar(
            content: Text('${file.name} téléchargé'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );

  Widget buildHeader(int length) => ListTile(
        tileColor: bleuclair,
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );

  void deleteField() {}
}
