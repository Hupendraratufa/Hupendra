//
//  GetProfilesCount.m
//  ServerApi
//
//  Created by Vladislav on 6/22/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetProfilesCountRequest.h"
#import "GeneralCMS.h"

@implementation GetProfilesCountRequest

@synthesize count = _count;

-(id)initWithDelegate:(id<GetProfilesCountRequestDelegate>)delegate
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_profiles_count"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		_request.timeOutSeconds = 5.f;
//		NSLog(@"ses: %@", [GeneralCMS sharedInstance].identifier);
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
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
	
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"response:\n%@\n", request.responseString];
	[request autorelease];
	
	SBJsonParser* parser = [[SBJsonParser new] autorelease];	
	NSDictionary* dict = [parser objectWithString:request.responseString];
	if(![dict isKindOfClass:[NSDictionary class]] || ![self parseForErrors:dict])
		[_delegate getProfilesCountRequestFailed:self];
	else
	{
		_count = [[dict objectForKey:@"count"] intValue];
		[_delegate getProfilesCountRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate getProfilesCountRequestFailed:self];
}

@end