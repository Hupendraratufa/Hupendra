//
//  UpdateRatingRequest.h
//  ServerApi
//
//  Created by Vladislav on 6/19/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"
#import "BaseRequest.h"
#import "ResourceLayerTypes.h"

@class UpdateRatingRequest;

@protocol UpdateRatingRequestDelegate<NSObject>

-(void)updateRatingRequestDone:(UpdateRatingRequest*)request;
-(void)updateRatingRequestFailed:(UpdateRatingRequest*)request;

@end

/*
 update rating for the logged user for the specified content type and content identifier
 
 requirements: 
	user should be logged in
	session should be setup
 params:
	content type - image, video or sound
	content id - content identifier
*/
@interface UpdateRatingRequest : BaseRequest
{
	id<UpdateRatingRequestDelegate> _delegate;
}

-(id)initWithDelegate:(id<UpdateRatingRequestDelegate>)delegate contentType:(ContentType)contentType contentId:(NSUInteger)contentId 
			   rating:(NSUInteger)rating needRewrite:(BOOL)needRewrite;
-(void)send;

@end
