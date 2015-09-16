//
//  LoginManager.m
//  Womens Workouts
//
//  Created by Vladislav on 12/20/12.
//  Copyright (c) 2012 Vladislav. All rights reserved.
//

#import "LoginManager.h"
#import "Model.h"
#import "GeneralCMS.h"
#import "AppSettings.h"
#import "AdBannerManager.h"

@implementation LoginManager

LoginManager* loginManagerSharedInstance = nil;
@synthesize loginParams = _loginParams;


+(LoginManager*)sharedInstance
{
//    return nil;
    
    if (!loginManagerSharedInstance)
        loginManagerSharedInstance = [LoginManager new];
    
    return loginManagerSharedInstance;
}

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)dealloc
{
    [_loginParams release];
    [super dealloc];
}

-(void)appEnterForeground
{
    if ([self isRegistered])
        [self autorize];
    else
        [self generateLogin];
}

-(void)appLaunched
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] || ![self userRequestLogin] || ![self userRequestPassword] || ![self isRegistered])
    {
        [self setUserRequestLogin:@"login"];
        [self setUserRequestPassword:@"password"];
        
        [self generateLogin];
    }
    else
    {
        [self autorize];
    }
}

-(void)generateLogin
{
    _generateLoginRequest = [[GenerateLoginRequest alloc] initWithDelegate:self applicationId:AppEmperorServerID ];
    [_generateLoginRequest send];
}

-(void)autorize
{
    NSLog(@"autorize!!!");
    [[GeneralCMS sharedInstance] autorizeWithSeccess:^{
        [[AdBannerManager sharedInstanse] appDidEnterForeground];
        [self sendTextRequestForAlert];
        
        [[Model instance] prepareBannerAds];
    }];
}

-(void)sendTextRequestForAlert
{
    _getTextRequest = [[GetTextsRequest alloc] initWithDelegate:self ids:[NSArray arrayWithObject:[NSNumber numberWithInteger:AppEmeprorAlertID]]];
    [_getTextRequest send];
}


-(BOOL)isRegistered
{
    if (![self userRequestLogin])
        return NO;
    
    return ![[self userRequestLogin] isEqualToString:@"login"];
}

-(void)setUserRequestLogin:(NSString *)userRequestLogin
{
    [AppSettings  setUserLogin:userRequestLogin];
}

-(void)setUserRequestPassword:(NSString *)userRequestPassword
{
    [AppSettings  setUserPassword:userRequestPassword];
}

-(NSString*)userRequestPassword
{
    return [AppSettings  userPassword];
}

-(NSString*)userRequestLogin
{
    if ([[AppSettings userLogin] isEqualToString:@"login"])
        return nil;
    
    return [AppSettings  userLogin];
}

-(NSNumber*)languageId
{
    NSNumber *Id = [NSNumber numberWithInt:22];
    
    if ([[AppSettings  currentLanguage] isEqualToString:@"en_US"])
        Id = [NSNumber numberWithInt:22];
    else if ([[AppSettings  currentLanguage] isEqualToString:@"ru_RU"])
        Id = [NSNumber numberWithInt:23];
    
    return Id;
}

-(NSDictionary*)loginParams
{
    NSArray *keys = [NSArray arrayWithObjects:@"enable_debug", @"enable_production_environment",@"language_id", @"username",@"password",@"app_id",@"push_notifications_enabled", nil];
    
    NSString *login = [self userRequestLogin];
    if (!login)
        login = @"login";
    NSString *pass = [self userRequestPassword];
    if (!pass)
        pass = @"password";
    
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES], [self languageId], login, pass, [NSNumber numberWithInt:AppEmperorServerID], [NSNumber numberWithBool:YES], nil];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    _loginParams = dic;
    
    keys = nil;
    objects = nil;
    dic = nil;
    
    return _loginParams;
}

#pragma mark GenerateLoginRequestDelegate
-(void)generateLoginRequestDone:(GenerateLoginRequest *)request
{
    [_generateLoginRequest autorelease];
    _generateLoginRequest = nil;
    
    
    _registerRequest = [[RegisterRequest alloc] initWithDelegate:self login:request.login
                                                        password:request.password
                                                   applicationId:AppEmperorServerID];
    [_registerRequest send];
    
    
}

-(void)generateLoginRequestFailed:(GenerateLoginRequest *)request
{
    [self setUserRequestLogin:@"login"];
    [self setUserRequestPassword:@"password"];
    
    [_generateLoginRequest autorelease];
    _generateLoginRequest = nil;
}

#pragma mark RegisterRequestDelegate
-(void)registerRequestDone:(RegisterRequest *)request
{
    [_registerRequest autorelease];
    _registerRequest = nil;
    
    [self setUserRequestLogin:request.mylogin];
    [self setUserRequestPassword:request.mypassword];
    
    [[GeneralCMS sharedInstance] setUsername:request.mylogin];
    [[GeneralCMS sharedInstance] setPassword:request.mypassword];
    
    [self autorize];
    
}

-(void)registerRequestFailed:(RegisterRequest *)request
{
    [_registerRequest autorelease];
    _registerRequest = nil;
    
    [self setUserRequestLogin:@"login"];
    [self setUserRequestPassword:@"password"];
    
    [self generateLogin];
    
    
}

#pragma mark GetServerTimeRequestDelegate
-(void)getServerTimeRequestFailed:(GetServerTimeRequest *)request
{
    [_getServerTimeRequest autorelease];
    _getServerTimeRequest = nil;

}

-(void)getServerTimeRequestDone:(GetServerTimeRequest *)request
{
    [_getServerTimeRequest autorelease];
    _getServerTimeRequest = nil;
    

}

#pragma mark GetTextRequestDelegate
-(void)getTextsRequestDone:(GetTextsRequest *)request
{
    NSString *str = [NSString string];
    
    for(GetTextsRequestItem* item in request.results)
        str = [NSString stringWithFormat:@"%@",item.text];
    
    if ([str isEqualToString:@"YES"])
        [[Model instance] setServerRateAlert:YES];
    else
        [[Model instance] setServerRateAlert:NO];
 
    [_getTextRequest autorelease];
    _getTextRequest = nil;
    
}

-(void)getTextsRequestFailed:(GetTextsRequest *)request
{

    [_getTextRequest autorelease];
    _getTextRequest = nil;
}
@end
