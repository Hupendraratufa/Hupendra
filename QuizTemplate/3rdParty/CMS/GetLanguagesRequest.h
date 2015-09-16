//
//  GetLanguagesRequest.h
//  ServerApi
//
//  Created by Vladislav on 5/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"

@interface GetLanguagesRequestItem : NSObject
{
	NSString* _name;
	NSUInteger _id;
}

@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSUInteger Id;

+(GetLanguagesRequestItem*)itemWithId:(NSUInteger)Id name:(NSString*)name;

@end


@class GetLanguagesRequest;

@protocol GetLanguagesRequestDelegate<NSObject>

-(void)getLanguagesRequestDone:(GetLanguagesRequest*)request;
-(void)getLanguagesRequestFailed:(GetLanguagesRequest*)request;

@end

/*
 get available languages
 
 requirements:
	user should be already logged in
	session should be setup 
 return:
	array of dictionaries where the dictionary contains: 
		- language id
		- language name
*/
@interface GetLanguagesRequest : BaseRequest
{
	id<GetLanguagesRequestDelegate> _delegate;
	NSMutableArray* _results;
}

@property(nonatomic, readonly) NSArray* results;

-(id)initWithDelegate:(id<GetLanguagesRequestDelegate>)delegate;
-(void)send;

@end
