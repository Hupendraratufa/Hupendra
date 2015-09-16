//
//  SetSessionContextRequest.m
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "SetSessionContextRequest.h"
#import "GeneralCMS.h"

@implementation SetSessionContextRequest

-(id)initWithDelegate:(id<SetSessionContextRequestDelegate>)delegate params:(NSDictionary*)params
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"set_session_context"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
		
		SBJsonWriter* writer = [[SBJsonWriter new] autorelease];
		NSString* jsonStr = [writer stringWithObject:params];
		NSLog(@"%@", jsonStr);
		[(ASIFormDataRequest*)_request setPostValue:jsonStr forKey:@"params"];
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
	if(![dict isKindOfClass:[NSDictionary class]] || ![self parseForErrors:dict])
	{
		[_delegate setSessionContextRequestFailed:self];
	}
	else
	{
		[_delegate setSessionContextRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate setSessionContextRequestFailed:self];
}

@end
