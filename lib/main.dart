// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:racpresence/connexion.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/recherche.dart';
import 'package:firebase_core/firebase_core.dart';
import 'appel.dart';
import 'calendrier.dart';
import 'package:racpresence/variables.dart';
import 'parametres.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

bool checkos = true;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return MaterialApp(
        title: 'Rac presence',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Lato',
        ),
        home: MyHomePage(),
        //MyHomePage(title: 'RAC présence'),
      );
    } else {
      return MaterialApp(
        title: 'Rac presence',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Connexion(title: 'Connexion'),
        //MyHomePage(title: 'RAC présence'),
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    checkcours();
    super.initState();
  }

  final bddcours = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('cours');
  void checkcours() async {
    if (iduser_ == '') {
      var fireref = FirebaseFirestore.instance;
      var resultuser = await fireref
          .collection('users')
          .where("uid", isEqualTo: currentUser.uid)
          .get();

      if (resultuser.docs.length > 0) {
        var resultatcours = await fireref
            .collection('users')
            .doc(resultuser.docs[0].id)
            .collection('cours')
            .get();

        id_ = resultuser.docs[0].data()['Nom'].toUpperCase() +
            ' ' +
            resultuser.docs[0].data()['Prénom'];
        nom__ = resultuser.docs[0].data()['Nom'];
        prenom__ = resultuser.docs[0].data()['Prénom'];
        admin_ = resultuser.docs[0].data()['admin'];
        num_ = resultuser.docs[0].data()['numéro'];
        iduser_ = resultuser.docs[0].id;
        if (resultuser.docs[0].data()['orga'] != null) {
          orga_ = true;
        }
        if (resultuser.docs[0].data()['edt'] == false) {
          var cours = await bddcours
              .orderByChild('Nom Prof Séance')
              .equalTo(nom__)
              .once();
          if (cours.value != null) {
            var vmap = {};
            Map<dynamic, dynamic> mapresult = cours.value;
            mapresult.forEach((key, value) {
              if (value['Prénom Prof Séance'] == prenom__) vmap[key] = value;
            });
            vmap.forEach((key, value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(iduser_)
                  .collection('cours')
                  .add({
                'Début séance': value['Début séance'],
                'Court séance': value['Court séance'],
                'Fin séance': value['Fin séance'],
                'Jour séance': value['Jour séance'],
              });
            });
          }

          fireref.collection('users').doc(iduser_).update({
            'edt': true,
          });
        }
        if (admin_ == true) {
          var absences = await FirebaseDatabase(
                  databaseURL:
                      'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
              .reference()
              .child('3abs')
              .once();
          var listeabs = List.from(absences.value);
          if (listeabs.length > 1) {
            abs_ = true;
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyHomePage()));
          } else {
            abs_ = false;
          }
        }
        var now = new DateTime.now();
        var nomjour;
        var jour = now.weekday;
        var time = now.minute;
        var heure = now.hour;
        var mois = now.month.toString();
        if (mois.length == 1) mois = "0" + mois;
        if (jour == 1)
          nomjour = "Lundi";
        else if (jour == 2)
          nomjour = "Mardi";
        else if (jour == 3)
          nomjour = "Mercredi";
        else if (jour == 4)
          nomjour = "Jeudi";
        else if (jour == 5)
          nomjour = "Vendredi";
        else if (jour == 6)
          nomjour = "Samedi";
        else
          nomjour = "Dimanche";

        for (var res in resultatcours.docs) {
          if (res.data()['Jour séance'] == nomjour) {
            var deb = res.data()['Début séance'];
            var f = res.data()['Fin séance'];
            var deb2 = deb.split(":");
            var f2 = f.split(":");
            var hdebut = int.parse(deb2[0]);
            var mdebut = int.parse(deb2[1]);
            var hfin = int.parse(f2[0]);
            var mfin = int.parse(f2[1]);
            if (heure < hfin && heure > hdebut) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Appel(
                        title: "Cours du moment",
                        datos:
                            nomjour + ' ' + now.day.toString() + ' / ' + mois,
                        terrain: res.data()['Court séance'],
                        heure: res.data()['Début séance'],
                      )));
              break;
            }

            if (heure < hfin && heure >= hdebut) {
              if (heure == time) {
                if (time <= mfin && time >= mdebut) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Appel(
                            title: "Cours du moment",
                            datos: nomjour +
                                ' ' +
                                now.day.toString() +
                                ' / ' +
                                mois,
                            terrain: res.data()['Court séance'],
                            heure: res.data()['Début séance'],
                          )));
                  break;
                }
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Appel(
                          title: "Cours du moment",
                          datos:
                              nomjour + ' ' + now.day.toString() + ' / ' + mois,
                          terrain: res.data()['Court séance'],
                          heure: res.data()['Début séance'],
                        )));
                break;
              }
            } else if (heure == hfin) {
              if (time <= mfin && time >= mdebut) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Appel(
                          title: "Cours du moment",
                          datos:
                              nomjour + ' ' + now.day.toString() + ' / ' + mois,
                          terrain: res.data()['Court séance'],
                          heure: res.data()['Début séance'],
                        )));
                break;
              }
            }
          }
        }
      }
      setState(() {});
    }
  }

  int _selectedIndex = 0;

  final tabs = [
    Center(child: Calendrier(title: 'Calendrier')),
    Center(child: Recherche(title: "Recherche")),
    Center(child: Parametre(title: 'Paramètres')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: orange,
        onTap: _onItemTapped,
      ),
    );
  }
}
