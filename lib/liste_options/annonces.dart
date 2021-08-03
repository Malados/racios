import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:racpresence/couleur.dart';

class Annonces extends StatefulWidget {
  Annonces({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Annonces createState() => _Annonces();
}

final admin = FirebaseAuth.instance;
var adminos;

class _Annonces extends State<Annonces> {
  var newannonce = false;

  final auth = FirebaseAuth.instance;
  var probleme = "";
  var quit = false;
  void changeniveaux() async {}
  var cliqued = [];
  var addepreuve = [];
  var estdate = false;
  var estsigne = false;
  var _corpscontroll = TextEditingController();
  String _corps = "";
  var _titrecontroll = TextEditingController();
  String _titre = "";
  var _case = Color(4294967295);
  var _contour = Color(4294901760);
  var _texte = Color(4294901760);
  var _epaisseur = 2.0;
  var _police = 25.0;
  var personnaliser = false;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];
  void changeColorcase(Color color) => setState(() {
        _case = color;
      });
  void changeColorecriture(Color color) => setState(() => _texte = color);
  void changeColorcontour(Color color) => setState(() => _contour = color);

  void delannonce(String titre) async {
    var cible = await FirebaseFirestore.instance
        .collection('annonces')
        .where('titre', isEqualTo: titre)
        .get();

    FirebaseFirestore.instance
        .collection('annonces')
        .doc(cible.docs[0].id)
        .delete();
  }

  var iduser;
  void user() async {
    var uid = auth.currentUser!.uid;
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
    iduser = result.docs[0]['Nom'] + " " + result.docs[0]['Prénom'];
    adminos = result.docs[0]['admin'];
  }

  @override
  void initState() {
    user();
    super.initState();
  }

  void addannonce() async {
    var date = DateTime.now();
    var datos = date.day.toString() +
        '/' +
        date.month.toString() +
        " " +
        date.hour.toString() +
        ':' +
        date.minute.toString();

    await FirebaseFirestore.instance.collection('annonces').add({
      'titre': _titre,
      'corps': _corps,
      'contour': _contour.value,
      'case': _case.value,
      'police': _police,
      'date': datos,
      'texte': _texte.value,
      'epaisseur': _epaisseur,
      'créateur': iduser,
    });
    _corpscontroll.clear();
    _titrecontroll.clear();
    _case = Color(4294967295);
    _contour = Color(4294901760);
    _texte = Color(4294901760);
    _epaisseur = 2.0;
    _police = 25.0;
    personnaliser = false;
    _corps = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blancfond,
        appBar: AppBar(centerTitle: true,
          backgroundColor: bleufonce,
          title: Text(widget.title),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: newannonce == true
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(children: [
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(35, 5, 35, 25),
                                child: Row(children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: bleuclair,
                                          side: BorderSide(
                                              color: Colors.black, width: 1),
                                          elevation: 0,
                                          fixedSize: Size(1, 50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      child: Text(
                                        "Annuler l'annonce",
                                        style: TextStyle(
                                            fontSize: 18, color: noirecrit),
                                        textAlign: TextAlign.center,
                                      ),
                                      onPressed: () {
                                        newannonce = false;

                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 100, 10),
                                child: Row(children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: TextField(
                                        controller: _titrecontroll,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          hintText: "Titre de l'annonce",
                                          hintStyle: TextStyle(fontSize: 20),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: bleufonce, width: 2.0),
                                          ),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 12, 10, 12),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _titre = value.trim();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(15, 2, 0, 3),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Signer: ',
                                        style: TextStyle(color: noirecrit),
                                      ),
                                    ),
                                    Container(
                                      child: FlutterSwitch(
                                        activeColor: bleufonce,
                                        width: 60,
                                        height: 30,
                                        value: estsigne,
                                        borderRadius: 30.0,
                                        onToggle: (val) {
                                          setState(() {
                                            estsigne = val;
                                            if (estsigne == true) {
                                              _corps =
                                                  _corps + '\nSigné: ' + iduser;
                                            } else {
                                              var split =
                                                  _corps.split('\nSigné: ');
                                              _corps = split[0];
                                            }
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(15, 2, 0, 3),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text('Dater: ',
                                          style: TextStyle(color: noirecrit)),
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      child: FlutterSwitch(
                                        activeColor: bleufonce,
                                        width: 60,
                                        height: 30,
                                        value: estdate,
                                        borderRadius: 30.0,
                                        onToggle: (val) {
                                          setState(() {
                                            estdate = val;
                                            if (estdate == true) {
                                              var date = DateTime.now();
                                              var datos = date.day.toString() +
                                                  '/' +
                                                  date.month.toString() +
                                                  " " +
                                                  date.hour.toString() +
                                                  ':' +
                                                  date.minute.toString() +
                                                  ' | ';
                                              _corps = datos + _corps;
                                            } else {
                                              var split = _corps.split('|');
                                              if (split.length > 1) {
                                                _corps = split[1];
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 140,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      expands: true,
                                      controller: _corpscontroll,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: bleufonce, width: 2.0),
                                        ),
                                        hintText: "Annonce",
                                        hintStyle: TextStyle(fontSize: 20),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                10, 12, 10, 12),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _corps = value.trim();
                                        });
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: bleuclair,
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                      elevation: 0,
                                      fixedSize: Size(150, 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  child: Text("Ajouter l'annonce"),
                                  onPressed: () {
                                    newannonce = false;
                                    addannonce();
                                    setState(() {});
                                  },
                                ),
                              ),
                              if (_corps != '')
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          height: 152,
                                          decoration: BoxDecoration(
                                              color: _case,
                                              border: Border.all(
                                                  width: _epaisseur,
                                                  color: _contour),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 3, 10, 3),
                                          child: Text(_corps,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: _texte,
                                                  fontSize: _police))),
                                    )
                                  ],
                                ),
                              Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: bleuclair,
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  child: Text("Personnaliser l'annonce"),
                                  onPressed: () {
                                    if (personnaliser == true) {
                                      personnaliser = false;
                                    } else {
                                      personnaliser = true;
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                              if (personnaliser == true)
                                Column(children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Couleur case:',
                                          style: TextStyle(
                                              fontSize: 18.0, color: noirecrit),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 5),
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: _case,
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    titlePadding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: SlidePicker(
                                                        pickerColor: _case,
                                                        onColorChanged:
                                                            changeColorcase,
                                                        paletteType:
                                                            PaletteType.rgb,
                                                        enableAlpha: false,
                                                        displayThumbColor: true,
                                                        showLabel: false,
                                                        showIndicator: true,
                                                        indicatorBorderRadius:
                                                            const BorderRadius
                                                                .vertical(
                                                          top: const Radius
                                                              .circular(25.0),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child:
                                                const Text('Change me again'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Couleur écriture:',
                                          style: TextStyle(
                                              fontSize: 18.0, color: noirecrit),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 5),
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: _texte,
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    titlePadding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: SlidePicker(
                                                        pickerColor: _texte,
                                                        onColorChanged:
                                                            changeColorecriture,
                                                        paletteType:
                                                            PaletteType.rgb,
                                                        enableAlpha: false,
                                                        displayThumbColor: true,
                                                        showLabel: false,
                                                        showIndicator: true,
                                                        indicatorBorderRadius:
                                                            const BorderRadius
                                                                .vertical(
                                                          top: const Radius
                                                              .circular(25.0),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child:
                                                const Text('Change me again'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Couleur bordure:',
                                          style: TextStyle(
                                              fontSize: 18.0, color: noirecrit),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 5),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: _texte,
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    titlePadding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: SlidePicker(
                                                        pickerColor: _texte,
                                                        onColorChanged:
                                                            changeColorcontour,
                                                        paletteType:
                                                            PaletteType.rgb,
                                                        enableAlpha: false,
                                                        displayThumbColor: true,
                                                        showLabel: false,
                                                        showIndicator: true,
                                                        indicatorBorderRadius:
                                                            const BorderRadius
                                                                .vertical(
                                                          top: const Radius
                                                              .circular(25.0),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child:
                                                const Text('Change me again'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Bordure: ',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: noirecrit),
                                              ),
                                            ),
                                            Container(
                                              width: 160,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                      child: _epaisseur > 0
                                                          ? ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary:
                                                                    Colors.red,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1),
                                                                elevation: 0,
                                                                fixedSize: Size(
                                                                    30, 30),
                                                                shape:
                                                                    CircleBorder(),
                                                              ),
                                                              child: Icon(
                                                                  Icons.remove),
                                                              onPressed: () {
                                                                _epaisseur =
                                                                    _epaisseur -
                                                                        1.0;
                                                                setState(() {});
                                                              },
                                                            )
                                                          : SizedBox(
                                                              width: 65,
                                                            )),
                                                  Container(
                                                    width: 30,
                                                    child: Text(
                                                      (_epaisseur.round())
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.green,
                                                      side: BorderSide(
                                                          color: Colors.black,
                                                          width: 1),
                                                      elevation: 0,
                                                      fixedSize: Size(30, 30),
                                                      shape: CircleBorder(),
                                                    ),
                                                    child: Icon(Icons.add),
                                                    onPressed: () {
                                                      _epaisseur =
                                                          _epaisseur + 1.0;
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ])),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Police: ',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: noirecrit),
                                              ),
                                            ),
                                            Container(
                                              width: 160,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                      child: _police > 0
                                                          ? ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary:
                                                                    Colors.red,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1),
                                                                elevation: 0,
                                                                fixedSize: Size(
                                                                    30, 30),
                                                                shape:
                                                                    CircleBorder(),
                                                              ),
                                                              child: Icon(
                                                                  Icons.remove),
                                                              onPressed: () {
                                                                _police =
                                                                    _police -
                                                                        1.0;
                                                                setState(() {});
                                                              },
                                                            )
                                                          : SizedBox(
                                                              width: 65,
                                                            )),
                                                  Container(
                                                    width: 30,
                                                    child: Text(
                                                      (_police.round())
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.green,
                                                      side: BorderSide(
                                                          color: Colors.black,
                                                          width: 1),
                                                      elevation: 0,
                                                      fixedSize: Size(30, 30),
                                                      shape: CircleBorder(),
                                                    ),
                                                    child: Icon(Icons.add),
                                                    onPressed: () {
                                                      _police = _police + 1.0;
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ])),
                                ]),
                            ]))
                        : Container(
                            margin: const EdgeInsets.fromLTRB(35, 5, 35, 5),
                            child: Row(children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: bleuclair,
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                      elevation: 0,
                                      fixedSize: Size(1, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  child: Text(
                                    'Créer une annonce',
                                    style: TextStyle(
                                        color: noirecrit, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    newannonce = true;

                                    setState(() {});
                                  },
                                ),
                              ),
                            ]),
                          ),
                  ),
                  Container(
                    child: Text(
                      'Pour supprimer une annonce, appuyer longuement dessus',
                      style: TextStyle(color: noirecrit),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('annonces')
                        .orderBy('date')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!.docs
                              .map(
                                (e) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          35, 5, 35, 5),
                                      child: cliqued.contains(e['titre'])
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Colors.grey[300],
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1),
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Text(e['titre'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    20.0)),
                                                        onLongPress: () {
                                                          if (adminos == true ||
                                                              iduser ==
                                                                  e['créateur'])
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  titlePadding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          0.0),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          0.0),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                  ),
                                                                  content:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                    height: 110,
                                                                    child: Column(
                                                                        children: [
                                                                          Container(
                                                                              child: Text("Supprimer l'annonce '" + e['titre'] + "'")),
                                                                          Container(
                                                                            margin: const EdgeInsets.fromLTRB(
                                                                                0,
                                                                                10,
                                                                                0,
                                                                                15),
                                                                            child:
                                                                                ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                primary: Colors.red,
                                                                                side: BorderSide(color: Colors.black, width: 1),
                                                                                elevation: 0,
                                                                                fixedSize: Size(150, 30),
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              ),
                                                                              child: Text('Supprimer'),
                                                                              onPressed: () {
                                                                                delannonce(e['titre']);
                                                                                Navigator.of(context).pop();
                                                                                setState(() {});
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                        },
                                                        onPressed: () async {
                                                          setState(() {
                                                            cliqued.remove(
                                                                e['titre']);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                          height: 152,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  e['case']),
                                                              border: Border.all(
                                                                  width: e[
                                                                      'epaisseur'],
                                                                  color: Color(e[
                                                                      'contour'])),
                                                              borderRadius: BorderRadius.all(Radius.circular(
                                                                  10))),
                                                          padding: const EdgeInsets.fromLTRB(
                                                              10, 3, 10, 3),
                                                          child: Text(e['corps'],
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  color: Color(e['texte']),
                                                                  fontSize: e['police']))),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.grey[300],
                                                      side: BorderSide(
                                                          color: Colors.black,
                                                          width: 1),
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                    ),
                                                    child: Text(e['titre'],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0)),
                                                    onLongPress: () {
                                                      if (adminos == true ||
                                                          iduser ==
                                                              e['créateur'])
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              titlePadding:
                                                                  const EdgeInsets
                                                                      .all(0.0),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0.0),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                              ),
                                                              content:
                                                                  Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                height: 110,
                                                                child: Column(
                                                                    children: [
                                                                      Container(
                                                                          child: Text("Supprimer l'annonce '" +
                                                                              e['titre'] +
                                                                              "'")),
                                                                      Container(
                                                                        margin: const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            15),
                                                                        child:
                                                                            ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            primary:
                                                                                Colors.red,
                                                                            side:
                                                                                BorderSide(color: Colors.black, width: 1),
                                                                            elevation:
                                                                                0,
                                                                            fixedSize:
                                                                                Size(150, 30),
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          ),
                                                                          child:
                                                                              Text('Supprimer'),
                                                                          onPressed:
                                                                              () {
                                                                            delannonce(e['titre']);
                                                                            Navigator.of(context).pop();
                                                                            setState(() {});
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                    },
                                                    onPressed: () async {
                                                      setState(() {
                                                        cliqued.add(e['titre']);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                    )
                                  ],
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )));
  }
}
