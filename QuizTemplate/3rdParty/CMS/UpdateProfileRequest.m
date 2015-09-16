//
//  UpdateProfileRequest.m
//  ServerApi
//
//  Created by Vladislav on 6/19/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "UpdateProfileRequest.h"
#import "GeneralCMS.h"

@implementation UpdateProfileRequest



-(id)initWithDelegate:(id<UpdateProfileRequestDelegate>)delegate fieldInfo:(NSDictionary*)fieldInfo, ...
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"update_profile"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
		
		va_list params;
		va_start(params, fieldInfo);
		NSDictionary* info = nil;
		for(info = fieldInfo; info != nil;)
		{
			NSString* key = [[info allKeys] lastObject];
			[(ASIFormDataRequest*)_request setPostValue:[info objectForKey:key] forKey:key];
			
			info = va_arg(params, NSDictionary*);
		}
		va_end(params);
		
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
		[_delegate updateProfileRequestFailed:self];
	else
    {
       
		[_delegate updateProfileRequestDone:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate updateProfileRequestFailed:self];
}

@end