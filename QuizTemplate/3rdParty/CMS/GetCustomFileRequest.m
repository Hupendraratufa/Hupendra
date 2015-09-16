//
//  GetCustomFileRequest.m
//
//  Created by YS on 11/12/12.
//  Copyright (c) 2012 Vladislav. All rights reserved.
//

#import "GetCustomFileRequest.h"

@implementation GetCustomFileRequest

-(id)initWithDelegate:(id<GetCustomFileRequestDelegate>)delegate url:(NSString*)url downloadFilePath:(NSString*)downloadFilePath
{
	if((self = [super initWithCall:url downloadFilePath:downloadFilePath]) != nil)
	{
		_delegate = delegate;
	}
	return self;
}

-(void)onDone
{
	[_delegate getCustomFileRequestDone:self];
}

-(void)onFailed
{
	[_delegate getCustomFileRequestFailed:self];
}

-(void)onProgress:(float)progress
{
	if([_delegate respondsToSelector:@selector(getCustomFileRequestProgress:)])
		[_delegate getCustomFileRequestProgress:progress];
}

@end
