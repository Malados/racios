import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter/rendering.dart';
import 'package:racpresence/couleur.dart';
import 'package:racpresence/liste_options/eleve/abseleve.dart';
import 'package:racpresence/problemes/pbquitte.dart';
import 'package:racpresence/variables.dart';
import 'coursdujour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:firebase_database/firebase_database.dart' as bdd;

class Calendrier extends StatefulWidget {
  Calendrier({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Calendrier createState() => _Calendrier();
}

class _Calendrier extends State<Calendrier> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  List tabterrain = [];
  List tab = [];
  List terrain = [];
  var taille;
  var titre;
  var annonces = false;
  final firerefe = FirebaseFirestore.instance;
  void checkannonce() async {
    var result = await firerefe.collection('annonces').get();
    if (result.size != 0) {
      annonces = true;
    }
    await Future.delayed(const Duration(seconds: 2), () {});
  }

  @override
  void initState() {
    super.initState();
    checkannonce();
    setState(() {});
    if (admin_ == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        this.setState(() => _currentDate2 = date);

        var mois = DateFormat('M').format(date);
        if (mois.length == 1) mois = "0" + mois;

        var jour = DateFormat('d').format(date);
        var nomjour = DateFormat('EEEE').format(date);
        if (nomjour == "Monday")
          nomjour = "Lundi";
        else if (nomjour == "Tuesday")
          nomjour = "Mardi";
        else if (nomjour == "Wednesday")
          nomjour = "Mercredi";
        else if (nomjour == "Thursday")
          nomjour = "Jeudi";
        else if (nomjour == "Friday")
          nomjour = "Vendredi";
        else if (nomjour == "Saturday")
          nomjour = "Samedi";
        else
          nomjour = "Dimanche";

        titre = "$nomjour $jour / $mois";

        taille = tabterrain.length;

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Coursdujour(
                  title: titre,
                )));
      },
      firstDayOfWeek: 1,
      todayBorderColor: bleufonce,
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.black,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      todayButtonColor: bleuclair,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 18,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {},
    );

    return new Scaffold(
        backgroundColor: blancfond,
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(widget.title),
          backgroundColor: bleufonce,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Pbquitte(title: "J'ai un problème")));
                },
                icon: Icon(Icons.contact_support)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (annonces == true)
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                      child: Container(
                    height: 40,
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: orange),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: Text('ANNONCES:',
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold))),
                  )),
                ]),
              if (annonces == true)
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 0.0,
                    maxHeight: 152.0,
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('annonces')
                        .orderBy('date')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map(
                                (e) => Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 0),
                                          decoration: BoxDecoration(
                                              color: Color(e['case']),
                                              border: Border.all(
                                                  width: e['epaisseur'],
                                                  color: Color(e['contour'])),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 3, 10, 3),
                                          child: Text(e['corps'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(e['texte']),
                                                  fontSize: e['police']))),
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
                ),
              if (admin_ == true)
                if (abs_ == true)
                  Row(children: [
                    Expanded(
                      child: Container(
                          height: 45,
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: bleuclair,
                              side: BorderSide(
                                  color: Colors.blue[800]!, width: 2),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              "Élève absent 3 fois",
                              style: TextStyle(
                                  color: noirecrit,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AbsEleve(title: 'Élèves absents')));
                            },
                          )),
                    ),
                  ]),
              Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: bleuclair,
                        side: BorderSide(color: Colors.black, width: 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Text('précédent'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month - 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ))),
                    ElevatedButton(
                      child: Text(
                        'suivant',
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: bleuclair,
                        side: BorderSide(color: Colors.black, width: 1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month + 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    )
                  ],
                ),
              ),
              //custom icon
              Container(
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                child: _calendarCarouselNoHeader,
              ),
            ],
          ),
        ));
  }
}
