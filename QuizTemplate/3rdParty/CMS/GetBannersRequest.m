//
//  GetBannersRequest.m
//  ServerApi
//
//  Created by Vladislav on 2/17/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetBannersRequest.h"
#import "NSDataAdditions.h"
#import "CRFileUtils.h"
#import "GeneralCMS.h"

@implementation GetBannersRequestItem

@synthesize Id = _id;
@synthesize text = _text;
@synthesize link = _link;
@synthesize imagePath = _imagePath;

-(id)initWithId:(NSUInteger)Id text:(NSString*)text link:(NSString*)link imagePath:(NSString*)imagePath
{
	if((self = [super init]) != nil)
	{
		_id = Id;
		_text = [text retain];
		_link = [link retain];
		_imagePath = [imagePath retain];
	}
	return self;
}

+(GetBannersRequestItem*)itemWithId:(NSUInteger)Id text:(NSString*)text link:(NSString*)link imagePath:(NSString*)imagePath
{
	return [[[GetBannersRequestItem alloc] initWithId:Id text:text
												 link:link imagePath:imagePath] autorelease];
}

-(void)dealloc
{
	[_text release];
	[_link release];
	[_imagePath release];
	[super dealloc];
}

@end

@implementation GetBannersRequest

@synthesize results = _results;

-(id)initWithDelegate:(id<GetBannersRequestDelegate>)delegate ids:(NSArray*)ids
{
	if((self = [super init]) != nil)
	{	
		_delegate = delegate;
		NSString* apiUrl = [[GeneralCMS sharedInstance] makeURL:@"get_banners"];
		[[GeneralCMS sharedInstance] trace:@"%@\n", apiUrl];
		NSURL* url = [NSURL URLWithString:apiUrl];
		_request = [[ASIFormDataRequest alloc] initWithURL:url];
		[(ASIFormDataRequest*)_request setPostValue:[GeneralCMS sharedInstance].identifier forKey:@"session"];
				
		SBJsonWriter* writer = [[SBJsonWriter new] autorelease];
		NSString* jsonStr = [writer stringWithObject:ids];
		[(ASIFormDataRequest*)_request setPostValue:jsonStr forKey:@"ids"];

		_imageRequests = [NSMutableArray new];

		_request.delegate = self;
		_results = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)dealloc
{
	[_imageRequests release];
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
		[_delegate getBannersRequestFailed:self];
	}
	else
	{
		NSArray* banners = [dict objectForKey:@"banners"];
		for(NSDictionary* banner in banners)
		{
			NSUInteger Id = [[banner objectForKey:@"id"] intValue];
			NSString* imageUrl = [banner objectForKey:@"image"];
            NSString* imageExention = [imageUrl pathExtension];
			NSString* imagePath = [CRFileUtils cachesPath:[NSString stringWithFormat:@"banner_%d.%@", Id,imageExention]];
            
			GetCustomFileRequest* request = [[[GetCustomFileRequest alloc] initWithDelegate:self
																					   url:imageUrl
																		  downloadFilePath:imagePath] autorelease];
			[_imageRequests addObject:request];
			
            GetBannersRequestItem* item = [GetBannersRequestItem itemWithId:Id
                                                                       text:[banner objectForKey:@"text"]
																	   link:[banner objectForKey:@"itunes_link"]
																  imagePath:imagePath];
			[_results addObject:item];		}
	}
	[_imageRequests makeObjectsPerformSelector:@selector(send)];
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%s requestFailed", __FUNCTION__];
	[request autorelease];
	[_delegate getBannersRequestFailed:self];
}

-(void)getCustomFileRequestDone:(GetCustomFileRequest*)request
{
	[[request retain] autorelease];
	[_imageRequests removeObject:request];
	if(![_imageRequests count])
		[_delegate getBannersRequestDone:self];
}

-(void)getCustomFileRequestFailed:(GetCustomFileRequest*)request
{
	[_imageRequests removeAllObjects];
	[_delegate getBannersRequestFailed:self];
}

@end