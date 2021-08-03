import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:racpresence/couleur.dart';

class Changemdp extends StatefulWidget {
  Changemdp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Changemdp createState() => _Changemdp();
}

class _Changemdp extends State<Changemdp> {
  final auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  var mdp1;
  var mdp2;
  var erreur;
  bool montrer = false;
  bool incorrect = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(centerTitle: true,
        backgroundColor: bleufonce,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  obscureText: !montrer,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      mdp1 = value.trim();
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  obscureText: !montrer,
                  decoration: InputDecoration(
                    hintText: 'Confirmer le mot de passe',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      mdp2 = value.trim();
                    });
                  },
                ),
              ),
            ),
            if (incorrect == true)
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                child: Text(erreur),
              ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  children: [
                    Text(
                      'Afficher le mot de passe   ',
                      style: TextStyle(color: noirecrit),
                    ),
                    FlutterSwitch(
                      activeColor: bleufonce,
                      width: 60,
                      height: 30,
                      value: montrer,
                      borderRadius: 30.0,
                      onToggle: (val) {
                        setState(() {
                          montrer = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(
              height: 50,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: bleuclair,
                  ),
                  child: Text('Changer le mot de passe'),
                  onPressed: () async {
                    if (mdp1 == mdp2) {
                      try {
                        await currentUser!.updatePassword(mdp1).then((_) {});
                      } on FirebaseAuthException catch (e) {
                        erreur = e.code;
                        setState(() {});
                      }
                    } else {
                      incorrect = true;
                      setState(() {});
                    }
                  }),
            ]),
          ]),
        ),
      ),
    );
  }
}
