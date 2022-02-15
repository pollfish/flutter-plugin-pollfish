# flutter_pollfish

Pollfish Flutter Plugin allows integration of Pollfish surveys into Android and iOS apps. 

<br/>

# Prerequisites

* Android SDK 21 or higher using Google Play Services
* iOS 9.0 or higher
* Flutter v1.20.0 or higher
* Dart SDK v2.12.0 or higher
* CocoaPods v1.10.0 or higher

<br/>

# Quick Guide

* Create Pollfish Developer account, create a new app and grap it's API key
* Install Pollfish plugin and call init function
* Set to Release mode and release in AppStore and Google Play
* Update your app's privacy policy
* Request your account to get verified from the Pollfish Dashboard

<br/>

> **Note:** Apps designed for [Children and Families program](https://play.google.com/about/families/ads-monetization/) should not be using Pollfish SDK, since Pollfish does not collect responses from users less than 16 years old    

> **Note:** Pollfish iOS SDK utilizes Apple's Advertising ID (IDFA) to identify and retarget users with Pollfish surveys. As of iOS 14 you should initialize Pollfish Flutter plugin in iOS only if the relevant IDFA permission was granted by the user

<br/>

# Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  ...
  flutter_pollfish: ^4.0.5
```

Execute the following command

```bash
flutter packages get
```

<br/>

# Initialization

The Pollfish plugin must be initialized with one or two api keys depending on which platforms are you targeting. You can retrieve an API key from Pollfish Dashboard when you [sign up](https://www.pollfish.com/signup/publisher) and create a new app.

```dart
FlutterPollfish.instance.init(androidApiKey: 'ANDROID_API_KEY', iOSApiKey: 'IOS_API_KEY'); // Android and iOS
```

```dart
FlutterPollfish.instance.init(androidApiKey: 'ANDROID_API_KEY', iOSApiKey: null); // Android only
```

```dart
FlutterPollfish.instance.init(androidApiKey: null, iOSApiKey: 'IOS_API_KEY'); // iOS only
```

<br/>

### Other Init params (optional)

During initialization you can pass different optional params:

1. **`indicatorPosition`**: Position - `Position.topLeft`, `.topRight`, `.middleLeft`, `.middleRight`, `.bottomLeft`, `.bottomRight` (defines the side of the Pollfish panel, and position of Pollfish indicator)
2. **`indicatorPadding`**: int - Sets padding from the top or bottom according to Position of the indicator
3. **`releaseMode`**: bool - Sets Pollfish SDK to Debug or Release mode. Use Developer mode to test your implementation with demo surveys
4. **`rewardMode`**: bool - Initializes Pollfish in reward mode (used when implementing a Rewarded approach)
5. **`requestUUID`**: String - Sets a unique id to identify a user. This param will be passed back through server-to-server callbacks
5. **`offerwallMode`**: bool - Sets Pollfish to Offerwall mode
6. **`userProperties`**: Map<String, Object> - Send attributes that you receive from your app regarding a user, in order to receive a better fill rate and higher priced surveys. You can see a detailed list of the user attributes you can pass with their keys at the following [link](https://www.pollfish.com/docs/demographic-surveys)
7. **`clickId`**: String - A pass throught param that will be passed back through server-to-server callback
8. **`signature`**: String - An optional parameter used to secure the `rewardConversion` and `rewardName` parameters passed on `RewardInfo` object
9. **`rewardInfo`**: RewardInfo - An object holding information regarding the survey completion reward

<br/>

#### Debug Vs Release Mode

You can use Pollfish either in Debug or in Release mode. 
  
* **Debug mode** is used to show to the developer how Pollfish will be shown through an app (useful during development and testing).
* **Release mode** is the mode to be used for a released app (start receiving paid surveys).

> **Note:** In Android debugMode parameter is ignored. Your app turns into debug mode once it is signed with a debug key. If you sign your app with a release key it automatically turns into Release mode.

> **Note:** Be careful to turn the `releaseMode` parameter to `true` when you release your app in a relevant app store!!

<br/>

### Reward Mode 

Reward mode false during initialization enables controlling the behavior of Pollfish in an app from Pollfish panel. Enabling reward mode ignores Pollfish behavior from Pollfish panel. It always skips showing Pollfish indicator (small button) and always force open Pollfish view to app users. This method is usually used when app developers want to incentivize first somehow their users before completing surveys to increase completion rates.

<br/>

```dart
FlutterPollfish.instance.init(
  androidApiKey: 'ANDROID_API_KEY',
  iOSApiKey: 'IOS_API_KEY',
  indicatorPosition: Position.middleRight,
  indicatorPadding: 40,
  rewardMode: false,
  releaseMode: true,
  requestUUID: 'REQUEST_UUID',
  offerwallMode: false,
  userProperties: <String, dynamic>{ 
    'gender': '1',
    'education': '1',
    ...
  },
  signature: 'SIGNATURE',
  clickId: 'CLICK_ID',
  rewardInfo: RewardInfo('Point', 1.3));
```

<br/>

# Optional section

In this section we will list several options that can be used to control Pollfish surveys behaviour, how to listen to several notifications or how to be eligible to more targeted (high-paid) surveys. All these steps are optional.

<br/>

## Get notified when a Pollfish survey is received

You can get notified when a Pollfish survey is received. With this notification, you can also get informed about the type of survey that was received, money to be earned if survey gets completed, shown in USD cents and other info around the survey such as LOI and IR.

<br/>

> **Note:** If Pollfish is initialized in offerwall mode then the event parameter will be `null`, otherwise it will include info around the received survey.

```dart
FlutterPollfish.instance.setPollfishSurveyReceivedListener(onPollfishSurveyReceived);

void onPollfishSurveyReceived(SurveyInfo? surveyInfo) => setState(() {
  if (surveyInfo == null) {
    print("Offerwall Ready");
  } else {
    print("Survey Received - ${surveyInfo.toString()}");
  }
});
```

<br/>

## Get notified when a Pollfish survey is completed

You can get notified when a user completed a survey. With this notification, you can also get informed about the type of survey, money earned from that survey in USD cents and other info around the survey such as LOI and IR.

```dart
FlutterPollfish.instance.setPollfishSurveyCompletedListener(onPollfishSurveyCompleted);

void onPollfishSurveyCompleted(SurveyInfo sureyInfo) => setState(() {
    print('Survey Completed: - ${surveyInfo.toString()}');
});
```

<br/>

## Get notified when a user is not eligible for a Pollfish survey

You can get notified when a user is not eligible for a Pollfish survey. In market research monetization, users can get screened out while completing a survey beucase they are not relevant with the audience that the market researcher was looking for. In that case the user not eligible notification will fire and the publisher will make no money from that survey. The user not eligible notification will fire after the surveyReceived event, when the user starts completing the survey.

```dart
FlutterPollfish.instance.setPollfishUserNotEligibleListener(onPollfishUserNotEligible);

void onPollfishUserNotEligible() => setState(() {
   print('User Not Eligible');
}
```

<br/>

## Get notified when a Pollfish survey is not available

You can be notified when a Pollfish survey is not available.

```dart
FlutterPollfish.instance.setPollfishSurveyNotAvailableListener(onPollfishSurveyNotAvailable);

void onPollfishSurveyNotAvailable() => setState(() {
   print('Survey Not Available');
}
```

<br/>

## Get notified when a user has rejected a Pollfish survey

You can be notified when a user has rejected a Pollfish survey.

```dart
FlutterPollfish.instance.setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);

void onPollfishUserRejectedSurvey() => setState(() {
   print('User Rejected Survey');
}
```

<br/>

## Get notified when a Pollfish survey panel has opened

You can register and get notified when a Pollfish survey panel has opened. Publishers usually use this notification to pause a game until the pollfish panel is closed again.

```dart
FlutterPollfish.instance.setPollfishOpenedListener(onPollfishOpened);

void onPollfishOpened() => setState(() {
   print('Survey Panel Open');
}
```

<br/>

## Get notified when a Pollfish survey panel has closed

You can register and get notified when a Pollfish survey panel has closed. Publishers usually use this notification to resume a game that they have previously paused when the Pollfish panel was opened.

```dart
FlutterPollfish.instance.setPollfishClosedListener(onPollfishClosed);

void onPollfishClosed() => setState(() {
   print('Survey Panel Closed');
}
```

<br/>

## Unsubscribe from Pollfish Listeners

Please ensure you unsubscribe from Pollfish notification listeners at the end of the state's lifecycle

```dart
@override
void dispose() {
    FlutterPollfish.instance.removeListeners();
    super.dispose();
}
```

<br/>

## Manually show/hide Pollfish panel

During the lifetime of a survey, you can manually hide and show Pollfish by calling the following functions.

```dart
FlutterPollfish.instance.show();
```

or

```dart
FlutterPollfish.instance.hide();
```

<br/>

## Check if Pollfish surveys are available on your device

After a Pollish survey is received you can check at any time if the survey is available at the device by calling the following function.

```dart
FlutterPollfish.instance.isPollfishPresent().then((isPresent) => {
  print("isPresent: $isPresent");
});
```

<br/>

## Check if Pollfish panel is open

You can check at any time if the survey panel is open by calling the following function.

```dart
FlutterPollfish.instance.isPollfishPanelOpen().then((isOpen) => {
  print("isOpen: $isOpen");
});
```

<br/>

# Example

If you would like to implement the Rewarded approach or just review an example in code, you can review the example [here](https://github.com/pollfish/flutter-plugin-pollfish/tree/master/example).

<br/>

# More info

You can read more info on how the Native Pollfish SDKs work on Android and iOS or how to set up properly a Flutter environment at the following links:

<br/>

[Pollfish Flutter Plugin Documentation](https://pollfish.com/docs/flutter)

[Pollfish Android SDK Integration Guide](https://pollfish.com/docs/android)

[Pollfish iOS SDK Integration Guide](https://pollfish.com/docs/ios)

[Flutter Starting Guide](https://flutter.dev/docs/get-started)
