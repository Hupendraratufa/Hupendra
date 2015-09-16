//
//  GetSoundFileRequest.m
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetSoundFileRequest.h"
#import "GeneralCMS.h"

@implementation GetSoundFileRequest

-(id)initWithDelegate:(id<GetSoundFileRequestDelegate>)delegate
			  soundId:(NSUInteger)soundId downloadFilePath:(NSString*)downloadFilePath
{
	NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_audio"];
	NSMutableString* call = [NSMutableString stringWithString:apiUrl];
	[call appendFormat:@"/session/%@", [GeneralCMS sharedInstance].identifier];
	[call appendFormat:@"/audio/%d", soundId];
	if((self = [super initWithCall:call downloadFilePath:downloadFilePath]) != nil)
	{
		_delegate = delegate;
	}
	return self;
}

-(void)onDone
{
	[_delegate getSoundFileRequestDone:self];
}

-(void)onFailed
{
	[_delegate getSoundFileRequestFailed:self];	
}

-(void)onProgress:(float)progress
{
	if([_delegate respondsToSelector:@selector(getSoundFileRequestProgress:)])
		[_delegate getSoundFileRequestProgress:progress];
}

@end
