//
//  GetProfilesCount.h
//  ServerApi
//
//  Created by Vladislav on 6/22/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"

@class GetProfilesCountRequest;

@protocol GetProfilesCountRequestDelegate<NSObject>

-(void)getProfilesCountRequestDone:(GetProfilesCountRequest*)request;
-(void)getProfilesCountRequestFailed:(GetProfilesCountRequest*)request;

@end

/*
 get profiles count for the specified application
 
 requirements: 
	user should be logged in
	session should be setup
 params:
 returns:
	quantity of the registered profiles
 */
@interface GetProfilesCountRequest : BaseRequest
{
	id<GetProfilesCountRequestDelegate> _delegate;
	NSUInteger _count;
}

-(id)initWithDelegate:(id<GetProfilesCountRequestDelegate>)delegate;
-(void)send;

@property(nonatomic, readonly) NSUInteger count;

@end
