#import <Flutter/Flutter.h>

@interface FlutterPollfishPlugin : NSObject<FlutterPlugin>

+ (void)surveyCompleted:(NSNotification *)notification;
+ (void)surveyOpened:(NSNotification *)notification;
+ (void)surveyClosed:(NSNotification *)notification;
+ (void)surveyReceived:(NSNotification *)notification;
+ (void)surveyNotAvailable:(NSNotification *)notification;
+ (void)userNotEligible:(NSNotification *)notification;
+ (void)userRejectedSurvey:(NSNotification *)notification;

@end
