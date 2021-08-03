import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsEleve extends StatefulWidget {
  AbsEleve({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AbsEleve createState() => _AbsEleve();
}

bool rien = false;

class _AbsEleve extends State<AbsEleve> {
  @override
  void initState() {
    super.initState();
    remplirmap();
  }

  final bddeleves = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('eleves');
  final bdd = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference();

  var map = [];

  void traitement(nom, prenom) async {
    bddeleves.child(nom + prenom).update({'ListeAbsense': [], 'NbAbs': 0});
    var listos = await bdd.child('3abs').once();
    var listabsence2 = List.from(listos.value);
    listabsence2.remove(nom + prenom);
    bdd.update({'3abs': listabsence2});
    remplirmap();
  }

  void remplirmap() async {
    map = [];
    var requete = await bddeleves.orderByChild('NbAbs').startAt(3).once();
    if (requete.value == null) {
      rien = true;
    } else {
      rien = false;
      Map<dynamic, dynamic> mapvalue = requete.value;
      mapvalue.forEach((key, value) {
        var listos = List.from(value['ListeAbsence']);
        var listos2 = [];
        for (var j in listos) {
          var string = j.split(' ');
          listos2.add(string[0] + ' ' + string[1] + '/' + string[2]);
        }

        map.add({
          'Nom': value['Nom'],
          'Prénom': value['Prénom'],
          'Email 1': value['Email 1'],
          'Email 2': value['Email 2'],
          'Tel Portable': value['Tel Portable'],
          'Tel Portable 2': value['Tel Portable 2'],
          'NbAbs': value['NbAbs'],
          'ListeAbsence': listos2,
          'liste': false,
        });
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleufonce,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: [
            if (rien == false)
              for (var i in map)
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                        // Red border with the width is equal to 5
                        ),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                i['Nom'] + ' ' + i['Prénom'],
                                style:
                                    TextStyle(fontSize: 18, color: noirecrit),
                              ),
                            ]),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: bleufonce,
                          ),
                          onPressed: () {
                            if (i['liste'] == false) {
                              i['liste'] = true;
                            } else {
                              i['liste'] = false;
                            }
                            setState(() {});
                          },
                          child: i['liste'] == true
                              ? Column(children: [
                                  Text(
                                    'Absences (' + i['NbAbs'].toString() + '):',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: bleuclair,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))
                                          // Red border with the width is equal to 5
                                          ),
                                      child: Column(
                                        children: [
                                          for (var j in i['ListeAbsence'])
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 1, 15, 1),
                                              child: Text(
                                                j,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: noirecrit,
                                                    fontSize: 18),
                                              ),
                                            ),
                                        ],
                                      )),
                                  SizedBox(height: 10),
                                ])
                              : Column(children: [
                                  Text(
                                    'Absences (' + i['NbAbs'].toString() + '):',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ]),
                        ),
                        if (i['Tel Portable'] != ' ')
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Numéro 1: ' + i['Tel Portable'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: noirecrit,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                    child: ElevatedButton(
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
                                    launch(
                                        'sms:' + i['Tel Portable'].toString());
                                  },
                                )),
                              ]),
                        if (i['Tel Portable 2'] != ' ')
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Numéro 2: ' + i['Tel Portable 2'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: noirecrit,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                    child: ElevatedButton(
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
                                    launch('sms:' +
                                        i['Tel Portable 2'].toString());
                                  },
                                ))
                              ]),
                        if (i['Email 1'] != null)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  i['Email 1'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: noirecrit,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                    child: ElevatedButton(
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
                                    launch('mailto:' + i['Email 1']);
                                  },
                                )),
                                SizedBox(width: 10),
                              ]),
                        if (i['Email 2'] != null)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  i['Email 2'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: noirecrit,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                    child: ElevatedButton(
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
                                    launch('mailto:' + i['Email 2']);
                                  },
                                ))
                              ]),
                        Container(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: bleuclair,
                            side: BorderSide(color: Colors.black, width: 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('Élève traité',
                              style: TextStyle(fontSize: 18, color: noirecrit)),
                          onPressed: () {
                            traitement(i['Nom'], i['Prénom']);
                          },
                        )),
                      ],
                    )),
            if (rien == true)
              Container(
                  height: 150,
                  child: Center(
                    child: Text(
                      "Il n'y a rien à afficher",
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
