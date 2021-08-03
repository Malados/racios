import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:racpresence/couleur.dart';

import '../../variables.dart';

class Num_tel extends StatefulWidget {
  Num_tel({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Num_tel createState() => _Num_tel();
}

var num;
bool montrer = false;

class _Num_tel extends State<Num_tel> {
  @override
  void initState() {
    if (num_ != '0') {
      montrer = true;
      num = num_;
    }
    super.initState();
  }

  void enregistrer() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(iduser_)
        .update({'numéro': num});
    num_ = num;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancfond,
      appBar: AppBar(
        centerTitle: true,
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
          child: Column(children: [
            SizedBox(
              height: 50,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  children: [
                    Text(
                      'Donner son numéro aux parents   ',
                      style: TextStyle(color: noirecrit),
                    ),
                    FlutterSwitch(
                      activeColor: bleufonce,
                      width: 60,
                      height: 30,
                      value: montrer,
                      borderRadius: 30.0,
                      onToggle: (val) {
                        if (val) {
                          num = num_;
                        } else {
                          num = '0';
                        }
                        setState(() {
                          montrer = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ]),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Text(
                'Les parents pourront vous contacter si leur enfant a un cours avec vous.',
                textAlign: TextAlign.center,
              ),
            ),
            if (montrer == true)
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: bleufonce, width: 2.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      hintText: num_ != '0' ? num : 'Numéro',
                    ),
                    onChanged: (value) {
                      setState(() {
                        num = value.trim();
                      });
                    },
                  ),
                ),
              ),
            SizedBox(
              height: 50,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: bleuclair,
                  ),
                  child: Text('Enregistrer les changements'),
                  onPressed: () async {
                    enregistrer();
                    final snackBar = SnackBar(
                      content: Text('Numéro enregistré'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }),
            ]),
          ]),
        ),
      ),
    );
  }
}
