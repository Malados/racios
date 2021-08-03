import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class PbBdd extends StatefulWidget {
  PbBdd({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PbBdd createState() => _PbBdd();
}

class _PbBdd extends State<PbBdd> {
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
                                  "Solution 1: Attention à l'ordre d'appuie des boutons. D'abord le fichier qui contient les élèves, et ensuite celui avec les cours.",
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
                                  "Solution 2: Appuyer sur le bouton 'nouvelle année' et reprendre les étapes depuis l'application.",
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
                                  "Solution 3: Aller sur le site de Firebase et regarder dans le panneau à gauche les options 'Firestore' et 'realtime database'. Aller dans 'utilisation' voir si la limite a été atteinte.",
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
                                  "Solution 4: Toujours sur Firebase, regarder si, après avoir appuyé sur 'nouvelle année', il reste des résidus qui peuvent poser problème: dans realtime, il ne doit rester que '3abs', et dans firestore que 'niveaux' et 'users'.",
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
                                  "Solution 5: M'envoyer un message",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
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
                                    launch('sms:0786222928');
                                  },
                                )
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
