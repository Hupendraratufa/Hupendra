//
//  LoginManager.h
//  Womens Workouts
//
//  Created by Vladislav on 12/20/12.
//  Copyright (c) 2012 Vladislav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenerateLoginRequest.h"
#import "RegisterRequest.h"
#import "GetTextsRequest.h"
#import "GetServerTimeRequest.h"



@interface LoginManager : NSObject <GenerateLoginRequestDelegate, RegisterRequestDelegate, GetTextsRequestDelegate, GetServerTimeRequestDelegate>
{
    NSDictionary *_loginParams;
    
    GenerateLoginRequest *_generateLoginRequest;
    RegisterRequest *_registerRequest;
    GetTextsRequest *_getTextRequest;
    GetServerTimeRequest *_getServerTimeRequest;
}
@property (nonatomic, retain) NSDictionary *loginParams;

+(LoginManager*)sharedInstance;
-(void)appEnterForeground;
-(void)appLaunched;
-(void)autorize;
@end
