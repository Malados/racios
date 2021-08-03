import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:racpresence/connexion.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';

class AjoutProf extends StatefulWidget {
  AjoutProf({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AjoutProf createState() => _AjoutProf();
}

final admin = FirebaseAuth.instance;
var quit = false;

class _AjoutProf extends State<AjoutProf> {
  final auth = FirebaseAuth.instance;
  var probleme = "";

  void addprof() async {
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: _mailprof, password: "motdepasse")
          .then((newuser) {
        var userliste = newuser.user.toString();
        var tabstring = userliste.split(", ");
        for (var i in tabstring) {
          var tab = i.split(": ");
          if (tab[0] == 'uid') {
            var cut = tab[1].substring(0, tab[1].length - 1);
            var testmail = cut.substring(0, cut.length - 1);
            if (testmail != _mailprof) {
              var nom = capitalize(_nomprof);
              var prenom = capitalize(_prenomprof);
              FirebaseFirestore.instance.collection("users").add({
                "Nom": nom,
                "Prénom": prenom,
                "mail": _mailprof,
                "couleurcase": 4294901760,
                "couleurecriture": 4294967295,
                'admin': _admin,
                'uid': cut,
                'numéro': '0',
                'edt': false,
                'orga': _orga,
              });
            }
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      probleme = e.code;
      setState(() {});
    }
  }

  var _nomprofcontroll = TextEditingController();
  String _nomprof = "";
  var _prenomprofcontroll = TextEditingController();
  String _prenomprof = "";
  var _mailprofcontroll = TextEditingController();
  String _mailprof = "";
  bool _admin = false;
  bool _orga = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleufonce,
        leading: quit == true
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Connexion(
                              title: 'Connexion',
                            )),
                    (Route<dynamic> route) => false,
                  );
                },
              )
            : IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                }),
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
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _mailprofcontroll,
                  decoration: InputDecoration(
                    hintText: 'Mail',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _mailprof = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  children: [
                    Text(
                      'Admin:   ',
                      style: TextStyle(color: noirecrit),
                    ),
                    FlutterSwitch(
                      activeColor: bleufonce,
                      width: 60,
                      height: 30,
                      value: _admin,
                      borderRadius: 30.0,
                      onToggle: (val) {
                        setState(() {
                          _admin = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  children: [
                    Text(
                      "Accès à l'option 'organisation' :     ",
                      style: TextStyle(color: noirecrit),
                    ),
                    FlutterSwitch(
                      activeColor: bleufonce,
                      width: 60,
                      height: 30,
                      value: _orga,
                      borderRadius: 30.0,
                      onToggle: (val) {
                        setState(() {
                          _orga = val;
                        });
                      },
                    ),
                  ],
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
                child: Text("Créer le compte"),
                onPressed: () async {
                  quit = true;
                  addprof();
                  _nomprofcontroll.clear();
                  _prenomprofcontroll.clear();
                  _mailprofcontroll.clear();

                  setState(() {});
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Column(
                  children: [
                    Text(
                      "Admin -> Accès aux options admin dans les paramètres, peut modifier l'appel de n'importe quel cours et traiter les élèves qui ont 3 absences ou +.",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
