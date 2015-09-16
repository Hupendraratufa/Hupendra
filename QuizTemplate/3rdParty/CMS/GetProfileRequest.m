//
//  GetProfileRequest.m
//  ServerApi
//
//  Created by Vladislav on 6/19/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetProfileRequest.h"
#import "GeneralCMS.h"

@implementation GetProfileRequestItem

@synthesize name = _name;
@synthesize value = _value;

-(id)initWithName:(NSString*)name value:(NSString*)value
{
	if(self = [super init])
	{
		_name = [name retain];
		_value = [value retain];
	}
	return self;
}

-(void)dealloc
{
	[_name release];
	[_value release];
	[super dealloc];
}

@end

@implementation GetProfileRequest

@synthesize fields = _fields;

-(id)initWithDelegate:(id<GetProfileRequestDelegate>)delegate
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_profile"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
		_request.delegate = self;
		_fields = [NSMutableArray new];
	}
	return self;
}

-(void)dealloc
{
	[_fields release];
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
		[_delegate getProfileRequestFailed:self];
	else
	{
		NSArray* fields = [dict objectForKey:@"fields"];
		for(NSDictionary* info in fields)
		{
			GetProfileRequestItem* item = [[[GetProfileRequestItem alloc]
										   initWithName:[info objectForKey:@"name"]
										   value:[info objectForKey:@"value"]] autorelease];
			[_fields addObject:item];
		}
		
		[_delegate getProfileRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate getProfileRequestFailed:self];
}

@end
