# flutter_pollfish

A plugin for [Flutter](https://flutter.io) that supports rendering surveys using [Pollish SDKs](https://www.pollfish.com/docs/).

*Note*: This plugin is in beta, and may still have a few issues and missing APIs.

<br/>
<img style="margin:auto;  width:230px; display: block;" src="https://storage.googleapis.com/pollfish_production/multimedia/basic-format.gif"/>
<br/>

## Initializing the plugin

The Pollfish plugin must be initialized with a Pollfish API Key. You can retrieve an API key from Pollfish Dashboard when you [sign up](https://www.pollfish.com/signup/publisher) and create a new app.

```dart
FlutterPollfish.instance.init(apiKey: 'YOUR_API_KEY')
```

During initialization you can pass different optional params:

- pollfishPosition: int - TOP_LEFT=0 , BOTTOM_LEFT=1, TOP_RIGHT=2, BOTTOM_RIGHT=3, MIDDLE_LEFT=4, MIDDLE_RIGHT=5 (defines the side of Pollish panel, and position o Pollish indicator)
- indPadding: int - Sets padding (in dp) from top or bottom according to Position of the indicator
- debugMode: bool - Sets Pollfish SDK to Developer or Release mode. Use Developer mode to test your implementation with demo surveys
- customMode: bool - Initializes Pollfish in custom mode (used or implementing a Rewarded approach)
- requestUUID: String - Sets a unique id to identify a user and be passed through server-to-server callbacks

For example:

```dart
FlutterPollfish.instance.init('YOUR_API_KEY', pollfishPosition: 1, indPadding: 50 ,debugMode :debugMode, false , 'USER_ID');
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

## Listening to Pollish notifications

Publishers can register and receive notifications on different events during the lifetime of a survey

### Pollfish Survey Received notification

Once a survey is received, Pollish Survey Received notification is fired to inform the publisher. The notification includes several info around the survey such as:

- CPA: money to be earned in USD cents
- LOI: length of the survey is minutes
- IR: incidence rate (conversion)
- Survey Class: survey provider (Pollish, Toluna, Cint etc)


```dart
FlutterPollfish.instance.setPollfishReceivedSurveyListener(onPollfishSurveyReveived);

void onPollfishSurveyReveived(String result) => setState(() {

    List<String> surveyCharacteristics = result.split(',');

     if (surveyCharacteristics.length >= 4) {
       String _logText =
              'Survey Received: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]}';
    }
 });

```

### Pollfish Survey Completed notification

Once a survey is completed, Pollish Survey Completed notification is fired to inform the publisher. The notification includes several info around the survey such as:

- CPA: money to be earned in USD cents
- LOI: length of the survey is minutes
- IR: incidence rate (conversion)
- Survey Class: survey provider (Pollish, Toluna, Cint etc)


```dart
FlutterPollfish.instance.setPollfishCompletedSurveyListener(onPollfishSurveyCompleted);

void onPollfishSurveyCompleted(String result) => setState(() {

    List<String> surveyCharacteristics = result.split(',');

     if (surveyCharacteristics.length >= 4) {
       String _logText =
              'Survey Completed: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]}';
    }
 });

```

### Pollfish Survey Panel Opened notification

A notification that informs that Pollfish Survey panel opened


```dart
FlutterPollfish.instance.setPollfishSurveyOpenedListener(onPollfishSurveyOpened);

void onPollfishSurveyOpened() => setState(() {

   String _logText = 'Survey Panel Open';
}

```

### Pollfish Survey Panel Closed notification

A notification that informs that Pollfish Survey panel closed


```dart
FlutterPollfish.instance.setPollfishSurveyClosedSurveyListener(onPollfishSurveyClosed);

void onPollfishSurveyClosed() => setState(() {

   String _logText = 'Survey Panel Open';
}

```

### Pollfish Survey Not Available notification

A notification that informs that no survey is available for that user


```dart
FlutterPollfish.instance.setPollfishSurveyNotAvailableSurveyListener(onPollfishSurveyNotAvailable);

void onPollfishSurveyNotAvailable() => setState(() {

   String _logText = 'Survey Not Available';
}

```

### Pollfish User Reject Survey notification

A notification that informs that the user rejected the survey


```dart
FlutterPollfish.instance.setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);

void onPollfishUserRejectedSurvey() => setState(() {

   String _logText = 'User Rejected Survey';
}

```

### Pollfish User Not Eligible notification

A notification that informs that the user got screened out from the survey


```dart
FlutterPollfish.instance.setPollfishUserNotEligibleListener(onPollfishUserNotEligible);

void onPollfishUserNotEligible() => setState(() {

   String _logText = 'User Not Eligible';
}

```


## Following the rewarded approach

An example is provided to demonstrate how a publisher can implement a rewarded approach. Publisher has to initialize Pollish in custom mode = true and immediately after the the init function to call Pollish hide. When a survey is received publisher can show a custom prompt to incentivize user to participate to the survey. If the user clicks on the prompt the publisher can call Pollish show. On survey complete, publisher can reward the user.



## AndroidManifest changes

Pollfish requires the INTERNET permission in order to work

```
 <uses-permission android:name="android.permission.INTERNET"/>
```


## Limitations / Minimum Requirements

This is just an initial version of the plugin. There are still some
limitations:

- You cannot pass custom attributes during initialization
- No tests implemented yet
- Minimum iOS is 9.0 and minimum Android version is 17

For other Pollfish products, see
[Pollfish docs](https://www.pollfish.com/docs).


## Getting Started

If you would like to implement the Rewarded approach or just review an example in code, you can review the example app on [Github](https://github.com/pollfish/flutter-plugin-pollfish).

<br/>
<img style="margin:auto;  width:230px; display: block;" src="https://storage.googleapis.com/pollfish_production/doc_images/flutter_example.gif"/>
<br/>
