import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';

class AjoutEleve extends StatefulWidget {
  AjoutEleve({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AjoutEleve createState() => _AjoutEleve();
}

final admin = FirebaseAuth.instance;

class _AjoutEleve extends State<AjoutEleve> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return bleufonce;
  }

  final bdd = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference();
  final bddeleve = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('eleves');
  final auth = FirebaseAuth.instance;
  var probleme = "";
  var quit = false;
  void addeleve() async {
    var nom = capitalize(_nomeleve);
    var prenom = capitalize(_prenomeleve);
    var checkos = await bddeleve.child(nom + prenom).once();
    if (checkos.value != null) {
      final snackBar = SnackBar(
        content: Text('Cet élève existe déjà'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (_sortie == false) {
        sortie = 'non';
      } else {
        sortie = 'oui';
      }
      if (_image == false) {
        image = 'non';
      } else {
        image = 'oui';
      }
      var sexe;
      if (M == true) {
        sexe = 'M';
      } else {
        sexe = 'F';
      }
      if (_licence == '') {
        _licence = ' ';
      }
      if (_certificat == '') {
        _certificat = ' ';
      }
      if (_classement == '') {
        _classement = 'NC';
      }
      if (_tel1 == ''){
        _tel1 = ' ';
      }
      if (_tel2 == ''){
        _tel2 = ' ';
      }
      var listformations = await bdd.child('Formations').once();
      var vrailiste = List.from(listformations.value);
      if (vrailiste.contains(_formation) == false) {
        vrailiste.add(_formation);
        bdd.update({'Formations': vrailiste});
      }
      bddeleve.child(nom + prenom).update({
        "Nom": nom,
        "Prénom": prenom,
        "Email 1": _mail1,
        "Email 2": _mail2,
        "Formation": _formation,
        "Certificat": _certificat,
        "Date Naissance": _naissance,
        "Sexe": sexe,
        "Niveau présumé": _niveau,
        "Classement": _classement,
        "Licence": _licence,
        "Droit image": image,
        "Autorisation sortie": sortie,
        "Adresse": _adresse,
        "Tel Portable": _tel1,
        "Tel Portable 2": _tel2,
        'Présence': {'vide': 'vide'},
        'Cours': ['vide'],
        'Epreuves': ['vide'],
      });
      var result = await FirebaseFirestore.instance
          .collection('parents')
          .where('mail', isEqualTo: _mail1)
          .get();
      if (result.docs.length != 0) {
        var listos = result.docs[0].data()['enfants'];
        listos.add(capitalize(nom) + ' ' + capitalize(prenom));
        FirebaseFirestore.instance
            .collection('parents')
            .doc(result.docs[0].id)
            .update({
          'enfants': listos,
        });
      } else {
        var mdp = _naissance.split('/');
        try {
          await auth.createUserWithEmailAndPassword(
              email: _mail1, password: mdp[0] + mdp[1] + mdp[2]);
        } on FirebaseAuthException {}
        FirebaseFirestore.instance.collection('parents').add({
          'mail': _mail1,
          'enfants': [capitalize(nom) + ' ' + capitalize(prenom)],
        });
      }

      var result2 = await FirebaseFirestore.instance
          .collection('parents')
          .where('mail', isEqualTo: _mail2)
          .get();
      if (result.docs.length != 0) {
        var listos = result2.docs[0].data()['enfants'];
        listos.add(capitalize(nom) + ' ' + capitalize(prenom));
        FirebaseFirestore.instance
            .collection('parents')
            .doc(result2.docs[0].id)
            .update({
          'enfants': listos,
        });
      } else {
        var mdp = _naissance.split('/');
        try {
          await auth.createUserWithEmailAndPassword(
              email: _mail2, password: mdp[0] + mdp[1] + mdp[2]);
        } on FirebaseAuthException{}
        FirebaseFirestore.instance.collection('parents').add({
          'mail': _mail2,
          'enfants': [capitalize(nom) + ' ' + capitalize(prenom)],
        });
      }
      final snackBar = SnackBar(
        content: Text('Élève ajouté'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _nomelevecontroll.clear();
      _prenomelevecontroll.clear();
      _mailelevecontroll1.clear();
      _mailelevecontroll2.clear();
      _telcontroll1.clear();
      _formationcontroll.clear();
      _telcontroll2.clear();
      _certificatcontroll.clear();
      _naissancecontroll.clear();
      _classementcontroll.clear();
      _licencecontroll.clear();
      _adressecontroll.clear();
      _niveaucontroll.clear();
      _image = false;
      _sortie = false;
      M = false;
      F = false;
    }
  }

  var _nomelevecontroll = TextEditingController();
  String _nomeleve = "";
  var _prenomelevecontroll = TextEditingController();
  String _prenomeleve = "";
  var _mailelevecontroll1 = TextEditingController();
  String _mail1 = "";
  var _mailelevecontroll2 = TextEditingController();
  String _mail2 = "";
  var _telcontroll1 = TextEditingController();
  String _tel1 = "";
  var _formationcontroll = TextEditingController();
  String _formation = "";
  var _telcontroll2 = TextEditingController();
  String _tel2 = "";
  var _certificatcontroll = TextEditingController();
  String _certificat = "";
  var _naissancecontroll = TextEditingController();
  String _naissance = "";
  var _classementcontroll = TextEditingController();
  String _classement = "";
  var _licencecontroll = TextEditingController();
  String _licence = "";
  var _adressecontroll = TextEditingController();
  String _adresse = "";
  var _niveaucontroll = TextEditingController();
  String _niveau = '';

  bool _image = false;
  bool _sortie = false;
  var sortie;
  var image;
  bool M = false;
  bool F = false;
  var marge = EdgeInsets.fromLTRB(25, 5, 25, 5);

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
                margin: marge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Sexe:',
                      style: TextStyle(color: noirecrit),
                    ),
                    Row(
                      children: [
                        Text('M : ', style: TextStyle(color: noirecrit)),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: M,
                          onChanged: (bool? value) {
                            F = false;
                            setState(() {
                              M = value!;
                            });
                          },
                        ),
                        Text('F : ', style: TextStyle(color: noirecrit)),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: F,
                          onChanged: (bool? value) {
                            M = false;
                            setState(() {
                              F = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  controller: _nomelevecontroll,
                  decoration: InputDecoration(
                    hintText: 'Nom',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nomeleve = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  controller: _prenomelevecontroll,
                  decoration: InputDecoration(
                    hintText: 'Prénom',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _prenomeleve = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.datetime,
                  controller: _naissancecontroll,
                  decoration: InputDecoration(
                    hintText: 'Date de naissance',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _naissance = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.emailAddress,
                  controller: _mailelevecontroll1,
                  decoration: InputDecoration(
                    hintText: 'Email 1',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _mail1 = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.emailAddress,
                  controller: _mailelevecontroll2,
                  decoration: InputDecoration(
                    hintText: 'Email 2',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _mail2 = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  controller: _niveaucontroll,
                  decoration: InputDecoration(
                    hintText: 'Niveau présumé',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _niveau = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  controller: _formationcontroll,
                  decoration: InputDecoration(
                    hintText: 'Formation',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _formation = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.streetAddress,
                  controller: _adressecontroll,
                  decoration: InputDecoration(
                    hintText: 'Adresse',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _adresse = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.phone,
                  controller: _telcontroll1,
                  decoration: InputDecoration(
                    hintText: 'Téléphone 1',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _tel1 = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.phone,
                  controller: _telcontroll2,
                  decoration: InputDecoration(
                    hintText: 'Téléphone 2',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _tel2 = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  controller: _licencecontroll,
                  decoration: InputDecoration(
                    hintText: 'Licence',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _licence = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  keyboardType: TextInputType.datetime,
                  controller: _certificatcontroll,
                  decoration: InputDecoration(
                    hintText: 'Validité certificat médical',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _certificat = value.trim();
                    });
                  },
                ),
              ),
              Container(
                margin: marge,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  controller: _classementcontroll,
                  decoration: InputDecoration(
                    hintText: 'Classement',
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: bleufonce),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _classement = value.trim();
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Autorisation de sortie:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: noirecrit,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: FlutterSwitch(
                      activeColor: bleufonce,
                      width: 60,
                      height: 30,
                      value: _sortie,
                      borderRadius: 30.0,
                      onToggle: (val) {
                        setState(() {
                          _sortie = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Droit image:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: noirecrit,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: FlutterSwitch(
                      activeColor: bleufonce,
                      width: 60,
                      height: 30,
                      value: _image,
                      borderRadius: 30.0,
                      onToggle: (val) {
                        setState(() {
                          _image = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: bleuclair,
                  ),
                  child: Text("Créer l'élève"),
                  onPressed: () async {
                    quit = true;
                    addeleve();
                    _nomelevecontroll.clear();
                    _prenomelevecontroll.clear();
                    _mailelevecontroll1.clear();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
