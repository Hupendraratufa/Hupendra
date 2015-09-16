//
//  GetLanguagesRequest.m
//  ServerApi
//
//  Created by Vladislav on 5/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetLanguagesRequest.h"
#import "GeneralCMS.h"

@implementation GetLanguagesRequestItem

@synthesize name = _name;
@synthesize Id = _id;

-(id)initWithId:(NSUInteger)Id name:(NSString*)name
{
	if((self = [super init]) != nil)
	{
		_id = Id;
		_name = [name retain];
	}
	return self;
}

+(GetLanguagesRequestItem*)itemWithId:(NSUInteger)Id name:(NSString*)name
{
	return [[[GetLanguagesRequestItem alloc] initWithId:Id name:name] autorelease];
}

-(void)dealloc
{
	[_name release];
	[super dealloc];
}

@end

@implementation GetLanguagesRequest

@synthesize results = _results;

-(id)initWithDelegate:(id<GetLanguagesRequestDelegate>)delegate
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_languages"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
				
		_request.delegate = self;
		
		_results = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)dealloc
{
	[_results release];
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
		[_delegate getLanguagesRequestFailed:self];
	}
	else
	{
		NSArray* names = [dict objectForKey:@"languages"];
		for(NSDictionary* name in names)
		{
			for(NSString* key in [name allKeys])
			{
				GetLanguagesRequestItem* item = [GetLanguagesRequestItem itemWithId:[key intValue] name:[name objectForKey:key]];
				[_results addObject:item];
			}
		}
		
		[_delegate getLanguagesRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate getLanguagesRequestFailed:self];
}

@end