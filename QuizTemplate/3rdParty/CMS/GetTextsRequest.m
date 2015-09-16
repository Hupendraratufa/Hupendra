//
//  GetTextsRequest.m
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetTextsRequest.h"
#import "GeneralCMS.h"

@implementation GetTextsRequestItem

@synthesize text = _text;
@synthesize Id = _id;

-(id)initWithId:(NSUInteger)Id text:(NSString*)text
{
	if((self = [super init]) != nil)
	{
		_id = Id;
		_text = [text retain];
	}
	return self;
}

+(GetTextsRequestItem*)itemWithId:(NSUInteger)Id text:(NSString*)text
{
	return [[[GetTextsRequestItem alloc] initWithId:Id text:text] autorelease];
}

-(void)dealloc
{
	[_text release];
	[super dealloc];
}

@end

@implementation GetTextsRequest

@synthesize results = _results;

-(id)initWithDelegate:(id<GetTextsRequestDelegate>)delegate ids:(NSArray*)ids
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_texts"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
		
		SBJsonWriter* writer = [[SBJsonWriter new] autorelease];
		NSString* jsonStr = [writer stringWithObject:ids];
		[(ASIFormDataRequest*)_request setPostValue:jsonStr forKey:@"ids"];

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
		[_delegate getTextsRequestFailed:self];
	}
	else
	{
		NSArray* texts = [dict objectForKey:@"texts"];
		for(NSDictionary* text in texts)
		{
			for(NSString* key in [text allKeys])
			{
				GetTextsRequestItem* item = [GetTextsRequestItem itemWithId:[key intValue] text:[text objectForKey:key]];
				[_results addObject:item];
			}
		}
		
		[_delegate getTextsRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate getTextsRequestFailed:self];
}

@end