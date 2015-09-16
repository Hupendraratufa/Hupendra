//
//  GenerateLoginRequest.m
//  ServerApi
//
//  Created by Vladislav on 7/12/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GenerateLoginRequest.h"
#import "GeneralCMS.h"

@implementation GenerateLoginRequest

@synthesize login = _login;
@synthesize password = _password;

-(id)initWithDelegate:(id<GenerateLoginRequestDelegate>)delegate applicationId:(NSUInteger)applicationId
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"generate_login"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[NSNumber numberWithInt:applicationId] forKey:@"application_id"];
		_request.delegate = self;
	}
	return self;	
}

-(void)dealloc
{
	[_login release];
	[_password release];
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
		[_delegate generateLoginRequestFailed:self];
	}
	else
	{
		_login = [dict objectForKey:@"login"];
		_password = [dict objectForKey:@"password"];
		[_delegate generateLoginRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate generateLoginRequestFailed:self];
}

@end