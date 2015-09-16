//
//  Session.h
//  ServerApi
//
//  Created by Vladislav on 2/23/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "GeneralCMS.h"
#import "LoginRequest.h"
#import "SetSessionContextRequest.h"
#import "GetVideoFileRequest.h"
#import "GetImageFileRequest.h"
#import "GetSoundFileRequest.h"
#import "GetTextsRequest.h"
#import "GetBannersRequest.h"
#import "GetLanguagesRequest.h"
#import "RegisterRequest.h"
#import "GetProfileRequest.h"
#import "UpdateProfileRequest.h"
#import "ResourceLayerTypes.h"
#import "UpdateRatingRequest.h"
#import "GetRatingRequest.h"
#import "GetRatingExRequest.h"
#import "GetProfilesCountRequest.h"
#import "RegisterDeviceRequest.h"
#import "GenerateLoginRequest.h"
#import "ChangeLoginRequest.h"
#import "HasSessionContextRequest.h"


@class Reachability;

typedef void (^GeneralCMSBLock)(BOOL success);

@interface GeneralCMS : NSObject<LoginRequestDelegate, SetSessionContextRequestDelegate, RegisterDeviceRequestDelegate,
HasSessionContextRequestDelegate>
{
	Reachability* _reachability;
	
	BOOL _isCancelled;
	NSInteger _timeout;
	
	RegisterDeviceRequest* _registerDeviceRequest;
	NSString* _deviceToken;
	
	GeneralCMSBLock _onLogin;
	GeneralCMSBLock _onSession;
	HasSessionContextRequest* _hasSessionRequest;
	LoginRequest* _loginRequest;
	SetSessionContextRequest* _setSessionCtxRequest;

	NSString* _username;
	NSString* _password;
	NSInteger _languageId;
	
	NSInteger _appId;
	NSString* _identifier;
	NSString* _serverURL;
	BOOL _bNeedRegisterPushNotification;
	BOOL _bDebugEnabled;
    
}

+(GeneralCMS*)sharedInstance;
-(void)autorize;
-(void)autorizeWithSeccess:(void (^)(void))comlectionBlock;
-(void)cancelAutorize;
-(void)refreshSession;
-(void)setDeviceToken:(NSData*)token;

@property(nonatomic, readonly) NSString* identifier;
@property(nonatomic, readonly) NSString* serverURL;
@property(nonatomic, readonly) BOOL hasInternet;

@property(nonatomic, readonly) NSString* username;
@property(nonatomic, readonly) NSString* password;
@property(nonatomic) NSInteger languageId;

@property(nonatomic, copy) GeneralCMSBLock onLogin;
@property(nonatomic, copy) GeneralCMSBLock onSession;
@property(nonatomic, copy) void (^autorizeCompleted)();
@end

@interface GeneralCMS(Private)

-(void)setIdentifier:(NSString*)identifier;
-(void)setUsername:(NSString*)username;
-(void)setPassword:(NSString*)password;
-(NSString*)makeURL:(NSString*)appendUrl;
-(void)enableDebug:(BOOL)enabled;
-(void)trace:(NSString*)message, ...;

@end