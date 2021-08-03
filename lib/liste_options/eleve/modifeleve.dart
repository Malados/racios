import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:racpresence/capitalize.dart';
import 'package:racpresence/couleur.dart';

class ModifEleve extends StatefulWidget {
  ModifEleve({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ModifEleve createState() => _ModifEleve();
}

final admin = FirebaseAuth.instance;

class _ModifEleve extends State<ModifEleve> {
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

  final auth = FirebaseAuth.instance;
  var probleme = "";
  var quit = false;
  final bddeleve = FirebaseDatabase(
          databaseURL:
              'https://rac-presence-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('eleves');
  void modifeleve() async {
    var comparos =
        await bddeleve.child(capitalize(_nom) + capitalize(_prenom)).once();

    if (comparos.value != null) {
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

      if (_nomeleve == ' ') {
        _nomeleve = comparos.value['Nom'];
      }
      if (_prenomeleve == ' ') {
        _prenomeleve = comparos.value['Prénom'];
      }
      if (_mail1 == ' ') {
        _mail1 = comparos.value['Email 1'];
      }
      if (_mail2 == ' ') {
        _mail2 = comparos.value['Email 2'];
      }
      if (_formation == ' ') {
        _formation = comparos.value['Formation'];
      }
      if (_certificat == ' ') {
        _certificat = comparos.value['Certificat'];
      }
      if (_naissance == ' ') {
        _naissance = comparos.value['Date Naissance'];
      }
      if (_niveau == ' ') {
        _niveau = comparos.value['Niveau présumé'];
      }
      if (_classement == ' ') {
        _classement = comparos.value['Classement'];
      }
      if (_licence == ' ') {
        _licence = comparos.value['Licence'];
      }
      if (_adresse == ' ') {
        _adresse = comparos.value['Adresse'];
      }
      if (_tel1 == ' ') {
        _tel1 = comparos.value['Tel Portable'];
      }
      if (_tel2 == ' ') {
        _tel2 = comparos.value['Tel Portable 2'];
      }

      bddeleve.child(capitalize(_nomeleve) + capitalize(_prenomeleve)).update({
        "Nom": capitalize(_nomeleve),
        "Prénom": capitalize(_prenomeleve),
        'Epreuves': comparos.value['Epreuves'],
        'Cours': comparos.value['Cours'],
        'Sexe': comparos.value['Sexe'],
        "Email 1": _mail1,
        "Email 2": _mail2,
        "Formation": _formation,
        "Certificat": _certificat,
        "Date Naissance": _naissance,
        "Niveau présumé": _niveau,
        "Classement": _classement,
        "Licence": _licence,
        "Droit image": image,
        "Autorisation sortie": sortie,
        "Adresse": _adresse,
        "Tel Portable": _tel1,
        "Tel Portable 2": _tel2,
        'Présence': comparos.value['Présence'],
        'NbAbs': comparos.value['NbAbs'],
      });
      _nomelevecontroll.clear();
      _nomeleve = " ";
      _prenomelevecontroll.clear();
      _prenomeleve = " ";
      _mailelevecontroll1.clear();
      _mail1 = " ";
      _mailelevecontroll2.clear();
      _mail2 = " ";
      _telcontroll1.clear();
      _tel1 = " ";
      _formationcontroll.clear();
      _formation = " ";
      _telcontroll2.clear();
      _tel2 = " ";
      _certificatcontroll.clear();
      _certificat = " ";
      _naissancecontroll.clear();
      _naissance = " ";
      _classementcontroll.clear();
      _classement = " ";
      _licencecontroll.clear();
      _licence = " ";
      _adressecontroll.clear();
      _adresse = " ";
      _niveau = ' ';
      _niveaucontroll.clear();

      _nomcontroll.clear();
      _nom = " ";
      _prenomcontroll.clear();
      _prenom = " ";

      _image = false;
      _sortie = false;
      final snackBar = SnackBar(
        content: Text('Élève modifié'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text("Cet élève n'existe pas"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  var _nomelevecontroll = TextEditingController();
  String _nomeleve = " ";
  var _prenomelevecontroll = TextEditingController();
  String _prenomeleve = " ";
  var _mailelevecontroll1 = TextEditingController();
  String _mail1 = " ";
  var _mailelevecontroll2 = TextEditingController();
  String _mail2 = " ";
  var _telcontroll1 = TextEditingController();
  String _tel1 = " ";
  var _formationcontroll = TextEditingController();
  String _formation = " ";
  var _telcontroll2 = TextEditingController();
  String _tel2 = " ";
  var _certificatcontroll = TextEditingController();
  String _certificat = " ";
  var _naissancecontroll = TextEditingController();
  String _naissance = " ";
  var _classementcontroll = TextEditingController();
  String _classement = " ";
  var _licencecontroll = TextEditingController();
  String _licence = " ";
  var _adressecontroll = TextEditingController();
  String _adresse = " ";
  var _niveaucontroll = TextEditingController();
  var _niveau = ' ';

  var _nomcontroll = TextEditingController();
  String _nom = " ";
  var _prenomcontroll = TextEditingController();
  String _prenom = " ";

  bool _image = false;
  bool _sortie = false;
  var sortie;
  var image;
  var marge = EdgeInsets.fromLTRB(25, 5, 25, 5);

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
              Column(children: [
                Container(
                  child: Text(
                    'Nécessaire:',
                    style: TextStyle(
                      color: noirecrit,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Container(
                  margin: marge,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    controller: _nomcontroll,
                    decoration: InputDecoration(
                      hintText: 'Nom',
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(color: bleufonce),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _nom = value.trim();
                      });
                    },
                  ),
                ),
                Container(
                  margin: marge,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    controller: _prenomcontroll,
                    decoration: InputDecoration(
                      hintText: 'Prénom',
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(color: bleufonce),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _prenom = value.trim();
                      });
                    },
                  ),
                ),
              ]),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  'À changer (entrer uniquement les attributs à changer):',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: noirecrit,
                    fontSize: 25.0,
                  ),
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
                    hintText: 'Certificat',
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
                  child: Text("Modifier l'élève"),
                  onPressed: () async {
                    quit = true;
                    modifeleve();
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
