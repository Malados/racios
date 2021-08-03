import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';

class SupProf extends StatefulWidget {
  SupProf({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SupProf createState() => _SupProf();
}

final admin = FirebaseAuth.instance;
var quit = false;

class _SupProf extends State<SupProf> {
  final auth = FirebaseAuth.instance;
  var probleme = "";

  void supprof() async {
    var result = await FirebaseFirestore.instance
        .collection("users")
        .where('Nom', isEqualTo: _nomprof)
        .where('Prénom', isEqualTo: _prenomprof)
        .get();
    FirebaseFirestore.instance.collection("users").doc(result.docs[0].id).delete();
  }

  var _nomprofcontroll = TextEditingController();
  String _nomprof = "";
  var _prenomprofcontroll = TextEditingController();
  String _prenomprof = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(centerTitle: true,
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
                child: Text("Supprimer le compte"),
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
