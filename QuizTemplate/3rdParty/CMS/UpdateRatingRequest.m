//
//  UpdateRatingRequest.m
//  ServerApi
//
//  Created by Vladislav on 6/19/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "UpdateRatingRequest.h"
#import "GeneralCMS.h"

@implementation UpdateRatingRequest

-(id)initWithDelegate:(id<UpdateRatingRequestDelegate>)delegate contentType:(ContentType)contentType contentId:(NSUInteger)contentId 
			   rating:(NSUInteger)rating needRewrite:(BOOL)needRewrite
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"update_rating"];
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
		[(ASIFormDataRequest*)_request setPostValue:[NSNumber numberWithInteger:rating] forKey:@"rating"];		
		[(ASIFormDataRequest*)_request setPostValue:[NSNumber numberWithBool:needRewrite] forKey:@"need_rewrite"];		
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
		[_delegate updateRatingRequestFailed:self];
	else
		[_delegate updateRatingRequestDone:self];
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate updateRatingRequestFailed:self];
}

@end