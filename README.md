# flutter_pollfish

Pollfish Flutter plugin, allows integration of Pollfish surveys into Flutter Android and iOS apps.

<br/>

# Prerequisites

* Android SDK 21 or higher using Google Play Services
* iOS version 11.0 or higher
* Flutter version 1.20.0 or higher
* Dart SDK version 2.12.0 or higher
* CocoaPods version 1.10.0 or higher

<br/>

> **Note:** Apps designed for [Children and Families program](https://play.google.com/about/families/ads-monetization/) should not be using Pollfish SDK, since Pollfish does not collect responses from users less than 16 years old

> **Note:** Pollfish iOS SDK utilizes Apple's Advertising ID (IDFA) to identify and retarget users with Pollfish surveys. As of iOS 14 you should initialize Pollfish Flutter plugin in iOS only if the relevant IDFA permission was granted by the user

<br/>

# Quick Guide

* Sign Up for a Pollfish Developer account,
* Create new apps for each targeting platform (Android & iOS) and grap the API keys
* Install Pollfish plugin and call init function
* Set to Release mode and publish on app store
* Update your app's privacy policy
* Request your account to get verified from Pollfish Dashboard

<br/>

# Migrate to v4

Pollfish Flutter Plugin v4 introduces a different API with added customization options during initialization. If you have already integrated Pollfish Flutter Plugin < v4 in you app, please take some time reading the migration guide below.

<details><summary>➤ <b>Migration Guide</b> (Click to expand)</summary>
<table>
<tr>
<td>
<br/>

<span style="color:red">-</span>

<td>

#### **Initialization** <br/>

```dart
FlutterPollfish.instance.init(
    apiKey: 'YOUR_API_KEY',
    pollfishPosition: 5,
    indicatorPadding: 40,
    rewardMode: false,
    releaseMode: true,
    requestUUID: 'REQUEST_UUID',
    offerwallMode: false,
    userProperties: <String, dynamic>{ 
      'gender': '1',
      'education': '1',
      ...
    });
```

<tr>
<td>

<span style="color:green">+</span>

<td>
<br/>

```dart
FlutterPollfish.instance.init(
    androidApiKey: 'ANDROID_API_KEY', // Required
    iOSApiKey: 'IOS_API_KEY',         // Required
    pollfishPosition: Position.bottomRight,
    indicatorPadding: 40,
    rewardMode: false,
    releaseMode: true,
    requestUUID: 'REQUEST_UUID',
    offerwallMode: false,
    userProperties: <String, dynamic>{ 
      'gender': '1',
      'education': '1',
      ...
    });
```

</table>
</details>

<br/>

# Analytical Steps

## 1. Obtain a Developer Account

Register as a Developer at [www.pollfish.com](http://www.pollfish.com)

<br/>

## 2. Add new apps in Pollfish panel and copy the given API Keys

Login at [www.pollfish.com](http://www.pollfish.com), add a new app for each targeting platform (Android & iOS) at Pollfish panel in section My Apps and copy the given API keys to use later in your init function in your app.

<br/>

## 3. Install the plugin

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  ...
  flutter_pollfish: ^4.1.5
```

Execute the following command

```bash
flutter packages get
```

<br/>

**Android 12**

Apps updating their target API level to 31 (Android 12) or higher will need to declare a Google Play services normal permission in the AndroidManifest.xml file.

Navigate to the `android/app/src/main` directory inside your project's root, locate the AndroidManifest.xml file and add the following line just before the `<application>`.

```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID" />
```

You can read more about Google Advertising ID changes [here](https://support.google.com/googleplay/android-developer/answer/6048248).


<br/>

**iOS 14+**

Request IDFA Permission (Recommended but optional)

Pollfish surveys can work with or without the IDFA permission on iOS 14+. If no permission is granted in the ATT popup, the SDK will serve non personalized surveys to the user. In that scenario the conversion is expected to be lower. Offerwall integrations perform better compared to single survey integrations when no IDFA permission is given. Our recommendation is that you should ask for IDFA usage permission prior to Pollfish initialization.

<br/>

## 4. Import `flutter_pollfish.dart` package

```dart
import 'package:flutter_pollfish/flutter_pollfish.dart';
```

<br/>

## 5. Initialize Pollfish

Import Pollfish

```dart
import 'package:flutter_pollfish/flutter_pollfish.dart';
```

The Pollfish plugin must be initialized with one or two api keys depending on which platforms are you targeting. You can retrieve an API key from Pollfish Dashboard when you [sign up](https://www.pollfish.com/signup/publisher) and create a new app.

```dart
FlutterPollfish.instance.init(androidApiKey: 'ANDROID_API_KEY', iOSApiKey: 'IOS_API_KEY', rewardMode: true); // Android and iOS
```

```dart
FlutterPollfish.instance.init(androidApiKey: 'ANDROID_API_KEY', iOSApiKey: null, rewardMode: true); // Android only
```

```dart
FlutterPollfish.instance.init(androidApiKey: null, iOSApiKey: 'IOS_API_KEY', rewardMode: true); // iOS only
```

<br/>

### 5.1 Configure Pollfish behaviour (Optional)

You can set several params to control the behaviour of Pollfish survey panel within your app with the use of the various optional arguments of the initialization function. Below you can see all the available options.

<br/>

> **Note:** All the params are optional, except the **`releaseMode`** setting that turns your integration in release mode prior publishing to the Google Play or App Store.

<br/>

No      | Type                  | Description
--------|-----------------------|------------
5.1.1   | `Position`            | **`indicatorPosition`** <br/> Sets the Position where you wish to place the Pollfish indicator.
5.1.2   | `int`                 | **`indicatorPadding`** <br/> Sets padding from the top or bottom according to Position of the indicator.
5.1.3   | `bool`                | **`offerwallMode`** <br/> Sets Pollfish to Offerwall mode.
5.1.4   | `bool`                | **`releaseMode`** <br/> Sets Pollfish SDK to Debug or Release mode.
5.1.5   | `bool`                | **`rewardMode`** <br/> Initializes Pollfish in reward mode.
5.1.6   | `String`              | **`requestUUID`** <br/> Sets a unique id to identify a user and be passed through server-to-server callbacks.
5.1.7   | `Map<String, Object>` | **`userProperties`** <br/> Send attributes that you receive from your app regarding a user, in order to receive a better fill rate and higher priced surveys.
5.1.8   | `RewardInfo`          | **`rewardInfo`** <br/> An object holding information regarding the survey completion reward.
5.1.9   | `String`              | **`clickId`** <br/> A pass throught param that will be passed back through server-to-server callback.
5.1.10  | `String`              | **`userId`** <br/> A unique id used to identify a user.
5.1.11  | `String`              | **`signature`** <br/> A parameter used to secure the `rewardConversion` and `rewardName` parameters passed on `rewardInfo` `Json` object.

<br/>

### 5.1.1. **`indicatorPosition`**

Sets the Position where you wish to place Pollfish indicator --> ![alt text](https://storage.googleapis.com/pollfish_production/multimedia/pollfish_indicator_small.png)

<br/>

Also this setting sets from which side of the screen you would like Pollfish survey panel to slide in.

<br/> 

Pollfish indicator is shown only if Pollfish is used in a non rewarded mode.

<br/>

<span style="text-decoration: underline">There are six different options available: </span>

* `Position.topLeft`
* `Position.topRight`
* `Position.middleLeft`
* `Position.middleRight`
* `Position.bottomLeft`
* `Position.bottomRight`

If you do not set explicity a position for Pollfish indicator, it will appear by default at `Position.topLeft`

<br/>

> **Note:** If you would like to skip the Pollfish Indicator please set the `rewardMode` to `true`

<br/>

Below you can see an example on how you can set Pollfish indicator to slide from top right corner of the screen:

<br/>

```dart
FlutterPollfish.instance.init(
  ...
  indicatorPosition: Position.topRight
);
```

<br/>

### 4.1.2. **`indicatorPadding`**

The padding from the top or bottom of the screen according to position of the indicator (small icon) specified above (`.topLeft` is the default value)

```dart
FlutterPollfish.instance.init(
  ...
  indicatorPadding: 8
);
```

> **Note:** if used in bottom position, padding is calculating from the bottom

<br/>

### 4.1.3. **`offerwallMode`**

Enables Pollfish in offerwall mode. If not specified Pollfish shows one survey at a time.

Below you can see an example on how you can intialize Pollfish in Offerwall mode:

```dart
FlutterPollfish.instance.init(
  ...
  offerwallMode: true
);
```

<br/>

### 4.1.4. **`releaseMode`**

Sets Pollfish SDK to Developer or Release mode. If you do not set this param it will turn the SDK to Developer mode by default in order for the publisher to be able to test the survey flow.

<span style="text-decoration: underline">You can use Pollfish either in Debug or in Release mode.</span>

*   **Debug/Developer mode** is used to show to the developer how Pollfish will be shown through an app (useful during development and testing).
*   **Release mode** is the mode to be used for a released app in AppStore (start receiving paid surveys).

> **Note:** Be careful to set release mode parameter to true prior releasing to Google Play or AppStore!

```dart
FlutterPollfish.instance.init(
  ...
  releaseMode: true
);
```

<br/>

### 4.1.5. **`rewardMode`**

Initializes Pollfish in reward mode. This means that Pollfish Indicator (section 4.1.1) will not be shown and Pollfish survey panel will be automatically hidden until the publisher explicitly calls Pollfish `show` function (The publisher should wait for the Pollfish Survey Received Callback). This behaviour enables the option for the publishers, to show a custom prompt to incentivize the users to participate in a survey.

> **Note:** If not set, the default value is false and Pollfish indicator is shown.

This mode should be used if you want to incentivize users to participate to surveys. We have a detailed guide on how to implement the rewarded approach [here](https://www.pollfish.com/docs/rewarded-surveys)

> **Note:** Reward mode should be used along with the Survey Received callback so the publisher knows when to prompt the user and call `FlutterPollfish.instance.show();`

<br/>

```dart
FlutterPollfish.instance.init(
  ...
  rewardMode: true
);
```

<br/>

### 4.1.6. **`requestUUID`**

Sets a unique id to identify a user or a request and be passed back to the publisher through server-to-server callbacks. You can read more on how to retrieve this param through the callbacks [here](https://www.pollfish.com/docs/s2s)

<br/>

Below you can see an example on how you can pass a requestUUID during initialization:

```dart
FlutterPollfish.instance.init(
  ...
  requestUUID: "REQUEST_UUID"
);
```

<br/>

### 4.1.7. **`userProperties(Json)`**

Passing user attributes to skip or shorten Pollfish Demographic surveys.

If you know upfront some user attributes like gender, age, education and others you can pass them during initialization in order to shorten or skip entirely Pollfish Demographic surveys and archieve better fill rate and higher priced surveys.

> **Note:** You need to contact Pollfish live support on our website to request your account to be eligible for submitting demographic info through your app, otherwise values submitted will be ignored by default.

> **Note:** You can read more on demographic surveys along with a list with all the available options [here](https://www.pollfish.com/docs/demographic-surveys)

An example of how you can pass user demographics can be found below:

```dart
final userProperties = {
	"gender": "1",
	"year_of_birth": "1974",
	"marital_status": "2",
	"parental": "3",
	"education": "1",
	"employment": "1",
	"career": "2",
	"race": "3",
	"income": "1",
};

FlutterPollfish.instance.init(
  ...
  userProperties: userProperties
);
```

<br/>

### 4.1.8. **`rewardInfo`**

A Json object passing information during initialization regarding the reward settings, overriding the values as speciefied on the Publisher's Dashboard

<br/>

```dart
class RewardInfo(rewardName: String, rewardConversion: double)
```

<br/>

Field                  | Description
-----------------------|------------
**`rewardName`**       | Overrides the reward name as specified in the Publisher's Dashboard
**`rewardConversion`** | Overrides the reward conversion as specified on the Publisher's Dashboard. Conversion is expecting a number matching this function ( ```1 USD = X Points``` ) where ```X``` is a ```Double``` number.

<br/>

```dart
final rewardInfo = RewardInfo('Dollars', 1.2);

FlutterPollfish.instance.init(
  ...
  rewardInfo: rewardInfo
);
```

<br/>

### 4.1.9. **`clickId`**

A pass through parameter that will be returned back to the publisher through server-to-server callbacks as specified [here](https://www.pollfish.com/docs/s2s)

<br/>

```dart
FlutterPollfish.instance.init(
  ...
  clickId: clickId
);
```

<br/>

### 4.1.10. **`.userId(String)`**

A unique id used to identify the user

Setting the `userId` will override the default behaviour and use that instead of the Advertising Id, of the corresponding platform, in order to identify a user

<span style="color: red">You can pass the id of a user as identified on your system. Pollfish will use this id to identify the user across sessions instead of an ad id/idfa as advised by the stores. You are solely responsible for aligning with store regulations by providing this id and getting relevant consent by the user when necessary. Pollfish takes no responsibility for the usage of this id. In any request from your users on resetting/deleting this id and/or profile created, you should be solely liable for those requests.</span>

<br/>

```dart
FlutterPollfish.instance.init(
  ...
  userId: userId
);
```

<br/>

### 4.1.11. **`.signature(String)`**

An optional parameter used to secure the `rewardName` and `rewardConversion` parameters as provided in the `RewardInfo` object (4.1.10). If `rewardConversion` and `rewardName` are defined, `signature` is required to be calculated and set as well.

This parameter can be used to prevent tampering around reward conversion, if passed during initialisation. The platform supports url validation by requiring a hash of the `rewardConversion`, `rewardName`, and `clickId`. Failure to pass validation will result in no surveys return and firing **`PollfishSurveyNotAvailable`** callback.

In order to generate the `signature` field you should sign the combination of `$rewardConversion$rewardName$clickId` parameters using the HMAC-SHA1 algorithm and your account's secret_key that can be retrieved from the Account Information section on your Pollfish Dashboard.

> **Note:** Although `rewardConversion` and `rewardName` are mandatory for the hashing to work, `clickId` parameter is optional and you should add them for extra security.

<br/>

> **Note:** Please keep in mind if your `rewardConversion` is a whole number, you have to calculate the signature useing the floating point value with 1 decimal point.

<br/>

```dart
FlutterPollfish.instance.init(
  ...
  signature: "SIGNATURE"
);
```

<br/>

Dart code to generate valid signatures.

This method requires you to install the [`crypto`](https://pub.dev/packages/crypto) Dart package.

<br/>

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

double rewardConversion = 1.2;
String rewardName = '<REWARD_NAME>';
String clickId = '<CLICK_ID>';

String secret = '<ACCOUNT_SECRET_KEY>';
String message = '$rewardConversion$rewardName$clickId';

Hmac hmac = new Hmac(sha1, secret.codeUnits);
Digest digest = hmac.convert(message.codeUnits);
String base64Mac = base64.encode(digest.bytes);
```

<br/>

Example of basic Pollfish initialization

```dart
FlutterPollfish.instance.init(
  androidApiKey: 'ANDROID_API_KEY',
  iOSApiKey: 'IOS_API_KEY',
  rewardMode: true);
```

Example of Pollfish configuration using the available options

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
  userId: 'USER_ID',
  rewardInfo: RewardInfo('Point', 1.3));
```

<br/>

## 6. Update your Privacy Policy

### Add the following paragraph to your app's privacy policy

<br/>

*“Survey Serving Technology*

*This app uses Pollfish SDK. Pollfish is an on-line survey platform, through which, anyone may conduct surveys. Pollfish collaborates with Publishers of applications for smartphones in order to have access to users of such applications and address survey questionnaires to them. When a user connects to this app, a specific set of user's device data (including Advertising ID, Device ID, other available electronic identifiers and further response meta-data is automatically sent, via our app, to Pollfish servers, in order for Pollfish to discern whether the user is eligible for a survey. For a full list of data received by Pollfish through this app, please read carefully the Pollfish respondent terms located at [https://www.pollfish.com/terms/respondent](https://www.pollfish.com/terms/respondent). These data will be associated with your answers to the questionnaires whenever Pollfish sends such questionnaires to eligible users. Pollfish may share such data with third parties, clients and business partners, for commercial purposes. By downloading the application, you accept this privacy policy document and you hereby give your consent for the processing by Pollfish of the aforementioned data. Furthermore, you are informed that you may disable Pollfish operation at any time by visiting the following link [https://www.pollfish.com/respondent/opt-out](https://www.pollfish.com/respondent/opt-out). We once more invite you to check the Pollfish respondent's terms of use, if you wish to have more detailed view of the way Pollfish works and with whom Pollfish may further share your data."*

---

<br/>

<img style="margin: 0 auto; display: block;" src="https://storage.googleapis.com/pollfish_production/multimedia/basic-format.gif"/>

<br/>

If you have any question, like why you do not see surveys on your own device in release mode, please have a look in our <a href="https://help.pollfish.com/en/collections/24867-faq-publishers">FAQ page</a>

<br/>

> **Note:** Please bear in mind that the first time a user is introduced to the platform, when no paid surveys are available, a standalone demographic survey will be shown, as a way to increase the user's exposure in our clients' survey inventory. This survey returns no payment to app publishers, since it is part of the process users need to go through in order to join the platform. Bear in mind that if a paid survey is available at that point of time, the demographic questions will be inserted at the begining of the survey, before the actual survey questions. Our aim is to provide advanced targeting solutions to our customers and to do that we need to have this information on the available users. Targeting by marital status or education etc. are highly popular options in the survey world and we need to keep up with the market. A vast majority of our clients are looking for this option when using the platform. Based on previous data, over 80% of the surveys designed on the platform require this new type of targeting.

<br/>

<table style="border:0 !important;">
<tr>
<td><img src="https://storage.googleapis.com/pollfish-images/targeting.png" style="padding:4px"/></td>
<td><img src="https://storage.googleapis.com/pollfish-images/results.png" style="padding:4px"/></td>
</tr>
</table>
<br/>


In our efforts to include publishers in this process and be as transparent as possible we provide full control over the process. We let publishers decide if their users are served these standalone surveys or not, in 2 different ways. Firstly by monitoring the process in code and excluding any users by listening to the relevant noitifications (Pollfish Survey Received, Pollfish Survey Completed) and checking the Pay Per Survey (PPS) field which will be 0 USD cents. Secondly, publishers can disable the standalone demographic surveys through the Pollfish Developer Dashboard in the Settings area of an app. You can read more on demographic surveys <a href="https://www.pollfish.com/docs/demographic-surveys">here</a>.

<br/>

## 7. Request your account to get verified

After your app is published on an app store you should request your account to get verified from your Pollfish Developer Dashboard.

<br/>

<img style="margin: 0 auto; display: block;" src="https://storage.googleapis.com/pollfish_production/doc_images/verify_account.png"/>

<br/>

When your account is verified you will be able to start receiving paid surveys from Pollfish clients.

<br/>

# Optional Section

In this section we will list several options that can be used to control Pollfish surveys behaviour, how to listen to several notifications or how to be eligible to more targeted (high-paid) surveys. All these steps are optional.

<br/>

## 8. Implement Pollfish Event Listeners

<br/>

### 8.1. Get notified when a Pollfish survey is received

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

### 8.2. Get notified when a Pollfish survey is completed

You can get notified when a user completed a survey. With this notification, you can also get informed about the type of survey, money earned from that survey in USD cents and other info around the survey such as LOI and IR.

```dart
FlutterPollfish.instance.setPollfishSurveyCompletedListener(onPollfishSurveyCompleted);

void onPollfishSurveyCompleted(SurveyInfo sureyInfo) => setState(() {
    print('Survey Completed: - ${surveyInfo.toString()}');
});
```

<br/>

### 8.3. Get notified when a user is not eligible for a Pollfish survey

You can get notified when a user is not eligible for a Pollfish survey. In market research monetization, users can get screened out while completing a survey beucase they are not relevant with the audience that the market researcher was looking for. In that case the user not eligible notification will fire and the publisher will make no money from that survey. The user not eligible notification will fire after the surveyReceived event, when the user starts completing the survey.

```dart
FlutterPollfish.instance.setPollfishUserNotEligibleListener(onPollfishUserNotEligible);

void onPollfishUserNotEligible() => setState(() {
   print('User Not Eligible');
}
```

<br/>

### 8.4. Get notified when a Pollfish survey is not available

You can be notified when a Pollfish survey is not available.

```dart
FlutterPollfish.instance.setPollfishSurveyNotAvailableListener(onPollfishSurveyNotAvailable);

void onPollfishSurveyNotAvailable() => setState(() {
   print('Survey Not Available');
}
```

<br/>

### 8.5. Get notified when a user has rejected a Pollfish survey

You can be notified when a user has rejected a Pollfish survey.

```dart
FlutterPollfish.instance.setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);

void onPollfishUserRejectedSurvey() => setState(() {
   print('User Rejected Survey');
}
```

<br/>

### 8.6. Get notified when a Pollfish survey panel has opened

You can register and get notified when a Pollfish survey panel has opened. Publishers usually use this notification to pause a game until the pollfish panel is closed again.

```dart
FlutterPollfish.instance.setPollfishOpenedListener(onPollfishOpened);

void onPollfishOpened() => setState(() {
   print('Survey Panel Open');
}
```

<br/>

### 8.7. Get notified when a Pollfish survey panel has closed

You can register and get notified when a Pollfish survey panel has closed. Publishers usually use this notification to resume a game that they have previously paused when the Pollfish panel was opened.

```dart
FlutterPollfish.instance.setPollfishClosedListener(onPollfishClosed);

void onPollfishClosed() => setState(() {
   print('Survey Panel Closed');
}
```

<br/>

### 8.8 Unsubscribe from Pollfish Listeners

Please ensure you unsubscribe from Pollfish notification listeners at the end of the state's lifecycle

```dart
@override
void dispose() {
    FlutterPollfish.instance.removeListeners();
    super.dispose();
}
```

<br/>

## 9. Manually show/hide Pollfish panel

During the lifetime of a survey, you can manually hide and show Pollfish by calling the following functions.

```dart
FlutterPollfish.instance.show();
```

or

```dart
FlutterPollfish.instance.hide();
```

<br/>

## 10. Check if Pollfish surveys are available on your device

After a Pollish survey is received you can check at any time if the survey is available at the device by calling the following function.

```dart
FlutterPollfish.instance.isPollfishPresent().then((isPresent) => {
  print("isPresent: $isPresent");
});
```

<br/>

## 11. Check if Pollfish panel is open

You can check at any time if the survey panel is open by calling the following function.

```dart
FlutterPollfish.instance.isPollfishPanelOpen().then((isOpen) => {
  print("isOpen: $isOpen");
});
```

<br/>

# Example

If you would like to implement the Rewarded approach or just review an example in code, you can review the example app on [Github](https://github.com/pollfish/flutter-plugin-pollfish/tree/master/example).

<br/>

# More info

You can read more info on how the Native Pollfish SDKs work on Android and iOS or how to set up properly a Flutter environment at the following links:

<br/>

[Pollfish Flutter Plugin Documentation](https://pollfish.com/docs/flutter)

[Pollfish Android SDK Integration Guide](https://pollfish.com/docs/android)

[Pollfish iOS SDK Integration Guide](https://pollfish.com/docs/ios)

[Flutter Starting Guide](https://flutter.dev/docs/get-started)
