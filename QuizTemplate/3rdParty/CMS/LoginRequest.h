//
//  LoginRequest.h
//  ServerApi
//
//  Created by Vladislav on 2/15/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"

@class LoginRequest;

@protocol LoginRequestDelegate<NSObject>

-(void)loginRequestDone:(LoginRequest*)request;
-(void)loginRequestFailed:(LoginRequest*)request;

@end

/*
login already registered user
 
requirements:
	login should be exist
	password should be correct
	applicationId should be exist
*/
@interface LoginRequest : BaseRequest
{
	NSString* _identifier;
	id<LoginRequestDelegate> _delegate;
}

@property(nonatomic, readonly) NSString* identifier;

-(id)initWithDelegate:(id<LoginRequestDelegate>)delegate login:(NSString*)login password:(NSString*)password appId:(NSUInteger)appId;
-(void)send;

@end
