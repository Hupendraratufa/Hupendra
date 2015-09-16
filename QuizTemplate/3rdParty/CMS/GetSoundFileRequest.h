//
//  GetSoundFileRequest.h
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetFileRequest.h"

@class GetSoundFileRequest;

@protocol GetSoundFileRequestDelegate<NSObject>

-(void)getSoundFileRequestDone:(GetSoundFileRequest*)request;
-(void)getSoundFileRequestFailed:(GetSoundFileRequest*)request;

@optional
-(void)getSoundFileRequestProgress:(float)progress;

@end


/*
download sound file by url
 
requirements: 
	user should be already logged in
	session should be setup 
*/
@interface GetSoundFileRequest : GetFileRequest
{
	id<GetSoundFileRequestDelegate> _delegate;	
}

-(id)initWithDelegate:(id<GetSoundFileRequestDelegate>)delegate
			  soundId:(NSUInteger)soundId downloadFilePath:(NSString*)downloadFilePath;

@end
