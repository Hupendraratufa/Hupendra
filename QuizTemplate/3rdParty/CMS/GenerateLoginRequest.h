//
//  GenerateLoginRequest.h
//  ServerApi
//
//  Created by Vladislav on 7/12/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"

@class GenerateLoginRequest;

@protocol GenerateLoginRequestDelegate<NSObject>

-(void)generateLoginRequestDone:(GenerateLoginRequest*)request;
-(void)generateLoginRequestFailed:(GenerateLoginRequest*)request;

@end

/*
 generates unique login
 
 requirements:
	applicationId should be valid
 return:
	generated unique login
	generated unique password
 */
@interface GenerateLoginRequest : BaseRequest
{
	id<GenerateLoginRequestDelegate> _delegate;
	NSString* _login;
	NSString* _password;
}

-(id)initWithDelegate:(id<GenerateLoginRequestDelegate>)delegate applicationId:(NSUInteger)applicationId;
-(void)send;

@property(nonatomic, readonly) NSString* login;
@property(nonatomic, readonly) NSString* password;

@end
