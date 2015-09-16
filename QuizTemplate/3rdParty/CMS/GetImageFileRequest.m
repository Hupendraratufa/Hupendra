//
//  GetImageRequest.m
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetImageFileRequest.h"
#import "GeneralCMS.h"

@implementation GetImageFileRequest

-(id)initWithDelegate:(id<GetImageFileRequestDelegate>)delegate
			  imageId:(NSUInteger)imageId downloadFilePath:(NSString*)downloadFilePath
{
	NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_image"];
	NSMutableString* call = [NSMutableString stringWithString:apiUrl];
	[call appendFormat:@"/session/%@", [GeneralCMS sharedInstance].identifier];
	[call appendFormat:@"/image/%d", imageId];
	if((self = [super initWithCall:call downloadFilePath:downloadFilePath]) != nil)
	{
		_delegate = delegate;
	}
	return self;
}

-(void)onDone
{
	[_delegate getImageFileRequestDone:self];
}

-(void)onFailed
{
	[_delegate getImageFileRequestFailed:self];	
}

-(void)onProgress:(float)progress
{
	if([_delegate respondsToSelector:@selector(getImageFileRequestProgress:)])
		[_delegate getImageFileRequestProgress:progress];
}

@end
