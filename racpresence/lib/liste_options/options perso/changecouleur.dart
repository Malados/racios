import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:racpresence/couleur.dart';

class Changecouleur extends StatefulWidget {
  Changecouleur({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Changecouleur createState() => _Changecouleur();
}

class _Changecouleur extends State<Changecouleur> {
  @override
  void initState() {
    changeecriture();
    super.initState();
  }

  void enregistrer() async {
    var user = await fireref.where("uid", isEqualTo: currentUser!.uid).get();
    fireref.doc(user.docs[0].id).update({
      'couleurcase': couleurcase.value,
      'couleurecriture': couleurecriture.value
    });
    final snackBar = SnackBar(
      content: Text('Changement enregistré'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  var id = '';
  final auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  var fireref = FirebaseFirestore.instance.collection('users');

  var couleurcase;
  var couleurecriture;

  void changeecriture() async {
    var user = await fireref.where("uid", isEqualTo: currentUser!.uid).get();
    user.docs.forEach((res) {
      id = res.data()['Nom'] + " " + res.data()['Prénom'];
      couleurcase = Color(res.data()['couleurcase']);
      couleurecriture = Color(res.data()['couleurecriture']);
    });
    setState(() {});
  }

  List<Color> currentColors = [Colors.limeAccent, Colors.green];
  void changeColorcase(Color color) => setState(() => couleurcase = color);
  void changeColorecriture(Color color) =>
      setState(() => couleurecriture = color);
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
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 25, 20, 5),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Couleur case:',
                    style: TextStyle(fontSize: 18.0, color: noirecrit),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: couleurcase,
                        side: BorderSide(color: Colors.black, width: 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.all(0.0),
                              contentPadding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              content: SingleChildScrollView(
                                child: SlidePicker(
                                  pickerColor: couleurcase,
                                  onColorChanged: changeColorcase,
                                  paletteType: PaletteType.rgb,
                                  enableAlpha: false,
                                  displayThumbColor: true,
                                  showLabel: false,
                                  showIndicator: true,
                                  indicatorBorderRadius:
                                      const BorderRadius.vertical(
                                    top: const Radius.circular(25.0),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Change me again'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Couleur écriture:',
                    style: TextStyle(fontSize: 18.0, color: noirecrit),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: couleurecriture,
                        side: BorderSide(color: Colors.black, width: 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.all(0.0),
                              contentPadding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              content: SingleChildScrollView(
                                child: SlidePicker(
                                  pickerColor: couleurecriture,
                                  onColorChanged: changeColorecriture,
                                  paletteType: PaletteType.rgb,
                                  enableAlpha: false,
                                  displayThumbColor: true,
                                  showLabel: false,
                                  showIndicator: true,
                                  indicatorBorderRadius:
                                      const BorderRadius.vertical(
                                    top: const Radius.circular(25.0),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Change me again'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: couleurecriture,
                  primary: couleurcase,
                  side: BorderSide(color: Colors.black, width: 2),
                  elevation: 0,
                  minimumSize: Size(150, 80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  print('couleur case:');
                  print(couleurcase.value);
                  print('couleur ecriture:');
                  print(couleurecriture.value);
                },
                child: Text("Cours de " + id,
                    style: TextStyle(fontSize: 18.0, color: couleurecriture),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: 150),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: bleuclair,
                  side: BorderSide(color: bleufonce, width: 2),
                  minimumSize: Size(150, 80),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  enregistrer();
                },
                child: Text("Enregistrer les changements",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                    textAlign: TextAlign.center),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
