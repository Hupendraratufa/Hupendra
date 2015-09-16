//
//  RegisterDevice.h
//  ServerApi
//
//  Created by Vladislav on 7/12/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"

@class RegisterDeviceRequest;

@protocol RegisterDeviceRequestDelegate<NSObject>

-(void)registerDeviceRequestDone:(RegisterDeviceRequest*)request;
-(void)registerDeviceRequestFailed:(RegisterDeviceRequest*)request;

@end

/*
 login already registered user
 
 requirements:
 login should be exist
 password should be correct
 applicationId should be exist
 */
@interface RegisterDeviceRequest : BaseRequest
{
	id<RegisterDeviceRequestDelegate> _delegate;
}

-(id)initWithDelegate:(id<RegisterDeviceRequestDelegate>)delegate deviceToken:(NSString*)deviceToken;
-(void)send;

@end
