//
//  LoginRequest.m
//  ServerApi
//
//  Created by Vladislav on 2/15/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "LoginRequest.h"
#import "GeneralCMS.h"

@implementation LoginRequest

@synthesize identifier = _identifier;

-(id)initWithDelegate:(id<LoginRequestDelegate>)delegate login:(NSString*)login password:(NSString*)password appId:(NSUInteger)appId
{
	if((self = [super init]) != nil)
	{
        NSLog(@"Login with UserName - %@ password - %@", login, password);
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"login"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:login forKey:@"login"];
		[(ASIFormDataRequest*)_request setPostValue:password forKey:@"password"];
		[(ASIFormDataRequest*)_request setPostValue:[NSNumber numberWithInteger:appId] forKey:@"application_id"];
		_request.delegate = self;
	}
	return self;
}

-(void)dealloc
{
	[_identifier release];
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
		[_delegate loginRequestFailed:self];
	}
	else
	{
		_identifier = [[dict objectForKey:@"session"] retain];
		[_delegate loginRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed: %@", __FUNCTION__, [request.error localizedDescription]];
	[request autorelease];
	[_delegate loginRequestFailed:self];
}

@end
