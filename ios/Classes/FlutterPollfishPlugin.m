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
    NSString *apiKey = (NSString *) call.arguments[@"iOSApiKey"];
    
    if (apiKey == [NSNull null] || [apiKey length] == 0) {
        result([FlutterError errorWithCode:@"no_api_key"
                                   message:@"a non-empty Pollfish API Key was not provided"
                                   details:nil]);
        return;
    }
    
    PollfishParams *params = [[PollfishParams alloc] init:apiKey];
    
    if (call.arguments[@"indicatorPosition"] != [NSNull null]) {
        int indicatorPosition = (int) [call.arguments[@"indicatorPosition"] integerValue];
        [params indicatorPosition: (IndicatorPosition) indicatorPosition];
    }

    if (call.arguments[@"indicatorPadding"] != [NSNull null]) {
        int indicatorPadding = (int) [call.arguments[@"indicatorPadding"] integerValue];
        [params indicatorPadding: indicatorPadding];
    }

    if (call.arguments[@"releaseMode"] != [NSNull null]) {
        BOOL releaseMode = (BOOL) [call.arguments [@"releaseMode"] boolValue];
        [params releaseMode: releaseMode];
    }

    if (call.arguments[@"rewardMode"] != [NSNull null]) {
        BOOL rewardMode = (BOOL)[call.arguments[@"rewardMode"] boolValue];
        [params rewardMode: rewardMode];
    }

    if (call.arguments[@"requestUUID"] != [NSNull null]) {
        NSString *requestUUID = call.arguments[@"requestUUID"];
        [params requestUUID: requestUUID];
    }

    if (call.arguments[@"offerwallMode"] != [NSNull null]) {
        BOOL offerwallMode = (BOOL)[call.arguments[@"offerwallMode"] boolValue];
        [params offerwallMode: offerwallMode];
    }
    
    if (call.arguments[@"userProperties"] != [NSNull null]) {
        NSDictionary *userProperties = (NSDictionary *) call.arguments[@"userProperties"];
        UserProperties *userPropertiesBuilder = [[UserProperties alloc] init];
            
        [userProperties enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
            [userPropertiesBuilder customAttribute:object forKey:key];
        }];
        
        [params userProperties:userPropertiesBuilder];
    }
    
    if (call.arguments[@"clickId"] != [NSNull null]) {
        NSString *clickId = call.arguments[@"clickId"];
        [params clickId:clickId];
    }
    
    if (call.arguments[@"signature"] != [NSNull null]) {
        NSString *signature = call.arguments[@"signature"];
        [params signature:signature];
    }
    
    if (call.arguments[@"rewardInfo"] != [NSNull null]) {
        NSDictionary *rewardInfoDict = (NSDictionary *) call.arguments[@"rewardInfo"];
        
        NSString *rewardName = [rewardInfoDict objectForKey:@"rewardName"];
        double rewardConversion = [[rewardInfoDict objectForKey:@"rewardConversion"] doubleValue];
        
        if (rewardName != nil) {
            RewardInfo *rewardInfo = [[RewardInfo alloc] initWithRewardName:rewardName rewardConversion:rewardConversion];
            [params rewardInfo:rewardInfo];
        }
    }

    [params platform: PlatformFlutter];
    
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
