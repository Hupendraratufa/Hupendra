//
//  GetVideoFileRequest.m
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetVideoFileRequest.h"
#import "GeneralCMS.h"

@implementation GetVideoFileRequest

-(id)initWithDelegate:(id<GetVideoFileRequestDelegate>)delegate
			  videoId:(NSUInteger)videoId downloadFilePath:(NSString*)downloadFilePath
{
	NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_video"];
	NSMutableString* call = [NSMutableString stringWithString:apiUrl];
	[call appendFormat:@"/session/%@", [GeneralCMS sharedInstance].identifier];
	[call appendFormat:@"/video/%d", videoId];
	if((self = [super initWithCall:call downloadFilePath:downloadFilePath]) != nil)
	{
		_delegate = delegate;
	}
	return self;
}

-(void)onDone
{
	[_delegate getVideoFileRequestDone:self];
}

-(void)onFailed
{
	[_delegate getVideoFileRequestFailed:self];	
}

-(void)onProgress:(float)progress
{
	if([_delegate respondsToSelector:@selector(getVideoFileRequestProgress:)])
		[_delegate getVideoFileRequestProgress:progress];
}

@end
