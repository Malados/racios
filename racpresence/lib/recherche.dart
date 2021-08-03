import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/pageeleve.dart';
import 'capitalize.dart';
import 'pageeleve.dart';

class Recherche extends StatefulWidget {
  Recherche({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Recherche createState() => _Recherche();
}

var listeprenom = [];
var listenom = [];
var listos = [];

class _Recherche extends State<Recherche> {
  TextEditingController _searchController = TextEditingController();

  final bddeleves = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('eleves');

  void remplirliste() async {
    var snapnom = await bddeleves
        .orderByChild("Nom")
        .equalTo(capitalize(_searchController.text))
        .once();

    if (snapnom.value != null) {
      Map<dynamic, dynamic> mapnom = snapnom.value;
      var listemp = [];
      mapnom.forEach((key, value) {
        listemp.add([value['Nom'], value['Prénom']]);
      });
      listenom = listemp;
    }
    var snapprenom = await bddeleves
        .orderByChild("Prénom")
        .equalTo(capitalize(_searchController.text))
        .once();
    if (snapprenom.value != null) {
      Map<dynamic, dynamic> mapprenom = snapprenom.value;
      var listemp = [];
      mapprenom.forEach((key, value) {
        listemp.add([value['Nom'], value['Prénom']]);
      });
      listeprenom = listemp;
    }
    listos = listenom + listeprenom;
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  var source;

  bool affiche = false;

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blancfond,
        appBar: AppBar(centerTitle: true,
          title: Text(widget.title),
          backgroundColor: bleufonce,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Chercher un nom ou un prénom',
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(color: bleufonce),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: bleuclair,
                        side: BorderSide(color: Colors.black, width: 1),
                        elevation: 0,
                        fixedSize: Size(0, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Icon(Icons.search),
                      onPressed: () async {
                        setState(() {
                          remplirliste();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var i in listos)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                side: BorderSide(
                                    color: Colors.grey[500]!, width: 2),
                              ),
                              onPressed: () {
                                setState(() {
                                  var nom = i[0];
                                  var prenom = i[1];
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PageEleve(
                                            nom: nom,
                                            prenom: prenom,
                                          )));
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(i[0] + " " + i[1],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: noirecrit,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ]),
        ));
  }
}
