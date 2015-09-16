//
//  HasSessionContextRequest.m
//  ServerApi
//
//  Created by Vladislav on 5/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "HasSessionContextRequest.h"
#import "GeneralCMS.h"

@implementation HasSessionContextRequest

@synthesize isSuccess = _bSuccess;

-(id)initWithDelegate:(id<HasSessionContextRequestDelegate>)delegate
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"has_session_context"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
				
		_request.delegate = self;
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

-(void)send
{
	[_request startAsynchronous];
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"response:\n%@\n", request.responseString];
	[request autorelease];
	
	SBJsonParser* parser = [[SBJsonParser new] autorelease];
	NSDictionary* dict = [parser objectWithString:request.responseString];
	if([dict isKindOfClass:[NSDictionary class]])
	{
		_bSuccess = [self parseForErrors:dict];
		[_delegate hasSessionContextRequestDone:self];
	}
	else
	{
		[_delegate hasSessionContextRequestFailed:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate hasSessionContextRequestFailed:self];
}

@end