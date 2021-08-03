import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/mdpoublie.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:racpresence/main.dart';

class Connexion extends StatefulWidget {
  Connexion({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  @override
  initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (Route<dynamic> route) => false,
      );
    }
    setState(() {});
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return auth.sendPasswordResetEmail(email: email);
  }

  String _email = "", _password = "";
  final auth = FirebaseAuth.instance;

  var connexionpb = "";
  var inscriptionpb = "";
  bool connexion = false;
  bool inscription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleufonce,
        title: Text('Connexion'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  focusedBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: bleufonce),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Mot de passe',
                  focusedBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: bleufonce),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: blancfond,
                    side: BorderSide(color: blancfond, width: 0),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MdpOublie()),
                    );
                  },
                  child: Text(
                    'Mot de passe oublié',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: bleuclair,
                  side: BorderSide(color: Colors.black, width: 1),
                  elevation: 1,
                ),
                child: Text('Connexion'),
                onPressed: () async {
                  try {
                    await auth
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .then((_) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyHomePage()));
                    });
                  } on FirebaseAuthException catch (e) {
                    connexion = true;
                    inscription = false;

                    if (e.code == 'user-not-found') {
                      connexionpb = "L'utilisateur n'existe pas.";
                    } else if (e.code == 'wrong-password') {
                      connexionpb = "Mauvais mot de passe";
                    } else if (e.code == 'too-many-requests') {
                      connexionpb = "Attendez un peu avant de réessayer";
                    } else {
                      connexionpb = "y'a un pb";
                    }
                    setState(() {});
                  }
                }),
          ]),
          Container(
            child: connexion == true
                ? Container(
                    child: Text(connexionpb),
                  )
                : Container(),
          ),
          Container(
            child: inscription == true
                ? Container(
                    child: Text('Problème inscription'),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
