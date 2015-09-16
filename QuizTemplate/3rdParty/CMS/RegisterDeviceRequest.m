//
//  RegisterDevice.m
//  ServerApi
//
//  Created by Vladislav on 7/12/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "RegisterDeviceRequest.h"
#import "GeneralCMS.h"

@implementation RegisterDeviceRequest

-(id)initWithDelegate:(id<RegisterDeviceRequestDelegate>)delegate deviceToken:(NSString*)deviceToken
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"register_device"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:deviceToken forKey:@"device_token"];
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
	if(![dict isKindOfClass:[NSDictionary class]] || ![self parseForErrors:dict])
	{
		[_delegate registerDeviceRequestFailed:self];
	}
	else
	{
		[_delegate registerDeviceRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate registerDeviceRequestFailed:self];
}

@end