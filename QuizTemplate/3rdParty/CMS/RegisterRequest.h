//
//  RegisterRequest.h
//  ServerApi
//
//  Created by Vladislav on 6/19/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"

@class RegisterRequest;

@protocol RegisterRequestDelegate<NSObject>

-(void)registerRequestDone:(RegisterRequest*)request;
-(void)registerRequestFailed:(RegisterRequest*)request;

@end

/*
 register the new user
 
 requirements: 
	login should be unique
	application identifier should be exist
	session should be setup 
 params:
	array of NSNumbers where the NSNumber contains the identifier
*/
@interface RegisterRequest : BaseRequest
{
	id<RegisterRequestDelegate> _delegate;
    NSString *_mylogin;
    NSString *_mypassword;
    
}
@property (nonatomic, readonly) NSString *mylogin;
@property (nonatomic, readonly) NSString *mypassword;

-(id)initWithDelegate:(id<RegisterRequestDelegate>)delegate login:(NSString*)login password:(NSString*)password applicationId:(NSUInteger)applicationId;
-(void)send;

@end
