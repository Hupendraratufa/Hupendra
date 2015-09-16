//
//  GetRatingExRequest.m
//  ServerApi
//
//  Created by Vladislav on 6/21/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetRatingExRequest.h"
#import "GeneralCMS.h"

@implementation GetRatingExRequest

-(NSArray*)ratings
{
	return [_results allKeys];
}

-(NSUInteger)usersCountForRating:(NSUInteger)rating
{
	return [[_results objectForKey:[NSString stringWithFormat:@"%d", rating]] intValue];
}

-(id)initWithDelegate:(id<GetRatingExRequestDelegate>)delegate contentType:(ContentType)contentType contentId:(NSUInteger)contentId
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_rating_ex"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
		NSString* contentTypeStr = nil;
		switch (contentType) 
		{
			case ContentTypeImage:
				contentTypeStr = @"image";
				break;
			case ContentTypeVideo:
				contentTypeStr = @"video";				
				break;
			case ContentTypeAudio:
				contentTypeStr = @"audio";				
				break;
			case ContentTypeText:
				contentTypeStr = @"text";
				break;
			default:
				break;
		}
		[(ASIFormDataRequest*)_request setPostValue:contentTypeStr forKey:@"item_type"];
		[(ASIFormDataRequest*)_request setPostValue:[NSNumber numberWithInteger:contentId] forKey:@"content_id"];
		_request.delegate = self;
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
		[_delegate getRatingExRequestFailed:self];
	else
	{
		id results = [dict objectForKey:@"results"];
		if([results isKindOfClass:[NSDictionary class]])
			_results = [results retain];
			
		[_delegate getRatingExRequestDone:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate getRatingExRequestFailed:self];
}

@end