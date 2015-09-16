//
//  GetRatingExRequest.h
//  ServerApi
//
//  Created by Vladislav on 6/21/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"
#import "ResourceLayerTypes.h"

@class GetRatingExRequest;

@protocol GetRatingExRequestDelegate<NSObject>

-(void)getRatingExRequestDone:(GetRatingExRequest*)request;
-(void)getRatingExRequestFailed:(GetRatingExRequest*)request;

@end

/*
 get ratings for the logged user for the specified content type and content identifier
 
 requirements: 
	user should be logged in
	session should be setup
 params:
	content type - image, video or sound
	content id - content identifier
 returns:
	set of all ratings. for example. Mark '5' - 10 users, Mark '6' - 7 users, etc.
*/
@interface GetRatingExRequest : BaseRequest
{
	id<GetRatingExRequestDelegate> _delegate;
	NSDictionary* _results;
}

-(id)initWithDelegate:(id<GetRatingExRequestDelegate>)delegate contentType:(ContentType)contentType contentId:(NSUInteger)contentId;
-(void)send;

-(NSUInteger)usersCountForRating:(NSUInteger)rating;

@property(nonatomic, readonly) NSArray* ratings;

@end
