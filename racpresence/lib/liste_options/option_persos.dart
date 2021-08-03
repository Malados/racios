import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/liste_options/options%20perso/changecouleur.dart';
import 'package:racpresence/liste_options/options%20perso/changemdp.dart';
import 'package:racpresence/liste_options/options%20perso/telephone.dart';
// ignore: import_of_legacy_library_into_null_safe
var currentUser = FirebaseAuth.instance.currentUser;

class Options_Perso extends StatefulWidget {
  Options_Perso({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Options_Perso createState() => _Options_Perso();
}

class _Options_Perso extends State<Options_Perso> {
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
        title: Text(widget.title),
        centerTitle: true,
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
                            "Changer ses couleurs",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Changecouleur(
                                    title: 'Changer ses couleurs')));
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
                            "Changer mot de passe",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Changemdp(
                                    title: 'Changer son mot de passe')));
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
                            "Enregistrer son numéro de téléphone",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Num_tel(title: 'Enregistrer son numéro')));
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
