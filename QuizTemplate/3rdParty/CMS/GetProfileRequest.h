//
//  GetProfileRequest.h
//  ServerApi
//
//  Created by Vladislav on 6/19/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"

@class GetProfileRequest;

@protocol GetProfileRequestDelegate<NSObject>

-(void)getProfileRequestDone:(GetProfileRequest*)request;
-(void)getProfileRequestFailed:(GetProfileRequest*)request;

@end

@interface GetProfileRequestItem : NSObject

@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSString* value;

@end

/*
 get profile for the logged user
 
requirements: 
	user should be logged in
	session should be setup
params:
	array of NSNumbers where the NSNumber contains the identifier
*/
@interface GetProfileRequest : BaseRequest
{
	NSMutableArray* _fields;
	id<GetProfileRequestDelegate> _delegate;
}

-(id)initWithDelegate:(id<GetProfileRequestDelegate>)delegate;
-(void)send;

@property(nonatomic, readonly) NSArray* fields;

@end
