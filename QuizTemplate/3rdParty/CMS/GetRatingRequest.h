//
//  GetRatingRequest.h
//  ServerApi
//
//  Created by Vladislav on 6/20/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"
#import "ResourceLayerTypes.h"

@class GetRatingRequest;

@protocol GetRatingRequestDelegate<NSObject>

-(void)getRatingRequestDone:(GetRatingRequest*)request;
-(void)getRatingRequestFailed:(GetRatingRequest*)request;

@end

/*
 get rating for the logged user for the specified content type and content identifier
 
 requirements: 
	user should be logged in
	session should be setup
 params:
	content type - image, video or sound
	content id - content identifier
 */
@interface GetRatingRequest : BaseRequest
{
	id<GetRatingRequestDelegate> _delegate;
	float _averageRating;
	NSUInteger _ratingsCount;
}

-(id)initWithDelegate:(id<GetRatingRequestDelegate>)delegate contentType:(ContentType)contentType contentId:(NSUInteger)contentId;
-(void)send;

@property(nonatomic, readonly) float averageRating;
@property(nonatomic, readonly) NSUInteger ratingsCount;

@end
