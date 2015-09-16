//
//  GetImageRequest.h
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetFileRequest.h"

@class GetImageFileRequest;

@protocol GetImageFileRequestDelegate<NSObject>

-(void)getImageFileRequestDone:(GetImageFileRequest*)request;
-(void)getImageFileRequestFailed:(GetImageFileRequest*)request;

@optional
-(void)getImageFileRequestProgress:(float)progress;

@end

/*
download image file by url
 
requirements:
	user should be already logged in
	session should be setup 
*/
@interface GetImageFileRequest : GetFileRequest
{
	id<GetImageFileRequestDelegate> _delegate;	
}

-(id)initWithDelegate:(id<GetImageFileRequestDelegate>)delegate
			  imageId:(NSUInteger)videoId downloadFilePath:(NSString*)downloadFilePath;

@end
