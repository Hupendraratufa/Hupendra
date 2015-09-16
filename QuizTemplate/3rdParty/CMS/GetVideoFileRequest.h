//
//  GetVideoFileRequest.h
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetFileRequest.h"

@class GetVideoFileRequest;

@protocol GetVideoFileRequestDelegate<NSObject>

-(void)getVideoFileRequestDone:(GetVideoFileRequest*)request;
-(void)getVideoFileRequestFailed:(GetVideoFileRequest*)request;

@optional
-(void)getVideoFileRequestProgress:(float)progress;

@end

/*
 download video file by url
 
 requirements: 
	user should be already logged in
	session should be setup 
*/
@interface GetVideoFileRequest : GetFileRequest
{
	id<GetVideoFileRequestDelegate> _delegate;	
}

-(id)initWithDelegate:(id<GetVideoFileRequestDelegate>)delegate
			  videoId:(NSUInteger)videoId downloadFilePath:(NSString*)downloadFilePath;

@end
