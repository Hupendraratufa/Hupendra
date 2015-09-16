//
//  HasSessionContextRequest.h
//  ServerApi
//
//  Created by Vladislav on 5/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"

@class HasSessionContextRequest;

@protocol HasSessionContextRequestDelegate<NSObject>

-(void)hasSessionContextRequestDone:(HasSessionContextRequest*)request;
-(void)hasSessionContextRequestFailed:(HasSessionContextRequest*)request;

@end

/*
 has session context
 
 requirements:
	session should be setup
 return:
	- language name
*/
@interface HasSessionContextRequest : BaseRequest
{
	id<HasSessionContextRequestDelegate> _delegate;
	BOOL _bSuccess;
}

-(id)initWithDelegate:(id<HasSessionContextRequestDelegate>)delegate;
-(void)send;

@property(nonatomic, readonly) BOOL isSuccess;

@end
