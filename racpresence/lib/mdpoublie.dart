import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racpresence/couleur.dart';

class MdpOublie extends StatefulWidget {
  @override
  _MdpOublie createState() => _MdpOublie();
}

class _MdpOublie extends State<MdpOublie> {
  String _email = "";
  final auth = FirebaseAuth.instance;

  var connexionpb = "";
  var inscriptionpb = "";

  bool envoye = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(centerTitle: true,
        backgroundColor: bleufonce,
        title: Text('Mot de passe oublié'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email',
                                focusedBorder: new UnderlineInputBorder(
                                  borderSide: BorderSide(color: bleufonce),
                                ),),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: bleuclair,
                side: BorderSide(color: Colors.black, width: 1),
                elevation: 0,
              ),
              onPressed: () async {
                envoye = true;
                try {
                  await auth.sendPasswordResetEmail(email: _email).then((_) {
                    envoye = true;
                  });
                } on FirebaseAuthException catch (e) {
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
              },
              child: Text(
                'Réinitialiser le mot de passe',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            child: envoye == true
                ? Container(
                    child: Text(connexionpb),
                  )
                : Container(),
          ),
          Container(
            child: envoye == true
                ? Container(
                    child: Text('Un mail vous a été envoyé pour réinitialiser votre mot de passe'),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
