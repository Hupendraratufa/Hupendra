//
//  RegisterRequest.m
//  ServerApi
//
//  Created by Vladislav on 6/19/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "RegisterRequest.h"
#import "GeneralCMS.h"

@implementation RegisterRequest
@synthesize mylogin = _mylogin;
@synthesize mypassword = _mypassword;

-(id)initWithDelegate:(id<RegisterRequestDelegate>)delegate login:(NSString*)login password:(NSString*)password applicationId:(NSUInteger)applicationId
{
if((self = [super init]) != nil)
{	
	_delegate = delegate;
	NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"register"];
	[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
	NSURL* url = [NSURL URLWithString:apiUrl];
	_request = [[ASIFormDataRequest alloc] initWithURL:url];
	[(ASIFormDataRequest*)_request setPostValue:login forKey:@"login"];
	[(ASIFormDataRequest*)_request setPostValue:password forKey:@"password"];
    NSLog(@"init register request with - %@ pass - %@",login, password);
	[(ASIFormDataRequest*)_request setPostValue:[NSNumber numberWithUnsignedInt:applicationId] forKey:@"application_id"];
	_request.delegate = self;
    
    _mylogin = [login retain];
    _mypassword = [password retain];
}
return self;
}

-(void)dealloc
{
//    [_mylogin release];
//    [_mypassword release];
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
		[_delegate registerRequestFailed:self];
	else
    {
		[_delegate registerRequestDone:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate registerRequestFailed:self];
}

@end
