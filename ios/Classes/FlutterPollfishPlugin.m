#import "FlutterPollfishPlugin.h"
#import <Pollfish/Pollfish-Swift.h>

FlutterMethodChannel *_channel_pollfish;

@implementation FlutterPollfishPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    _channel_pollfish = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_pollfish"
                                     binaryMessenger:[registrar messenger]];
    
 
    FlutterPollfishPlugin* instance = [[FlutterPollfishPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:_channel_pollfish];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    if ([@"init" isEqualToString:call.method]) {
        [self callInitialize:call result:result];
        return;
    } else if ([@"show" isEqualToString:call.method]) {
        [Pollfish show];
        return;
    } else if ([@"hide" isEqualToString:call.method]) {
        [Pollfish hide];
        return;
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)callInitialize:(FlutterMethodCall *)call result:(FlutterResult)result {

    NSString *api_key = (NSString *) call.arguments[@"api_key"];
    
    if (api_key == [NSNull null] || [api_key length] == 0) {
        result([FlutterError errorWithCode:@"no_api_key"
                                   message:@"a non-empty Pollfish API Key was not provided"
                                   details:nil]);
        return;
    }

    __block int pollfishPosition = 0;
    __block int indPadding = 50;
    __block BOOL rewardMode = false;
    __block BOOL releaseMode = false;
    __block BOOL offerwallMode = false;
    __block NSString *requestUUID = nil;
    
    if (call.arguments[@"pollfishPosition"] != [NSNull null]) {
        pollfishPosition = (int) [call.arguments[@"pollfishPosition"]integerValue];
    }

    if (call.arguments[@"indPadding"] != [NSNull null]) {
        indPadding  = (int) [call.arguments[@"indPadding"] integerValue];
    }

    if (call.arguments[@"releaseMode"] != [NSNull null]) {
        releaseMode = (BOOL) [call.arguments [@"releaseMode"] boolValue];
    }

    if (call.arguments[@"rewardMode"] != [NSNull null]) {
        NSLog(@"rewardMode is: %@", call.arguments[@"rewardMode"]);
        rewardMode = (BOOL)[call.arguments[@"rewardMode"] boolValue];
        NSLog(@"rewardMode is: %d",rewardMode);
    }

    if (call.arguments[@"request_uuid"] != [NSNull null]) {
        requestUUID = call.arguments[@"request_uuid"];
    }

    if (call.arguments[@"offerwallMode"] != [NSNull null]) {
        offerwallMode = (BOOL)[call.arguments[@"offerwallMode"]boolValue];
    }

    PollfishParams *params = [[PollfishParams alloc] init:api_key];

    [params indicatorPosition: (IndicatorPosition) pollfishPosition];
    [params indicatorPadding: indPadding];
    [params releaseMode: releaseMode];
    [params rewardMode: rewardMode];
    [params offerwallMode: offerwallMode];
    [params requestUUID: requestUUID];
    [params platform: PlatformFlutter];

    NSLog(@"pollfishPosition is: %d", pollfishPosition);
    NSLog(@"indicatorPadding is: %d", indPadding);
    NSLog(@"releaseMode is: %d", releaseMode);
    NSLog(@"offerwallMode is: %d", offerwallMode);
    NSLog(@"rewardMode is: %d", rewardMode);
    NSLog(@"requestUUID is: %@", requestUUID);

    [Pollfish initWith:params delegate: self];
}

- (void) pollfishSurveyCompletedWithSurveyInfo:(SurveyInfo *)surveyInfo
{
    int surveyPrice = [[surveyInfo cpa] intValue];
    int surveyIR = [[surveyInfo ir] intValue];
    int surveyLOI = [[surveyInfo loi] intValue];

    NSString *surveyClass = [surveyInfo surveyClass];

    NSString *rewardName = [surveyInfo rewardName];
    int rewardValue = [[surveyInfo rewardValue] intValue];
    
    const char *result = [[NSString stringWithFormat:@"%d,%d,%d,%@,%@,%d", surveyPrice, surveyIR, surveyLOI, surveyClass, rewardName, rewardValue] UTF8String];
    
    [_channel_pollfish invokeMethod:@"pollfishSurveyCompleted" arguments:[NSString stringWithFormat:@"%s", result]];
}

- (void)pollfishOpened
{
     [_channel_pollfish invokeMethod:@"pollfishOpened" arguments:nil];
}

- (void)pollfishClosed
{
    [_channel_pollfish invokeMethod:@"pollfishClosed" arguments:nil];
}

- (void) pollfishSurveyReceivedWithSurveyInfo:(SurveyInfo *)surveyInfo
{

    if(surveyInfo != nil){
    
        int surveyPrice = [[surveyInfo cpa] intValue];
        int surveyIR = [[surveyInfo ir] intValue];
        int surveyLOI = [[surveyInfo loi] intValue];

        NSString *surveyClass = [surveyInfo surveyClass];

        NSString *rewardName = [surveyInfo rewardName];
        int rewardValue = [[surveyInfo rewardValue] intValue];
    
        const char *result = [[NSString stringWithFormat:@"%d,%d,%d,%@,%@,%d", surveyPrice, surveyIR, surveyLOI, surveyClass, rewardName, rewardValue] UTF8String];

        [_channel_pollfish invokeMethod:@"pollfishSurveyReceived" arguments:[NSString stringWithFormat:@"%s", result]];

    } else {
        [_channel_pollfish invokeMethod:@"pollfishSurveyReceived" arguments:@""];
    }
}

- (void)pollfishUserNotEligible
{
    [_channel_pollfish invokeMethod:@"pollfishUserNotEligible" arguments:nil];
}

- (void)pollfishUserRejectedSurvey
{
    [_channel_pollfish invokeMethod:@"pollfishUserRejectedSurvey" arguments:nil];
}

- (void) pollfishSurveyNotAvailable
{
    [_channel_pollfish invokeMethod:@"pollfishSurveyNotAvailable" arguments:nil];
}


@end
