//
//  ChangeLoginRequest.m
//  ServerApi
//
//  Created by Vladislav on 7/12/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "ChangeLoginRequest.h"
#import "GeneralCMS.h"

@implementation ChangeLoginRequest


-(id)initWithDelegate:(id<ChangeLoginRequestDelegate>)delegate
			 newLogin:(NSString*)newLogin newPassword:(NSString*)newPassword
		applicationId:(NSUInteger)applicationId
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"change_login"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
		[(ASIFormDataRequest*)_request setPostValue:newLogin forKey:@"login"];
		[(ASIFormDataRequest*)_request setPostValue:newPassword forKey:@"password"];
		[(ASIFormDataRequest*)_request setPostValue:[NSNumber numberWithInt:applicationId] forKey:@"application_id"];				
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
		[_delegate changeLoginRequestFailed:self];
	else
    {
		[_delegate changeLoginRequestDone:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate changeLoginRequestFailed:self];
}

@end