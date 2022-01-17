import 'dart:async';
import 'package:flutter/services.dart';

// Pollfish notifications

typedef void PollfishSurveyReceivedListener(SurveyInfo? surveyInfo);
typedef void PollfishSurveyCompletedListener(SurveyInfo? surveyInfo);
typedef void PollfishUserNotEligibleListener();
typedef void PollfishUserRejectedSurveyListener();
typedef void PollfishOpenedListener();
typedef void PollfishClosedListener();
typedef void PollfishSurveyNotAvailableListener();

enum Position {
  topLeft,
  topRight,
  middleLeft,
  middleRight,
  bottomLeft,
  bottomRight
}

class RewardInfo {
  String rewardName;
  double rewardConversion;

  RewardInfo(this.rewardName, this.rewardConversion);

  Map toMap() {
    return {
      'rewardName': this.rewardName,
      'rewardConversion': this.rewardConversion
    };
  }
}

class SurveyInfo {
  int? surveyCPA;
  int? surveyIR;
  int? surveyLOI;
  String? surveyClass;
  String? rewardName;
  int? rewardValue;
  int? remainingCompletes;

  SurveyInfo(
      {this.surveyCPA,
      this.surveyIR,
      this.surveyLOI,
      this.surveyClass,
      this.rewardName,
      this.rewardValue,
      this.remainingCompletes});

  @override
  String toString() {
    return "SurveyInfo: \n" +
        ((surveyCPA != null) ? "\tsurveyCPA: $surveyCPA\n" : "") +
        ((surveyIR != null) ? "\tsurveyIR: $surveyIR\n" : "") +
        ((surveyLOI != null) ? "\tsurveyLOI: $surveyLOI\n" : "") +
        ((surveyClass != null) ? "\tsurveyClass: $surveyClass\n" : "") +
        ((rewardName != null) ? "\trewardName: $rewardName\n" : "") +
        ((rewardValue != null) ? "\trewardValue: $rewardValue\n" : "") +
        ((remainingCompletes != null)
            ? "\tremainingCompletes: $remainingCompletes\n"
            : "");
  }
}

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

  static PollfishSurveyReceivedListener? _pollfishSurveyReceivedListener;
  static PollfishSurveyCompletedListener? _pollfishSurveyCompletedListener;
  static PollfishUserNotEligibleListener? _pollfishUserNotEligibleListener;
  static PollfishUserRejectedSurveyListener?
      _pollfishUserRejectedSurveyListener;
  static PollfishOpenedListener? _pollfishOpenedListener;
  static PollfishClosedListener? _pollfishClosedListener;
  static PollfishSurveyNotAvailableListener?
      _pollfishSurveyNotAvailableListener;

  Future<void> init(
      {required String? androidApiKey,
      required String? iosApiKey,
      Position indicatorPosition = Position.topLeft,
      int indicatorPadding = 8,
      bool rewardMode = false,
      bool releaseMode = false,
      bool offerwallMode = false,
      String? requestUUID,
      Map<String, dynamic>? userProperties,
      String? clickId,
      String? signature,
      RewardInfo? rewardInfo}) async {

    _channel.invokeMethod("init", <String, dynamic>{
      'androidApiKey': androidApiKey,
      'iOSApiKey': iosApiKey,
      'indicatorPosition': indicatorPosition.index,
      'indicatorPadding': indicatorPadding,
      'rewardMode': rewardMode,
      'releaseMode': releaseMode,
      'offerwallMode': offerwallMode,
      'requestUUID': requestUUID,
      'userProperties': userProperties,
      'clickId': clickId,
      'signature': signature,
      'rewardInfo': rewardInfo?.toMap()
    });
  }

  Future<void> show() {
    return _channel.invokeMethod('show');
  }

  Future<void> hide() {
    return _channel.invokeMethod('hide');
  }

  Future<bool> isPollfishPresent() {
    return _channel
        .invokeMethod<bool>('isPollfishPresent')
        .then<bool>((bool? value) => value ?? false);
  }

  Future<bool> isPollfishPanelOpen() {
    return _channel
        .invokeMethod<bool>('isPollfishPanelOpen')
        .then<bool>((bool? value) => value ?? false);
  }

  SurveyInfo? getSurveyInfoFromMap(dynamic map) {
    if (map == null || map.isEmpty) {
      return null;
    }

    return SurveyInfo(
        surveyCPA: (map.containsKey("surveyCPA") && map["surveyCPA"] is int)
            ? map["surveyCPA"]
            : null,
        surveyLOI: (map.containsKey("surveyLOI") && map["surveyLOI"] is int)
            ? map["surveyLOI"]
            : null,
        surveyIR: (map.containsKey("surveyIR") && map["surveyIR"] is int)
            ? map["surveyIR"]
            : null,
        surveyClass:
            (map.containsKey("surveyClass") && map["surveyClass"] is String)
                ? map["surveyClass"]
                : null,
        rewardName:
            (map.containsKey("rewardName") && map["rewardName"] is String)
                ? map["rewardName"]
                : null,
        rewardValue:
            (map.containsKey("rewardValue") && map["rewardValue"] is int)
                ? map["rewardValue"]
                : null,
        remainingCompletes: (map.containsKey("remainingCompletes") &&
                map["remainingCompletes"] is int)
            ? map["remainingCompletes"]
            : null);
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "pollfishSurveyReceived":
        _pollfishSurveyReceivedListener
            ?.call(getSurveyInfoFromMap(call.arguments));
        break;
      case "pollfishSurveyCompleted":
        _pollfishSurveyCompletedListener
            ?.call(getSurveyInfoFromMap(call.arguments));
        break;
      case "pollfishUserNotEligible":
        _pollfishUserNotEligibleListener?.call();
        break;
      case "pollfishUserRejectedSurvey":
        _pollfishUserRejectedSurveyListener?.call();
        break;
      case "pollfishOpened":
        _pollfishOpenedListener?.call();
        break;
      case "pollfishClosed":
        _pollfishClosedListener?.call();
        break;
      case "pollfishSurveyNotAvailable":
        _pollfishSurveyNotAvailableListener?.call();
        break;
      default:
        print('Unknown method ${call.method}');
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

  void removeListeners() {
    _pollfishClosedListener = null;
    _pollfishOpenedListener = null;
    _pollfishSurveyNotAvailableListener = null;
    _pollfishUserRejectedSurveyListener = null;
    _pollfishUserNotEligibleListener = null;
    _pollfishSurveyReceivedListener = null;
    _pollfishSurveyCompletedListener = null;
  }
}
