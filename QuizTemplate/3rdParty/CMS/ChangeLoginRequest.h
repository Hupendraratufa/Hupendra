//
//  ChangeLoginRequest.h
//  ServerApi
//
//  Created by Vladislav on 7/12/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"

@class ChangeLoginRequest;

@protocol ChangeLoginRequestDelegate<NSObject>

-(void)changeLoginRequestDone:(ChangeLoginRequest*)request;
-(void)changeLoginRequestFailed:(ChangeLoginRequest*)request;

@end

/*
 change login: changes existing login and password with the new one
 
 requirements: 
 user should be logged in
 session should be setup
 applicationId should be valid
 params:
 login - new login should be unique
 password - should not be blank
 */
@interface ChangeLoginRequest : BaseRequest
{
	id<ChangeLoginRequestDelegate> _delegate;

}

-(id)initWithDelegate:(id<ChangeLoginRequestDelegate>)delegate
			 newLogin:(NSString*)newLogin newPassword:(NSString*)newPassword
		applicationId:(NSUInteger)applicationId;
-(void)send;


@end