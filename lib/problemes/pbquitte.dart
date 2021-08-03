import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class Pbquitte extends StatefulWidget {
  Pbquitte({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Pbquitte createState() => _Pbquitte();
}

class _Pbquitte extends State<Pbquitte> {
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
        child: Column(children: [
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
                        borderRadius: BorderRadius.all(Radius.circular(10))
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
                      borderRadius: BorderRadius.all(Radius.circular(10))
                      // Red border with the width is equal to 5
                      ),
                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "En cas de problème (bouton qui ne marche pas, application qui ne répond plus, options qui manquent, etc...), quitter l'application et la relancer ( maintenir l'application -> info sur l'appli -> forcer l'arrêt ) résoudra le problème.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Sinon, un admin ( Éric ) peut supprimer votre compte et vous en refaire un.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Si malgré ça, ça ne marche toujours pas, ou que vous voulez me féliciter pour cette superbe appli,  envoyez moi un message :",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: bleufonce,
                        side: BorderSide(color: Colors.black, width: 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Icon(Icons.sms),
                      onPressed: () {
                        launch('sms:0786222928');
                      },
                    )
                  ]),
                ),
              ],
            ),
          ))
        ]),
      ),
    );
  }
}
