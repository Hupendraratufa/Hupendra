//
//  GetServerTimeRequest.m
//  Anti-Fat
//
//  Created by Vladislav on 2/11/13.
//  Copyright (c) 2013 EmperorLab. All rights reserved.
//

#import "GetServerTimeRequest.h"
#import "GeneralCMS.h"
#import "GeneralUtils.h"

@implementation GetServerTimeRequest

@synthesize serverDate = _serverDate;

-(id)initWitDelegate:(id<GetServerTimeRequestDelegate>)delegate
{
    if ((self = [super init]) != nil)
    {
        _delegate = delegate;
        NSString *apiUrl = [[GeneralCMS sharedInstance] makeURL:@"time"];
        [[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
        NSURL* url = [NSURL URLWithString:apiUrl];
        _request = [[ASIFormDataRequest alloc] initWithURL:url];
		_request.timeOutSeconds = 5.f;
		//NSLog(@"ses: %@", [GeneralCMS sharedInstance].identifier);
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
		_request.delegate = self;
    }
    return self;
}

-(void)dealloc
{
//    [_serverDate release];
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
		[_delegate getServerTimeRequestFailed:self];
	else
	{
        
		_serverDate = [GeneralUtils stringToServerDate:[dict objectForKey:@"time"]];
		[_delegate getServerTimeRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate getServerTimeRequestFailed:self];
}

@end
