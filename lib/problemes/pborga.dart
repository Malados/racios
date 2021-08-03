import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';

// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class PbOrga extends StatefulWidget {
  PbOrga({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PbOrga createState() => _PbOrga();
}

class _PbOrga extends State<PbOrga> {
  @override
  void initState() {
    super.initState();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Container(
                    color: blancfond,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 3, color: orange),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            width: 350,
                            child: Text(
                              'Il y a un problème:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: noirecrit,
                                fontSize: 18.0,
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "La formation que je veux n'apparaît pas: aller dans paramètres -> 'Eleve' -> créer un élève dans cette formation.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Les cours ne s'enregistrent pas: il faut enregistrer les changements (bouton + en bas à droite) avant de quitter.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Le cours que je viens de créer s'est mis à un mauvais endroit ou n'apparaît pas: enregister et quitter, puis revenir, ça résout souvent le problème.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Je ne peux pas créer un élève: il existe peut-être déjà, vérifier dans la fonction recherche de l'application.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Les cours ne s'ajoutent pas à un élève: il y a peut-être une faute quand vous l'avez ajouter au cours.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Où va l'export excel: fichier racine -> Downloads (ou Téléchargements, ça dépend) - fichier 'EDT RAC EXCEL'.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: bleufonce),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))
                                // Red border with the width is equal to 5
                                ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "L'application crash au moment d'enregistrer: probablement une faute dans le nom / prénom d'un prof",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                              ],
                            )),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
