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
    } else if ([@"isPollfishPresent" isEqualToString: call.method]) {
        result([NSNumber numberWithBool:[Pollfish isPollfishPresent]]);
        return;
    } else if ([@"isPollfishPanelOpen" isEqualToString: call.method]) {
        result([NSNumber numberWithBool:[Pollfish isPollfishPanelOpen]]);
        return;
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)callInitialize:(FlutterMethodCall *) call result:(FlutterResult) result {
    NSString *apiKey = (NSString *) call.arguments[@"apiKey"];
    
    if (apiKey == nil || [apiKey length] == 0) {
        result([FlutterError errorWithCode:@"no_api_key"
                                   message:@"a non-empty Pollfish API Key was not provided"
                                   details:nil]);
        return;
    }

    __block int indicatorPosition = 0;
    __block int indicatorPadding = 8;
    __block BOOL rewardMode = false;
    __block BOOL releaseMode = false;
    __block BOOL offerwallMode = false;
    __block NSString *requestUUID = nil;
    __block NSDictionary *userProperties = nil;
    
    if (call.arguments[@"indicatorPosition"] != [NSNull null]) {
        indicatorPosition = (int) [call.arguments[@"indicatorPosition"] integerValue];
    }

    if (call.arguments[@"indicatorPadding"] != [NSNull null]) {
        indicatorPadding = (int) [call.arguments[@"indicatorPadding"] integerValue];
    }

    if (call.arguments[@"releaseMode"] != [NSNull null]) {
        releaseMode = (BOOL) [call.arguments [@"releaseMode"] boolValue];
    }

    if (call.arguments[@"rewardMode"] != [NSNull null]) {
        rewardMode = (BOOL)[call.arguments[@"rewardMode"] boolValue];
    }

    if (call.arguments[@"request_uuid"] != [NSNull null]) {
        requestUUID = call.arguments[@"requestuUUID"];
    }

    if (call.arguments[@"offerwallMode"] != [NSNull null]) {
        offerwallMode = (BOOL)[call.arguments[@"offerwallMode"] boolValue];
    }
    
    if (call.arguments[@"userProperties"] != [NSNull null]) {
        userProperties = (NSDictionary *) call.arguments[@"userProperties"];
    }

    PollfishParams *params = [[PollfishParams alloc] init:apiKey];

    [params indicatorPosition: (IndicatorPosition) indicatorPosition];
    [params indicatorPadding: indicatorPadding];
    [params releaseMode: releaseMode];
    [params rewardMode: rewardMode];
    [params offerwallMode: offerwallMode];
    [params requestUUID: requestUUID];
    [params platform: PlatformFlutter];
    
    UserProperties *userPropertiesBuilder = [[UserProperties alloc] init];
        
    [userProperties enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [userPropertiesBuilder customAttribute:object forKey:key];
    }];
    
    [params userProperties:userPropertiesBuilder];

    [Pollfish initWith:params delegate: self];
}

- (NSDictionary *)getDictionaryFrom:(SurveyInfo *) surveyInfo
{
    if (surveyInfo == nil) {
        return nil;
    }
    
    NSDictionary * payload = @{
        @"surveyCPA" : (surveyInfo.cpa ?: [NSNull null]),
        @"surveyIR" : (surveyInfo.ir ?: [NSNull null]),
        @"surveyLOI" : (surveyInfo.loi ?: [NSNull null]),
        @"rewardValue" : (surveyInfo.rewardValue ?: [NSNull null]),
        @"remainingCompletes" : (surveyInfo.remainingCompletes ?: [NSNull null]),
        @"surveyClass" : (surveyInfo.surveyClass ?: [NSNull null]),
        @"rewardName" : (surveyInfo.rewardName ?: [NSNull null])};
    
    return payload;
}

- (void) pollfishSurveyCompletedWithSurveyInfo:(SurveyInfo *)surveyInfo
{
    [_channel_pollfish invokeMethod:@"pollfishSurveyCompleted"
                          arguments:[self getDictionaryFrom:surveyInfo]];
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
    [_channel_pollfish invokeMethod:@"pollfishSurveyReceived"
                          arguments:[self getDictionaryFrom:surveyInfo]];
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
