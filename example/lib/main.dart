import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_pollfish/flutter_pollfish.dart';

void main() => runApp(MyApp());

//Pollfish initialization options

const String apiKey = '2ae349ab-30b8-4100-bc4d-b33b82e76519';
const bool rewardMode = true;
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
  bool _rewardMode = false;
  bool _releaseMode = false;
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
        rewardMode: _rewardMode,
        releaseMode: _releaseMode,
        offerwallMode: (_currentIndex ==2)?true:false,
        requestUUID: requestUUID);

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
              title:findCurrentTitle(_currentIndex),
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
                      (((_currentIndex == 1)||(_currentIndex == 2)) &&
                          _showButton &&
                          !_completedSurvey)
                          ? new RawMaterialButton(
                        onPressed: () {
                          FlutterPollfish.instance.show();
                        },
                        child: new Text(
                            (_currentIndex == 1)?'Complete a Survey and Earn $_cpa Credits':'Offerwall - Take Surveys',
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
              ), new BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
                title: Text('Rewarded Survey'),
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer), title: Text('Offerwall'))
            ])),);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        _rewardMode = false;
      } else {
        _rewardMode = true;
      }
    });
    initPollfish();
  }

  Text findCurrentTitle(int currentIndex){

    if(_currentIndex == 0){
      return const Text('Pollfish Standard Integration');
    }else if(_currentIndex == 1){
      return const Text('Pollfish Rewarded Integration');
    }else{
      return const Text('Pollfish Offerwall Integration');
    }
  }

  // Pollish notification functions

  void onPollfishSurveyReveived(String result) =>
      setState(() {
        List<String> surveyCharacteristics = result.split(',');
        if (surveyCharacteristics.length >= 4) {
          _logText =
          'Survey Received: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]} and RewardName: ${surveyCharacteristics[4]}  and RewardValue: ${surveyCharacteristics[5]}';

          var myInt = int.parse(surveyCharacteristics[0]);
          assert(myInt is int);


          _cpa = myInt;

        }else{
          _logText = 'Offerwall Ready'; // Offerwall
        }

        _completedSurvey = false;
        _showButton = true;

      });

  void onPollfishSurveyCompleted(String result) =>
      setState(() {
        List<String> surveyCharacteristics = result.split(',');
        if (surveyCharacteristics.length >= 4) {
          _logText =
          'Survey Completed: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]} and RewardName: ${surveyCharacteristics[4]}  and RewardValue: ${surveyCharacteristics[5]}';
        }

        if(_currentIndex == 1) { // Rewarded Survey - Do not hide on Offerwall
          _showButton = false;
          _completedSurvey = true;
        }
      });

  void onPollfishSurveyOpened() =>
      setState(() {
        _logText = 'Survey Panel Open';
      });

  void onPollfishSurveyClosed() =>
      setState(() {
        _logText = 'Survey Panel Closed';
      });

  void onPollfishSurveyNotAvailable() =>
      setState(() {
        _logText = 'Survey Not Available';

        _showButton = false;
        _completedSurvey = false;
      });

  void onPollfishUserRejectedSurvey() =>
      setState(() {
        _logText = 'User Rejected Survey';


        if(_currentIndex == 1) {// Rewarded Survey - Do not hide on Offerwall
          _showButton = false;
          _completedSurvey = false;
        }
      });

  void onPollfishUserNotEligible() =>
      setState(() {
        _logText = 'User Not Eligible';

        if(_currentIndex == 1) {// Rewarded Survey - Do not hide on Offerwall
          _showButton = false;
          _completedSurvey = false;
        }
      });
}
