import 'dart:async';

import 'package:flutter/services.dart';

// Pollfish notifications

typedef void PollfishSurveyReceivedListener(String result);
typedef void PollfishSurveyCompletedListener(String result);
typedef void PollfishUserNotEligibleListener();
typedef void PollfishUserRejectedSurveyListener();
typedef void PollfishOpenedListener();
typedef void PollfishClosedListener();
typedef void PollfishSurveyNotAvailableListener();

class FlutterPollfish {
  /// The single shared instance of this plugin.
  static FlutterPollfish get instance => _instance;

  final MethodChannel _channel;

  static final FlutterPollfish _instance = FlutterPollfish.private(
    const MethodChannel('flutter_pollfish'),
  );

  FlutterPollfish.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static PollfishSurveyReceivedListener _pollfishSurveyReceivedListener;
  static PollfishSurveyCompletedListener _pollfishSurveyCompletedListener;
  static PollfishUserNotEligibleListener _pollfishUserNotEligibleListener;
  static PollfishUserRejectedSurveyListener _pollfishUserRejectedSurveyListener;
  static PollfishOpenedListener _pollfishOpenedListener;
  static PollfishClosedListener _pollfishClosedListener;
  static PollfishSurveyNotAvailableListener _pollfishSurveyNotAvailableListener;

  Future<void> init(
      {String apiKey,
      int pollfishPosition,
      int indPadding,
      bool rewardMode,
      bool releaseMode,
      bool offerwallMode,
      String requestUUID}) async {
    assert(apiKey != null && apiKey.isNotEmpty);

    print(' invokeMethod FlutterPollfish.init()... ');

    return _channel.invokeMethod("init", <String, dynamic>{
      'api_key': apiKey,
      'pollfishPosition': pollfishPosition,
      'indPadding': indPadding,
      'rewardMode': rewardMode,
      'releaseMode': releaseMode,
      'offerwallMode': offerwallMode,
      'request_uuid': requestUUID,
    });
  }

  Future<void> show() {
    print(' invokeMethod FlutterPollfish.show()... ');
    return _channel.invokeMethod('show');
  }

  Future<void> hide() {
    print(' invokeMethod FlutterPollfish.hide()... ');
    return _channel.invokeMethod('hide');
  }

  Future _platformCallHandler(MethodCall call) async {
    print(
        "FlutterPollfish _platformCallHandler call ${call.method} ${call.arguments}");

    switch (call.method) {
      case "pollfishSurveyReceived":
        _pollfishSurveyReceivedListener(call.arguments);
        print("pollfishSurveyReceived");

        break;

      case "pollfishSurveyCompleted":
        _pollfishSurveyCompletedListener(call.arguments);
        print("pollfishSurveyCompleted");

        break;

      case "pollfishUserNotEligible":
        _pollfishUserNotEligibleListener();
        print("pollfishUserNotEligible");

        break;

      case "pollfishUserRejectedSurvey":
        _pollfishUserRejectedSurveyListener();
        print("pollfishUserRejectedSurvey");

        break;
      case "pollfishOpened":
        _pollfishOpenedListener();
        print("pollfishOpened");

        break;
      case "pollfishClosed":
        _pollfishClosedListener();
        print("pollfishClosed");

        break;
      case "pollfishSurveyNotAvailable":
        _pollfishSurveyNotAvailableListener();
        print("pollfishSurveyNotAvailable");

        break;

      default:
        print('Unknown method ${call.method} ');
    }
  }

  void setPollfishSurveyReceivedListener(
          PollfishSurveyReceivedListener pollfishReceivedSurveyListener) =>
      _pollfishSurveyReceivedListener = pollfishReceivedSurveyListener;

  void setPollfishSurveyCompletedListener(
          PollfishSurveyCompletedListener pollfishCompletedSurveyListener) =>
      _pollfishSurveyCompletedListener = pollfishCompletedSurveyListener;

  void setPollfishUserNotEligibleListener(
          PollfishUserNotEligibleListener pollfishUserNotEligibleListener) =>
      _pollfishUserNotEligibleListener = pollfishUserNotEligibleListener;

  void setPollfishUserRejectedSurveyListener(
          PollfishUserRejectedSurveyListener
              pollfishUserRejectedSurveyListener) =>
      _pollfishUserRejectedSurveyListener = pollfishUserRejectedSurveyListener;

  void setPollfishOpenedListener(
          PollfishOpenedListener pollfishSurveyOpenedListener) =>
      _pollfishOpenedListener = pollfishSurveyOpenedListener;

  void setPollfishClosedListener(
      PollfishClosedListener pollfishSurveyClosedListener) =>
      _pollfishClosedListener = pollfishSurveyClosedListener;

  void setPollfishSurveyNotAvailableListener(
          PollfishSurveyNotAvailableListener
              pollfishSurveyNotAvailableListener) =>
      _pollfishSurveyNotAvailableListener = pollfishSurveyNotAvailableListener;
}
