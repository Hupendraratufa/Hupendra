//
//  GetBannersRequest.h
//  ServerApi
//
//  Created by Vladislav on 2/17/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "GetCustomFileRequest.h"

@interface GetBannersRequestItem : NSObject
{
	NSUInteger _id;
	NSString* _text;
	NSString* _link;
	NSString* _imagePath;
}

@property(nonatomic, readonly) NSUInteger Id;
@property(nonatomic, readonly) NSString* text;
@property(nonatomic, readonly) NSString* link;
@property(nonatomic, readonly) NSString* imagePath;

+(GetBannersRequestItem*)itemWithId:(NSUInteger)Id text:(NSString*)text link:(NSString*)link imagePath:(NSString*)imagePath;

@end


@class GetBannersRequest;

@protocol GetBannersRequestDelegate<NSObject>

-(void)getBannersRequestDone:(GetBannersRequest*)request;
-(void)getBannersRequestFailed:(GetBannersRequest*)request;

@end

/*
 get banners by the identifiers
 
 requirements:
	user should be already logged in
 params:
	array of NSNumbers where the NSNumber contains the identifier
	session should be setup 
*/
@interface GetBannersRequest : BaseRequest<GetCustomFileRequestDelegate>
{
	id<GetBannersRequestDelegate> _delegate;
	NSMutableArray* _results;
	NSMutableArray* _imageRequests;
}

@property(nonatomic, readonly) NSArray* results;

-(id)initWithDelegate:(id<GetBannersRequestDelegate>)delegate ids:(NSArray*)ids;
-(void)send;

@end