//
//  Session.m
//  ServerApi
//
//  Created by Vladislav on 2/23/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GeneralCMS.h"
#import "Reachability.h"
#import "LoginManager.h"
#import "Model.h"
#import "AppSettings.h"

@implementation GeneralCMS

#define DEV_ENVIRONMENT @"http://dev-app.emperorlab.com/app_dev.php/api"
#define PROD_ENVIRONMENT @"http://app.emperorlab.com/app_dev.php/api"
#define DEFAULT_TIMEOUT 1
#define MAX_TIMEOUT (64)

GeneralCMS* generalCMSSharedInstance = nil;

@synthesize identifier = _identifier;
@synthesize serverURL = _serverURL;
@synthesize username = _username;
@synthesize password = _password;

@synthesize onLogin = _onLogin;
@synthesize onSession = _onSession;

-(BOOL)hasInternet
{
	return [_reachability isReachable];
}

-(void)updateTimeout
{
	if(_timeout < MAX_TIMEOUT)
		_timeout *= 2;
    else
        [self cancelAutorize];
    
	[self trace:@"timeout: %d", _timeout];
}

-(void)tryRepeatRequest:(SEL)selector
{
	if(_isCancelled)
	{
		_isCancelled = NO;
		return;
	}
	[self updateTimeout];
	[self performSelector:selector withObject:nil afterDelay:_timeout];
}

#pragma mark SetSessionContextDelegate
-(void)setSessionContextRequestDone:(SetSessionContextRequest*)request
{
	_timeout = DEFAULT_TIMEOUT;
	[_setSessionCtxRequest autorelease];
	_setSessionCtxRequest = nil;
	
	if(_onSession)
		_onSession(YES);
    
    if (self.autorizeCompleted)
        self.autorizeCompleted();
    self.autorizeCompleted = nil;
    

    
	if(_bNeedRegisterPushNotification)
	{
		[_registerDeviceRequest cancelRequest];
		[_registerDeviceRequest release];
		_registerDeviceRequest = [[RegisterDeviceRequest alloc] initWithDelegate:self deviceToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"]];
		[_registerDeviceRequest send];
	}
}

-(void)setSessionContextRequestFailed:(SetSessionContextRequest*)request
{
	[_setSessionCtxRequest autorelease];
	_setSessionCtxRequest = nil;
	
	if(_onSession)
		_onSession(NO);
	
	[self tryRepeatRequest:@selector(refreshSession)];
}

#pragma mark LoginRequestDelegate
-(void)loginRequestDone:(LoginRequest*)request
{
	[self setIdentifier:request.identifier];
	_timeout = DEFAULT_TIMEOUT;
	[_loginRequest autorelease];
	_loginRequest = nil;
	
	if(_onLogin)
		_onLogin(YES);
	
	[self refreshSession];
}

-(void)loginRequestFailed:(LoginRequest*)request
{
	[_loginRequest autorelease];
	_loginRequest = nil;
	
	if(_onLogin)
		_onLogin(NO);
	
	[self tryRepeatRequest:@selector(autorize)];
}

#pragma mark RegisterDeviceRequestDelegate
-(void)registerDeviceRequestDone:(RegisterDeviceRequest*)request
{
	[self trace:@"%s", __FUNCTION__];
	[_registerDeviceRequest autorelease];
	_registerDeviceRequest = nil;
}

-(void)registerDeviceRequestFailed:(RegisterDeviceRequest*)request
{
	[self trace:@"%s", __FUNCTION__];
	[_registerDeviceRequest autorelease];
	_registerDeviceRequest = nil;
}

#pragma mark HasSessionRequestDelegate
-(void)hasSessionContextRequestDone:(HasSessionContextRequest*)request
{
	_timeout = DEFAULT_TIMEOUT;
	[_hasSessionRequest autorelease];
	_hasSessionRequest = nil;
	
	if(request.isSuccess)
		[self refreshSession];
	else
	{
		[self setIdentifier:nil];
		[self login];
	}
}

-(void)hasSessionContextRequestFailed:(HasSessionContextRequest*)request
{
	[_hasSessionRequest autorelease];
	_hasSessionRequest = nil;
	[self tryRepeatRequest:@selector(autorize)];
}

-(void)login
{
	_loginRequest = [[LoginRequest alloc] initWithDelegate:self login:_username password:_password appId:_appId];
	[_loginRequest send];
}

-(void)autorize
{
	_isCancelled = NO;
	NSString* session = [[NSUserDefaults standardUserDefaults] stringForKey:@"cms_session"];
	if([session length])
	{
        NSLog(@"Has session");
		[self setIdentifier:session];
        [_hasSessionRequest cancelRequest];
        _hasSessionRequest = nil;
		_hasSessionRequest = [[HasSessionContextRequest alloc] initWithDelegate:self];
		[_hasSessionRequest send];
	}
	else
	{
		[self login];
	}
}

-(void)autorizeWithSeccess:(void (^)(void))comlectionBlock
{
    self.autorizeCompleted = comlectionBlock;
    [self autorize];
}

-(void)cancelAutorize
{
	_isCancelled = YES;
	_timeout = DEFAULT_TIMEOUT;
    
    if ([self hasInternet] && _isCancelled)
    {
        [AppSettings  setUserLogin:@"login"];
        [AppSettings  setUserPassword:@"password"];
    }
    
	if(_loginRequest)
	{
		[_loginRequest release];
		_loginRequest = nil;
	}
	else if(_setSessionCtxRequest)
	{
		[_setSessionCtxRequest release];
		_setSessionCtxRequest = nil;
	}
	else if(_hasSessionRequest)
	{
		[_hasSessionRequest release];
		_hasSessionRequest = nil;
	}
	else if(_registerDeviceRequest)
	{
		[_registerDeviceRequest release];
		_registerDeviceRequest = nil;
	}
}

-(void)refreshSession
{
	_isCancelled = NO;
	NSMutableDictionary* params = [NSMutableDictionary dictionary];
	[params setObject:[NSNumber numberWithInt:_languageId] forKey:@"language"];
	NSString* device = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
	? @"iPad" : @"iPhone";
	[params setObject:device forKey:@"device"];
	_setSessionCtxRequest = [[SetSessionContextRequest alloc] initWithDelegate:self params:params];
	[_setSessionCtxRequest send];
}

-(void)setDeviceToken:(NSData*)token
{
	NSMutableString *tokenString = [NSMutableString stringWithString:
                                    [[token description] uppercaseString]];
    [tokenString replaceOccurrencesOfString:@"<"
                                 withString:@""
                                    options:0
                                      range:NSMakeRange(0, tokenString.length)];
    [tokenString replaceOccurrencesOfString:@">"
                                 withString:@""
                                    options:0
                                      range:NSMakeRange(0, tokenString.length)];
    [tokenString replaceOccurrencesOfString:@" "
                                 withString:@""
                                    options:0
                                      range:NSMakeRange(0, tokenString.length)];
    
	[_deviceToken release];
	_deviceToken = [tokenString retain];
}

-(id)init
{
	if(self = [super init])
	{
		_reachability = [[Reachability reachabilityForInternetConnection] retain];
		
		_timeout = DEFAULT_TIMEOUT;
		_onLogin = nil;
		_onSession = nil;
        self.autorizeCompleted = nil;
		
        //		NSDictionary* params = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CMS" ofType:@"plist"]];
		
        NSDictionary* params = [[LoginManager sharedInstance] loginParams];
		if(!params)
			NSLog(@"Login Params is empty");
		
		[self enableDebug:[[params objectForKey:@"enable_debug"] boolValue]];
		[self setServerURL:[[params objectForKey:@"enable_production_environment"] boolValue] ? PROD_ENVIRONMENT : DEV_ENVIRONMENT];
		
		if([params objectForKey:@"language_id"])
            self.languageId = [[params objectForKey:@"language_id"] intValue];
        
        [self setUsername:[params objectForKey:@"username"]];
        [self setPassword:[params objectForKey:@"password"]];
		
		_appId = [[params objectForKey:@"app_id"] intValue];
		_bNeedRegisterPushNotification = [[params objectForKey:@"push_notifications_enabled"] boolValue];
	}
	return self;
}

+(GeneralCMS*)sharedInstance
{
	if(!generalCMSSharedInstance)
		generalCMSSharedInstance = [GeneralCMS new];
	
	return generalCMSSharedInstance;
}

-(void)setServerURL:(NSString*)url
{
	[url retain];
	[_serverURL release];
	_serverURL = url;
}
@end


@implementation GeneralCMS(Private)

-(void)setUsername:(NSString *)username
{
    _username = [username retain];
}

-(void)setPassword:(NSString *)password
{
    _password = [password retain];
}

-(void)setIdentifier:(NSString*)identifier
{
	[identifier retain];
	[_identifier release];
	_identifier = identifier;
	[[NSUserDefaults standardUserDefaults] setObject:_identifier forKey:@"cms_session"];
}

-(NSString*)makeURL:(NSString*)appendUrl
{
	return [NSString stringWithFormat:@"%@/%@", _serverURL, appendUrl];
}

-(void)enableDebug:(BOOL)enabled
{
	_bDebugEnabled = enabled;
}

-(void)trace:(NSString*)message, ...
{
	if(!_bDebugEnabled)
		return;
	
	va_list params;
	va_start(params, message);
	NSString* info = [[[NSString alloc] initWithFormat:message arguments:params] autorelease];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GeneralCMS" object:info];
}

@end