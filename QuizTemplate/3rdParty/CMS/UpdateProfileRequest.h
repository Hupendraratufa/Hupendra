//
//  UpdateProfileRequest.h
//  ServerApi
//
//  Created by Vladislav on 6/19/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"

@class UpdateProfileRequest;

@protocol UpdateProfileRequestDelegate<NSObject>

-(void)updateProfileRequestDone:(UpdateProfileRequest*)request;
-(void)updateProfileRequestFailed:(UpdateProfileRequest*)request;

@end

/*
 update profile for the logged user
 
 requirements: 
	user should be logged in
	session should be setup
 params:
	dictionary which contains the pairs of key-value, where the key = "field name" and value = "value for field"
 */
@interface UpdateProfileRequest : BaseRequest
{
	id<UpdateProfileRequestDelegate> _delegate;

}

-(id)initWithDelegate:(id<UpdateProfileRequestDelegate>)delegate fieldInfo:(NSDictionary*)fieldInfo, ...;
-(void)send;



@end
