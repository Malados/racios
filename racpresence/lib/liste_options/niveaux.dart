import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/problemes/pbniveau.dart';

class Niveaux extends StatefulWidget {
  Niveaux({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Niveaux createState() => _Niveaux();
}

final admin = FirebaseAuth.instance;

class _Niveaux extends State<Niveaux> {
  bool addniveau = false;
  final auth = FirebaseAuth.instance;
  var probleme = "";
  var quit = false;
  var cliqued = [];
  var addepreuve = [];

  var _nomnewniveaucontroll = TextEditingController();
  String _nomnewniveau = "";
  var _ordrenewniveaucontroll = TextEditingController();
  String _ordrenewniveau = "";

  var _nomniveaucontroll = TextEditingController();
  String _nomniveau = "";
  var _ordreniveaucontroll = TextEditingController();
  String _ordreniveau = "";
  var _epreuvecontroll = TextEditingController();
  String _epreuve = "";
  var _nbepreuvecontroll = TextEditingController();
  String _nbepreuve = "";

  void newniveau() async {
    await FirebaseFirestore.instance.collection('niveaux').add({
      'nom': capitalize(_nomnewniveau),
      'ordre': num.parse(_ordrenewniveau),
      'epreuve': [],
    });
    _nomnewniveaucontroll.clear();
    _ordrenewniveaucontroll.clear();
  }

  void delniveau(String nom) async {
    var cible = await FirebaseFirestore.instance
        .collection('niveaux')
        .where('nom', isEqualTo: nom)
        .get();

    FirebaseFirestore.instance
        .collection('niveaux')
        .doc(cible.docs[0].id)
        .delete();
  }

  void changeparam(var nom) async {
    var cible = await FirebaseFirestore.instance
        .collection('niveaux')
        .where('nom', isEqualTo: nom)
        .get();

    var newnom;
    var newordre;

    if (_nomniveau == '') {
      newnom = cible.docs[0]['nom'];
    } else {
      newnom = capitalize(_nomniveau);
    }
    if (_ordreniveau == '') {
      newordre = cible.docs[0]['ordre'].toString();
    } else {
      newordre = _ordreniveau;
    }

    FirebaseFirestore.instance
        .collection('niveaux')
        .doc(cible.docs[0].id)
        .update({
      'nom': newnom,
      'ordre': num.parse(newordre),
    });
    _nomniveaucontroll.clear();
    _ordreniveaucontroll.clear();
  }

  void newepreuve(var nom) async {
    var cible = await FirebaseFirestore.instance
        .collection('niveaux')
        .where('nom', isEqualTo: nom)
        .get();

    var map = {};
    map['epreuve'] = _epreuve;
    map['nombre'] = _nbepreuve;
    var templist = cible.docs[0]['epreuve'];
    templist.add(map);
    FirebaseFirestore.instance
        .collection('niveaux')
        .doc(cible.docs[0].id)
        .update({
      'epreuve': templist,
    });
    _epreuvecontroll.clear();
    _nbepreuvecontroll.clear();
  }

  void supepreuve(String nom, var ep) async {
    var cible = await FirebaseFirestore.instance
        .collection('niveaux')
        .where('nom', isEqualTo: nom)
        .get();
    cible.docs.forEach((res) {
      var templist = res.data()['epreuve'];
      print(templist.indexOf(ep));
      print(templist.toString());
      var indexos;
      for (var i in templist) {
        if (ep.toString() == i.toString()) {
          indexos = templist.indexOf(i);
          break;
        }
      }
      templist.removeAt(indexos);
      print(templist.toString());
      FirebaseFirestore.instance.collection('niveaux').doc(res.id).update({
        'epreuve': templist,
      });
    });
  }

  final CollectionReference fireref =
      FirebaseFirestore.instance.collection('niveaux');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blancfond,
        appBar: AppBar(
          backgroundColor: bleufonce,
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PbNiveau(title: "J'ai un problème")));
                },
                icon: Icon(Icons.contact_support)),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              Flexible(
                  fit: FlexFit.loose,
                  child: StreamBuilder(
                    stream: fireref.orderBy('ordre').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map(
                                (e) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          35, 5, 35, 5),
                                      child: cliqued.contains(e['nom'])
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
                                                          primary: bleuclair,
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
                                                        child: Text(
                                                            e['nom'] +
                                                                ' (' +
                                                                e['ordre']
                                                                    .toString() +
                                                                ')',
                                                            style: TextStyle(
                                                                color:
                                                                    noirecrit,
                                                                fontSize:
                                                                    20.0)),
                                                        onLongPress: () {
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
                                                                            child: Text('Supprimer le niveau "' + e['nom'] + '"',
                                                                                style: TextStyle(
                                                                                  color: noirecrit,
                                                                                ))),
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
                                                                              primary: Colors.red,
                                                                              side: BorderSide(color: Colors.black, width: 1),
                                                                              elevation: 0,
                                                                              fixedSize: Size(150, 30),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Supprimer',
                                                                              style: TextStyle(
                                                                                color: noirecrit,
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                              delniveau(e['nom']);
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
                                                          quit = true;

                                                          setState(() {
                                                            cliqued.remove(
                                                                e['nom']);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(children: [
                                                  Expanded(
                                                      child: Text(
                                                    'Changer nom niveau:  ',
                                                    style: TextStyle(
                                                      color: noirecrit,
                                                    ),
                                                  )),
                                                  Expanded(
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        hintText: e['nom'],
                                                        hintStyle: TextStyle(
                                                            fontSize: 20),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide(
                                                                  color:
                                                                      bleufonce,
                                                                  width: 2.0),
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 0, 0, 0),
                                                      ),
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      controller:
                                                          _nomniveaucontroll,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _nomniveau =
                                                              value.trim();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(children: [
                                                  Expanded(
                                                      child: Text(
                                                    'Changer ordre épreuve:  ',
                                                    style: TextStyle(
                                                      color: noirecrit,
                                                    ),
                                                  )),
                                                  Expanded(
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        hintText: capitalize(
                                                            e['ordre']
                                                                .toString()),
                                                        hintStyle: TextStyle(
                                                            fontSize: 20),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide(
                                                                  color:
                                                                      bleufonce,
                                                                  width: 2.0),
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 0, 0, 0),
                                                      ),
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      controller:
                                                          _ordreniveaucontroll,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _ordreniveau =
                                                              value.trim();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                                for (var i in e['epreuve'])
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(0, 5, 0, 5),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 5, 5, 5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          i['epreuve'],
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color: noirecrit),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                        Expanded(
                                                            child: Text(
                                                          i['nombre']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: noirecrit,
                                                              fontSize: 18),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                        Container(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
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
                                                                    CircleBorder()),
                                                            child: Icon(
                                                                Icons.close),
                                                            onPressed: () {
                                                              supepreuve(
                                                                  e['nom'], i);
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (addepreuve.contains(e.id))
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                if (addepreuve.contains(e.id))
                                                  Row(children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 10, 0),
                                                        child: TextField(
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          controller:
                                                              _epreuvecontroll,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            hintText:
                                                                "Nom épreuve",
                                                            hintStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        20),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          bleufonce,
                                                                      width:
                                                                          2.0),
                                                            ),
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    0,
                                                                    0),
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _epreuve =
                                                                  value.trim();
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: TextField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        controller:
                                                            _nbepreuvecontroll,
                                                        decoration:
                                                            InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText: "Nombre",
                                                          hintStyle: TextStyle(
                                                              fontSize: 20),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                BorderSide(
                                                                    color:
                                                                        bleufonce,
                                                                    width: 2.0),
                                                          ),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 0, 0, 0),
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _nbepreuve =
                                                                value.trim();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.green,
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1),
                                                          elevation: 0,
                                                          fixedSize:
                                                              Size(30, 30),
                                                          shape: CircleBorder(),
                                                        ),
                                                        child: Icon(Icons.add),
                                                        onPressed: () {
                                                          newepreuve(e['nom']);
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ]),
                                                SizedBox(height: 10),
                                                Container(
                                                  child: addepreuve
                                                          .contains(e.id)
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                              Container(
                                                                width: 100,
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    primary: Colors
                                                                        .green,
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1),
                                                                    elevation:
                                                                        0,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                  ),
                                                                  child: Icon(
                                                                      Icons
                                                                          .close),
                                                                  onPressed:
                                                                      () {
                                                                    addepreuve
                                                                        .remove(
                                                                            e.id);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              ),
                                                            ])
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                              Container(
                                                                width: 100,
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    primary: Colors
                                                                        .green,
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1),
                                                                    elevation:
                                                                        0,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                  ),
                                                                  child: Icon(
                                                                      Icons
                                                                          .add),
                                                                  onPressed:
                                                                      () {
                                                                    addepreuve
                                                                        .add(e
                                                                            .id);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              ),
                                                            ]),
                                                ),
                                                if (_nomniveau != '' ||
                                                    _ordreniveau != '')
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.green,
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1),
                                                              elevation: 0,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            ),
                                                            child: Text(
                                                                'Changer',
                                                                style: TextStyle(
                                                                    color:
                                                                        noirecrit,
                                                                    fontSize:
                                                                        15.0)),
                                                            onPressed:
                                                                () async {
                                                              changeparam(
                                                                  e['nom']);
                                                            },
                                                          ),
                                                        ),
                                                      ]),
                                              ],
                                            )
                                          : Row(children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.white,
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
                                                  child: Text(
                                                      capitalize(e['nom']) +
                                                          ' (' +
                                                          e['ordre']
                                                              .toString() +
                                                          ')',
                                                      style: TextStyle(
                                                          color: noirecrit,
                                                          fontSize: 20.0)),
                                                  onLongPress: () {
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
                                                          content: Container(
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
                                                                      child:
                                                                          Text(
                                                                    'Supprimer le niveau "' +
                                                                        e['nom'] +
                                                                        '"',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          noirecrit,
                                                                    ),
                                                                  )),
                                                                  Container(
                                                                    margin:
                                                                        const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            15),
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            Colors.red,
                                                                        side: BorderSide(
                                                                            color:
                                                                                Colors.black,
                                                                            width: 1),
                                                                        elevation:
                                                                            0,
                                                                        fixedSize: Size(
                                                                            150,
                                                                            30),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        'Supprimer',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              noirecrit,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        delniveau(
                                                                            e['nom']);
                                                                        setState(
                                                                            () {});
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
                                                    quit = true;

                                                    setState(() {
                                                      cliqued.add(e['nom']);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ]),
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
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                child: addniveau == true
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(35, 5, 35, 5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: bleuclair,
                                          side: BorderSide(
                                              color: Colors.black, width: 0),
                                          elevation: 0,
                                          fixedSize: Size(1, 48),
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                          ))),
                                      child: Text(
                                        'Ajouter un niveau',
                                        style: TextStyle(
                                            color: noirecrit, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      onPressed: () async {
                                        quit = true;

                                        setState(() {
                                          addniveau = false;
                                        });
                                      },
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                            child: Row(children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    controller: _nomnewniveaucontroll,
                                    decoration: InputDecoration(
                                      hintText: "Nom niveau",
                                      hintStyle: TextStyle(fontSize: 20),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _nomnewniveau = value.trim();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    controller: _ordrenewniveaucontroll,
                                    decoration: InputDecoration(
                                      hintText: "Ordre",
                                      hintStyle: TextStyle(fontSize: 20),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _ordrenewniveau = value.trim();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                      elevation: 0,
                                      fixedSize: Size(30, 30),
                                      shape: CircleBorder()),
                                  child: Icon(Icons.add),
                                  onPressed: () {
                                    newniveau();
                                    addniveau = false;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ]),
                          ),
                        ]))
                    : Container(
                        margin: const EdgeInsets.fromLTRB(35, 5, 35, 5),
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  side:
                                      BorderSide(color: Colors.black, width: 1),
                                  elevation: 0,
                                  fixedSize: Size(1, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              child: Text(
                                'Ajouter un niveau',
                                style:
                                    TextStyle(color: noirecrit, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                quit = true;

                                setState(() {
                                  addniveau = true;
                                });
                              },
                            ),
                          ),
                        ]),
                      ),
              ),
            ],
          ),
        ));
  }
}
