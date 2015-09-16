//
//  GeCustomFileRequest.h
//
//  Created by YS on 11/12/12.
//  Copyright (c) 2012 Vladislav. All rights reserved.
//

#import "GetFileRequest.h"


@class GetCustomFileRequest;

@protocol GetCustomFileRequestDelegate<NSObject>

-(void)getCustomFileRequestDone:(GetCustomFileRequest*)request;
-(void)getCustomFileRequestFailed:(GetCustomFileRequest*)request;

@optional
-(void)getCustomFileRequestProgress:(float)progress;

@end

/*
 download video file by url
 
 requirements:
 user should be already logged in
 session should be setup
 */
@interface GetCustomFileRequest : GetFileRequest
{
	id<GetCustomFileRequestDelegate> _delegate;
}

-(id)initWithDelegate:(id<GetCustomFileRequestDelegate>)delegate url:(NSString*)url downloadFilePath:(NSString*)downloadFilePath;

@end