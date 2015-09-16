//
//  GetTextsRequest.h
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetFileRequest.h"
#import "BaseRequest.h"

@interface GetTextsRequestItem : NSObject
{
	NSString* _text;
	NSUInteger _id;
}

@property(nonatomic, readonly) NSString* text;
@property(nonatomic, readonly) NSUInteger Id;

+(GetTextsRequestItem*)itemWithId:(NSUInteger)Id text:(NSString*)text;

@end


@class GetTextsRequest;

@protocol GetTextsRequestDelegate<NSObject>

-(void)getTextsRequestDone:(GetTextsRequest*)request;
-(void)getTextsRequestFailed:(GetTextsRequest*)request;

@end

/*
 get texts by the identifiers
 
 requirements: 
	user should be already logged in
 params:
	array of NSNumbers where the NSNumber contains the identifier
	session should be setup 
*/
@interface GetTextsRequest : BaseRequest
{
	id<GetTextsRequestDelegate> _delegate;
	NSMutableArray* _results;
}

@property(nonatomic, readonly) NSArray* results;

-(id)initWithDelegate:(id<GetTextsRequestDelegate>)delegate ids:(NSArray*)ids;
-(void)send;

@end
