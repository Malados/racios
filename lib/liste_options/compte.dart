import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/liste_options/compte/supprof.dart';
import 'package:racpresence/liste_options/compte/ajoutprof.dart';
// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class Compte extends StatefulWidget {
  Compte({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Compte createState() => _Compte();
}

class _Compte extends State<Compte> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        backgroundColor: bleufonce,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: bleuclair,
                          ),
                          child: Text(
                            "Créer un compte prof",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AjoutProf(title: 'Créer un compte prof')));
                          },
                        )),
                  ),
                ]),
                Row(children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: bleuclair,
                          ),
                          child: Text(
                            "Supprimer un compte prof",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SupProf(
                                    title: "Supprimer un compte prof")));
                          },
                        )),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
