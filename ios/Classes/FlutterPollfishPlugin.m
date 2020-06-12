#import "FlutterPollfishPlugin.h"
#import <Pollfish/Pollfish.h>

FlutterMethodChannel *_channel_pollfish;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(surveyReceived:) name:@"PollfishSurveyReceived" object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(surveyNotAvailable:)
                                                 name:@"PollfishSurveyNotAvailable" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotEligible:)
                                                 name:@"PollfishUserNotEligible" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRejectedSurvey:)
                                                 name:@"PollfishUserRejectedSurvey" object:nil];
    
}

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
    
    if (api_key == [NSNull null] || [api_key length] == 0) {
        result([FlutterError errorWithCode:@"no_api_key"
                                   message:@"a non-empty Pollfish API Key was not provided"
                                   details:nil]);
        return;
        
    }

    __block  int pollfishPosition=0;
    __block int indPadding =50;
   __block  BOOL rewardMode=false;
   __block  BOOL releaseMode = false;
    __block BOOL offerwallMode = false;
    __block NSString *request_uuid = nil;



    
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
        request_uuid = call.arguments[@"request_uuid"];
    }
    if (call.arguments[@"offerwallMode"] != [NSNull null]) {
        offerwallMode = (BOOL)[call.arguments[@"offerwallMode"]boolValue];
    }


    PollfishParams *pollfishParams =  [PollfishParams initWith:^(PollfishParams *pollfishParams) {
        
        NSLog(@"pollfishPosition is: %d", pollfishPosition);
        NSLog(@"indicatorPadding is: %d", indPadding);
        NSLog(@"releaseMode is: %d", releaseMode);
        NSLog(@"offerwallMode is: %d", offerwallMode);
        NSLog(@"rewardMode is: %d", rewardMode);
        
        
        pollfishParams.indicatorPosition=pollfishPosition;
        pollfishParams.indicatorPadding=indPadding;
        pollfishParams.releaseMode= releaseMode;
        pollfishParams.offerwallMode= offerwallMode;
        pollfishParams.rewardMode=rewardMode;
        pollfishParams.requestUUID=request_uuid;
    }];

  
    [Pollfish initWithAPIKey:api_key andParams:pollfishParams];
}


// Pollfish notiications

+ (void)surveyCompleted:(NSNotification *)notification
{
    int surveyCPA = [[[notification userInfo] valueForKey:@"survey_cpa"] intValue];
    int surveyIR = [[[notification userInfo] valueForKey:@"survey_ir"] intValue];
    int surveyLOI = [[[notification userInfo] valueForKey:@"survey_loi"] intValue];

    NSString *surveyClass =(NSString *) [[notification userInfo] valueForKey:@"survey_class"];
    
    NSString *rewardName =(NSString *) [[notification userInfo] valueForKey:@"reward_name"];
    int rewardValue = [[[notification userInfo] valueForKey:@"reward_value"] intValue];
    
      const char *surveyInfo = [[NSString stringWithFormat:@"%d,%d,%d,%@,%@,%d",surveyCPA, surveyIR, surveyLOI, surveyClass, rewardName, rewardValue] UTF8String];
    
    [_channel_pollfish invokeMethod:@"pollfishSurveyCompleted" arguments:[NSString stringWithFormat:@"%s",surveyInfo]];
}

+ (void)surveyOpened:(NSNotification *)notification
{
     [_channel_pollfish invokeMethod:@"pollfishSurveyOpened" arguments:nil];
}

+ (void)surveyClosed:(NSNotification *)notification
{
    [_channel_pollfish invokeMethod:@"pollfishSurveyClosed" arguments:nil];
}

+ (void)surveyReceived:(NSNotification *)notification
{

    if([notification userInfo]!=nil){
    
        int surveyCPA = [[[notification userInfo] valueForKey:@"survey_cpa"] intValue];
        int surveyIR = [[[notification userInfo] valueForKey:@"survey_ir"] intValue];
        int surveyLOI = [[[notification userInfo] valueForKey:@"survey_loi"] intValue];

        NSString *surveyClass =(NSString *) [[notification userInfo] valueForKey:@"survey_class"];

        NSString *rewardName =(NSString *) [[notification userInfo] valueForKey:@"reward_name"];
        int rewardValue = [[[notification userInfo] valueForKey:@"reward_value"] intValue];
    
        const char *surveyInfo = [[NSString stringWithFormat:@"%d,%d,%d,%@,%@,%d",surveyCPA, surveyIR, surveyLOI, surveyClass, rewardName, rewardValue] UTF8String];

        [_channel_pollfish invokeMethod:@"pollfishSurveyReceived" arguments:[NSString stringWithFormat:@"%s",surveyInfo]];

    }else{
       
        [_channel_pollfish invokeMethod:@"pollfishSurveyReceived" arguments:@""];
    }
}

+ (void)userNotEligible:(NSNotification *)notification
{
    [_channel_pollfish invokeMethod:@"pollfishUserNotEligible" arguments:nil];
}

+ (void)userRejectedSurvey:(NSNotification *)notification
{
    [_channel_pollfish invokeMethod:@"pollfishUserRejectedSurvey" arguments:nil];
}

+ (void)surveyNotAvailable:(NSNotification *)notification
{
    [_channel_pollfish invokeMethod:@"pollfishSurveyNotAvailable" arguments:nil];
}


@end
