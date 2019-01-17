import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_pollfish/flutter_pollfish.dart';

void main() => runApp(MyApp());

//Pollfish initialization options

const String apiKey = '2ae349ab-30b8-4100-bc4d-b33b82e76519';
const bool debugMode = true;
const int indPadding = 20;
const int pollfishPosition = 5;
const String requestUUID = null;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _logText = '';

  bool _showButton = false;
  bool _completedSurvey = false;
  bool _customMode = false;
  int _currentIndex = 0;
  int _cpa = 0;

  @override
  void initState() {
    super.initState();
    initPollfish();
  }

  Future<void> initPollfish() async {
    String logText = 'Initializing Pollish...';

    _showButton = false;
    _completedSurvey = false;

    FlutterPollfish.instance.init(
        apiKey: apiKey,
        pollfishPosition: pollfishPosition,
        indPadding: indPadding,
        customMode: _customMode,
        debugMode: debugMode,
        requestUUID: requestUUID);

    if (_customMode) {
      FlutterPollfish.instance.hide();
    }

    FlutterPollfish.instance
        .setPollfishReceivedSurveyListener(onPollfishSurveyReveived);
    FlutterPollfish.instance
        .setPollfishCompletedSurveyListener(onPollfishSurveyCompleted);
    FlutterPollfish.instance
        .setPollfishSurveyOpenedListener(onPollfishSurveyOpened);
    FlutterPollfish.instance
        .setPollfishSurveyClosedListener(onPollfishSurveyClosed);
    FlutterPollfish.instance.setPollfishSurveyNotAvailableSurveyListener(
        onPollfishSurveyNotAvailable);
    FlutterPollfish.instance
        .setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);
    FlutterPollfish.instance
        .setPollfishUserNotEligibleListener(onPollfishUserNotEligible);

    setState(() {
      _logText = logText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: _currentIndex % 2 == 0
                ? const Text('Pollfish Standard Integration')
                : const Text('Pollfish Rewarded Integration'),
          ),
          body: Center(
              child: new Container(
                  padding: new EdgeInsets.all(20.0),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //Padding between these please
                        Text('$_logText\n'),
                        (_currentIndex % 2 == 1 &&
                                _showButton &&
                                !_completedSurvey)
                            ? new RawMaterialButton(
                                onPressed: () {
                                  FlutterPollfish.instance.show();
                                },
                                child: new Text(
                                    'Complete a Survey and Earn $_cpa Credits',
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                // You can add a Icon instead of text also, like below.

                                shape: new RoundedRectangleBorder(),
                                elevation: 2.0,
                                fillColor: Colors.blue,
                                padding: const EdgeInsets.all(15.0),
                              )
                            : (_currentIndex % 2 == 1 &&
                                    !_showButton &&
                                    _completedSurvey)
                                ? Container(
                                    child: new Text('You earned $_cpa Credits'),
                                  )
                                : Container()
                      ]))),
          bottomNavigationBar: BottomNavigationBar(
              onTap: onTabTapped,
              // new
              currentIndex: _currentIndex, // new
              items: [
                new BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  title: Text('Standard'),
                ),
                new BottomNavigationBarItem(
                    icon: Icon(Icons.card_giftcard), title: Text('Rewarded'))
              ])),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex % 2 == 1) {
        _customMode = true;
      } else {
        _customMode = false;
      }
    });
    initPollfish();
  }

  // Pollish notification functions

  void onPollfishSurveyReveived(String result) => setState(() {
        List<String> surveyCharacteristics = result.split(',');
        if (surveyCharacteristics.length >= 4) {
          _logText =
              'Survey Received: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]}';

          var myInt = int.parse(surveyCharacteristics[0]);
          assert(myInt is int);

          _completedSurvey = false;
          _showButton = true;

          _cpa = myInt;
        }
      });

  void onPollfishSurveyCompleted(String result) => setState(() {
        List<String> surveyCharacteristics = result.split(',');
        if (surveyCharacteristics.length >= 4) {
          _logText =
              'Survey Completed: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]}';
          _showButton = false;
          _completedSurvey = true;
        }
      });

  void onPollfishSurveyOpened() => setState(() {
        _logText = 'Survey Panel Open';
      });

  void onPollfishSurveyClosed() => setState(() {
        _logText = 'Survey Panel Closed';
      });

  void onPollfishSurveyNotAvailable() => setState(() {
        _logText = 'Survey Not Available';
        _showButton = false;
        _completedSurvey = false;
      });

  void onPollfishUserRejectedSurvey() => setState(() {
        _logText = 'User Rejected Survey';
        _showButton = false;
        _completedSurvey = false;
      });

  void onPollfishUserNotEligible() => setState(() {
        _logText = 'User Not Eligible';
        _showButton = false;
        _completedSurvey = false;
      });
}
