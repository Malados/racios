import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';

import '../../capitalize.dart';

class Supeleve extends StatefulWidget {
  Supeleve({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Supeleve createState() => _Supeleve();
}

final admin = FirebaseAuth.instance;
var quit = false;

class _Supeleve extends State<Supeleve> {
  final auth = FirebaseAuth.instance;
  var probleme = "";
  final bddeleve = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('eleves');

  void supprof() async {
    bddeleve.child(capitalize(_nomprof) + capitalize(_prenomprof)).remove();
    final snackBar = SnackBar(
      content: Text('Élève supprimé'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  var _nomprofcontroll = TextEditingController();
  String _nomprof = "";
  var _prenomprofcontroll = TextEditingController();
  String _prenomprof = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleufonce,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: TextField(
                  controller: _nomprofcontroll,
                  decoration: InputDecoration(
                    hintText: 'Nom',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nomprof = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: TextField(
                  controller: _prenomprofcontroll,
                  decoration: InputDecoration(
                    hintText: 'Prénom',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _prenomprof = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Text(probleme),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: bleuclair,
                ),
                child: Text("Supprimer l'élève"),
                onPressed: () async {
                  quit = true;
                  supprof();
                  _nomprofcontroll.clear();
                  _prenomprofcontroll.clear();

                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
