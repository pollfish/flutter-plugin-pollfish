# flutter_pollfish

A plugin for [Flutter](https://flutter.io) that supports rendering surveys using [Pollfish SDKs](https://www.pollfish.com/docs/).

*Note*: Pollfish iOS SDK utilizes Apple's Advertising ID (IDFA) to identify and retarget users with Pollfish surveys. As of iOS 14 you should initialize Pollfish Flutter plugin in iOS only if the relevant IDFA permission was granted by the user

Pollfish Flutter Plugin v3.0.0 introduces a different API with added customization options during initialization, new exposed methods and slighly different callbacks. If you have already integrated Pollfish Flutter Plugin < v3.0.0 in you app, please take some time reading the migration guide below.

<details><summary>➤ <b>Kotlin</b> (Click to expand)</summary>
<table>
<tr>
<td>
<br/>

<span style="color:red">-</span>

<td>

#### **Init** <br/>

```dart
FlutterPollfish.instance.init(
     apiKey: 'YOUR_API_KEY',
     pollfishPosition: 5,
     indPadding: 40,
     rewardMode: false,
     releaseMode: true,
     requestUUID: 'USER_INTERNAL_ID',
     offerwallMode: false);
```

<tr>
<td>

<span style="color:green">+</span>

<td>
<br/>

```dart
FlutterPollfish.instance.init(
    apiKey: 'YOUR_API_KEY',
    indicatorPosition: 5,
    indicatorPadding: 40,
    rewardMode: false,
    releaseMode: true,
    requestUUID: 'USER_INTERNAL_ID',
    offerwallMode: false,
    userProperties: <String, dynamic>{ 
      'gender': '1',
      'education': '1',
      ...
    });
```

<tr>
<td>
<br/>

<span style="color:red">-</span>

<td>

#### **Survey Received Notification** <br/>

```dart
void onPollfishSurveyReveived(String result) => setState(() {
  List<String> surveyCharacteristics = result.split(',');
        
  if (surveyCharacteristics.length >= 4) {
    print('Survey Received: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]} and RewardName: ${surveyCharacteristics[4]}  and RewardValue: ${surveyCharacteristics[5]}');
  } else {
    print('Offerwall Ready');
  }
});
```

<tr>
<td>

<span style="color:green">+</span>

<td>
<br/>

```kotlin
void onPollfishSurveyReceived(SurveyInfo? surveyInfo) => setState(() {
  if (surveyInfo == null) {
    _logText = 'Offerwall Ready'; // Offerwall
  } else {
    print('Survey Received: - ${surveyInfo.toString()}');
  }
});
```

<tr>
<td>
<br/>

<span style="color:red">-</span>

<td>

#### **Survey Completed Notififation** <br/>

```dart
void onPollfishSurveyCompleted(String result) => setState(() {
  List<String> surveyCharacteristics = result.split(',');
  if (surveyCharacteristics.length >= 4) {
    print('Survey Completed: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]} and RewardName: ${surveyCharacteristics[4]}  and RewardValue: ${surveyCharacteristics[5]}');
  }
});
```

<tr>
<td>

<span style="color:green">+</span>

<td>
<br/>

```kotlin
void onPollfishSurveyCompleted(SurveyInfo? surveyInfo) => setState(() {
  print('Survey Completed: - ${surveyInfo?.toString()}');
});
```

</table>
</details>

## Initializing the plugin

The Pollfish plugin must be initialized with a Pollfish API Key. You can retrieve an API key from Pollfish Dashboard when you [sign up](https://www.pollfish.com/signup/publisher) and create a new app.

```dart
FlutterPollfish.instance.init(apiKey: 'YOUR_API_KEY');
```

### Other Init params (optional)

During initialization you can pass different optional params:

1. **indicatorPosition**: Position - `Position.topLeft`, `.topRight`, `.middleLeft`, `.middleRight`, `.bottomLeft`, `.bottomRight` (defines the side of the Pollfish panel, and position of Pollfish indicator)
2. **indicatorPadding**: int - Sets padding from the top or bottom according to Position of the indicator
3. **releaseMode**: bool - Sets Pollfish SDK to Debug or Release mode. Use Developer mode to test your implementation with demo surveys
4. **rewardMode**: bool - Initializes Pollfish in reward mode (used when implementing a Rewarded approach)
5. **requestUUID**: String - Sets a unique id to identify a user. This param will be passed back through server-to-server callbacks
5. **offerwallMode**: bool - Sets Pollfish to Offerwall mode
6. **userProperties**: Map<String, Object> - Send attributes that you receive from your app regarding a user, in order to receive a better fill rate and higher priced surveys. You can see a detailed list of the user attributes you can pass with their keys at the following [link](https://www.pollfish.com/docs/demographic-surveys)

#### Debug Vs Release Mode

You can use Pollfish either in Debug or in Release mode. 
  
* **Debug mode** is used to show to the developer how Pollfish will be shown through an app (useful during development and testing).
* **Release mode** is the mode to be used for a released app (start receiving paid surveys).


#### init Vs custom init

*	**rewardMode = false** is the standard way of using Pollfish in your apps. Using init function with reward mode disabled, enables controlling the behavior of Pollfish in an app from Pollfish panel.

*	**rewardMode = true** ignores Pollfish behavior from Pollfish panel. It always skips showing Pollfish indicator (small Pollfish icon) and always force open Pollfish view to app users. This method is usually used when app developers want to incentivize first somehow their users, before completing surveys to increase completion rates.

For example:

```dart
FlutterPollfish.instance.init(
    apiKey: 'YOUR_API_KEY',
    indicatorPosition: 5,
    indicatorPadding: 40,
    rewardMode: false,
    releaseMode: true,
    requestUUID: 'USER_INTERNAL_ID',
    offerwallMode: false,
    userProperties: <String, dynamic>{ 
      'gender': '1',
      'education': '1',
      ...
    });
```

## Manually showing or hiding Pollfish panel

During the lifetime of a survey, publisher can manually show or hide survey panel by calling the following functions.

```dart
FlutterPollfish.instance.show();
```

or

```dart
FlutterPollfish.instance.hide();
```

## Check if Pollfish Surveys are available on your device

Publishers can check if Pollfish Surveys are available on your device by calling the following function.

```dart
FlutterPollfish.instance.isPollfishPresent().then((isPresent) => {
  print("isPresent: $isPresent");
});
```

## Check if Pollfish Panel is open

Publishers can check if Pollfish Survey Panel is open by calling the following function.

```dart
FlutterPollfish.instance.isPollfishPanelOpen().then((isOpen) => {
  print("isOpen: $isOpen");
});
```

## Listening to Pollfish notifications

Publishers can register and receive notifications on different events during the lifetime of a survey

### Pollfish Survey Received notification

Publishers can get notified when a Pollfish survey is received. With this notification, you can also get informed about the type of survey that was received, money to be earned if survey gets completed, shown in USD cents and other info around the survey such as LOI and IR.

- CPA: money to be earned in USD cents
- LOI: length of the survey is minutes
- IR: incidence rate (conversion)
- Survey Class: survey provider (Pollfish, Toluna, Cint etc)
- Reward Name: Reward name as specified on Pollfish Dashboard
- Reward Value: Reward value based on exchange rate as specified on Pollfish Dashboard

> Note: If Pollfish is initialized in offerwall mode then the event parameter will be `null`, otherwise it will include info around the received survey.


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

### Pollfish Survey Completed notification

Once a survey is completed, Pollfish Survey Completed notification is fired to inform the publisher. The notification includes several info around the survey such as:

- CPA: money to be earned in USD cents
- LOI: length of the survey is minutes
- IR: incidence rate (conversion)
- Survey Class: survey provider (Pollfish, Toluna, Cint etc)
- Reward Name: Reward name as specified on Pollfish Dashboard
- Reward Value: Reward value based on exchange rate as specified on Pollfish Dashboard


```dart
FlutterPollfish.instance.setPollfishSurveyCompletedListener(onPollfishSurveyCompleted);

void onPollfishSurveyCompleted(SurveyInfo? sureyInfo) => setState(() {
    print('Survey Completed: - ${surveyInfo?.toString()}');
});
```

### Pollfish Survey Panel Opened notification

A notification that informs that Pollfish Survey panel opened


```dart
FlutterPollfish.instance.setPollfishOpenedListener(onPollfishOpened);

void onPollfishOpened() => setState(() {
   print('Survey Panel Open');
}
```

### Pollfish Survey Panel Closed notification

A notification that informs that Pollfish Survey panel closed


```dart
FlutterPollfish.instance.setPollfishClosedListener(onPollfishClosed);

void onPollfishClosed() => setState(() {
   print('Survey Panel Closed');
}
```

### Pollfish Survey Not Available notification

A notification that informs that no survey is available for that user


```dart
FlutterPollfish.instance.setPollfishSurveyNotAvailableListener(onPollfishSurveyNotAvailable);

void onPollfishSurveyNotAvailable() => setState(() {
   print('Survey Not Available');
}
```

### Pollfish User Reject Survey notification

A notification that informs that the user rejected the survey


```dart
FlutterPollfish.instance.setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);

void onPollfishUserRejectedSurvey() => setState(() {
   print('User Rejected Survey');
}
```

### Pollfish User Not Eligible notification

A notification that informs that the user got screened out from the survey


```dart
FlutterPollfish.instance.setPollfishUserNotEligibleListener(onPollfishUserNotEligible);

void onPollfishUserNotEligible() => setState(() {
   print('User Not Eligible');
}

```

### Unsubscribe from Pollfish Listeners

Publishers should ensure to unsubscribe from Pollfish Notification listeners at the end of the state's lifecycle

```dart
@override
void dispose() {
    FlutterPollfish.instance.removeListeners();
    super.dispose();
}
```

## Following the rewarded and/or the Offerwall approach

An example is provided on [Github](https://github.com/pollfish/flutter-plugin-pollfish) that demonstrates how a publisher can implement the rewarded and/or the Offerwall approach. Publisher has to initialize Pollfish in reward mode = true and specify if Offerwall mode should be on. When a survey is received, the publisher can show a custom prompt, to incentivize user to participate to the survey. If the user clicks on the prompt, the publisher can call Pollfish show to show the questioanniare. Upon survey completion, the publisher can reward the user.


## Limitations / Minimum Requirements

This is just an initial version of the plugin. There are still some
limitations:

- Minimum iOS is 9.0 and minimum Android version is 21

For other Pollfish products, see
[Pollfish docs](https://www.pollfish.com/docs).


## Getting Started

If you would like to review an example in code please review the [Github project](https://github.com/pollfish/flutter-plugin-pollfish).

