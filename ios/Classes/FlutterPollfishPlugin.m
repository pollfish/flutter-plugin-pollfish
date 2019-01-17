#import "FlutterPollfishPlugin.h"
#import <Pollfish/Pollfish.h>

FlutterMethodChannel *_channel;

@implementation FlutterPollfishPlugin

//Loads before application's didFinishLaunching method is called (i.e. when this plugin
//is added to the Objective C runtime)
+ (void)load
{
    // Register for Pollfish notifications to inform Unity
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(surveyCompleted:)
                                                 name:@"PollfishSurveyCompleted" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(surveyOpened:)
                                                 name:@"PollfishOpened" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(surveyClosed:)
                                                 name:@"PollfishClosed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(surveyReceived:)
                                                 name:@"PollfishSurveyReceived" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(surveyNotAvailable:)
                                                 name:@"PollfishSurveyNotAvailable" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotEligible:)
                                                 name:@"PollfishUserNotEligible" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRejectedSurvey:)
                                                 name:@"PollfishUserRejectedSurvey" object:nil];
    
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    _channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_pollfish"
                                     binaryMessenger:[registrar messenger]];
    
 
    FlutterPollfishPlugin* instance = [[FlutterPollfishPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:_channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    if ([@"init" isEqualToString:call.method]) {
        [self callInitialize:call result:result];
        return;
    }else if ([@"show" isEqualToString:call.method]) {
        [Pollfish show];
        return;
    }else if ([@"hide" isEqualToString:call.method]) {
        [Pollfish hide];
        return;
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)callInitialize:(FlutterMethodCall *)call result:(FlutterResult)result {

    NSString *api_key = (NSString *) call.arguments[@"api_key"];
    
    if (api_key == nil || [api_key length] == 0) {
        result([FlutterError errorWithCode:@"no_api_key"
                                   message:@"a non-empty Pollfish API Key was not provided"
                                   details:nil]);
        return;
        
    }

    int pollfishPosition=0;
    int indPadding =50;
    bool debugMode=true;
    bool customMode = false;
    NSString *request_uuid = nil;
    
    if (call.arguments[@"pollfishPosition"] != nil) {
        
        pollfishPosition = (int) call.arguments[@"pollfishPosition"];
    }
    if (call.arguments[@"indPadding"] != nil) {
        indPadding  = (int) call.arguments[@"indPadding"];
    }
    if (call.arguments[@"debugMode"] != nil) {
        debugMode = (bool) call.arguments[@"debugMode"];
    }
    if (call.arguments[@"customMode"] != nil) {
        customMode = call.arguments[@"customMode"];
    }
    if (call.arguments[@"request_uuid"] != nil) {
        request_uuid = call.arguments[@"request_uuid"];
    }
    
    [Pollfish initAtPosition:pollfishPosition
                 withPadding: indPadding
             andDeveloperKey: api_key
               andDebuggable: debugMode
               andCustomMode: customMode
              andRequestUUID: request_uuid];
}


// Pollfish notiications

+ (void)surveyCompleted:(NSNotification *)notification
{
    int surveyCPA = [[[notification userInfo] valueForKey:@"survey_cpa"] intValue];
    int surveyIR = [[[notification userInfo] valueForKey:@"survey_ir"] intValue];
    int surveyLOI = [[[notification userInfo] valueForKey:@"survey_loi"] intValue];

    NSString *surveyClass =(NSString *) [[notification userInfo] valueForKey:@"survey_class"];

    const char *surveyInfo = [[NSString stringWithFormat:@"%d,%d,%d,%@",surveyCPA, surveyIR, surveyLOI, surveyClass] UTF8String];

    [_channel invokeMethod:@"pollfishSurveyCompleted" arguments:[NSString stringWithFormat:@"%s",surveyInfo]];
}

+ (void)surveyOpened:(NSNotification *)notification
{
     [_channel invokeMethod:@"pollfishSurveyOpened" arguments:nil];
}

+ (void)surveyClosed:(NSNotification *)notification
{
    [_channel invokeMethod:@"pollfishSurveyClosedSurvey" arguments:nil];
}

+ (void)surveyReceived:(NSNotification *)notification
{

    int surveyCPA = [[[notification userInfo] valueForKey:@"survey_cpa"] intValue];
    int surveyIR = [[[notification userInfo] valueForKey:@"survey_ir"] intValue];
    int surveyLOI = [[[notification userInfo] valueForKey:@"survey_loi"] intValue];

    NSString *surveyClass =(NSString *) [[notification userInfo] valueForKey:@"survey_class"];

    const char *surveyInfo = [[NSString stringWithFormat:@"%d,%d,%d,%@",surveyCPA, surveyIR, surveyLOI, surveyClass] UTF8String];

    [_channel invokeMethod:@"pollfishSurveyReceived" arguments:[NSString stringWithFormat:@"%s",surveyInfo]];
}

+ (void)userNotEligible:(NSNotification *)notification
{
    [_channel invokeMethod:@"pollfishUserNotEligible" arguments:nil];
}

+ (void)userRejectedSurvey:(NSNotification *)notification
{
    [_channel invokeMethod:@"pollfishUserRejectedSurvey" arguments:nil];
}

+ (void)surveyNotAvailable:(NSNotification *)notification
{
    [_channel invokeMethod:@"pollfishSurveyNotAvailable" arguments:nil];
}


@end
