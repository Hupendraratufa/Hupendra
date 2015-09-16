//
//  GetFileRequest.m
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "GetFileRequest.h"
#import "GeneralCMS.h"

@implementation GetFileRequest

@synthesize filePath = _filePath;

-(id)initWithCall:(NSString*)call downloadFilePath:(NSString*)downloadFilePath
{
	if((self = [super init]) != nil)
	{	
		[[GeneralCMS sharedInstance] trace:@"%@\n", call];
		NSURL* url = [NSURL URLWithString:call];
		_request = [[ASIHTTPRequest alloc] initWithURL:url];
		_request.delegate = self;		
		_filePath = [downloadFilePath retain];
		[_request setDownloadDestinationPath:downloadFilePath];
		[_request setShowAccurateProgress:YES];
		[_request setDownloadProgressDelegate:self];
        totalBytes = 0;
	}
	return self;
}

-(void)dealloc
{
	[_filePath release];
	[_message release];
	[super dealloc];
}

-(void)send
{
	[_request startAsynchronous];
}

//template methods
-(void)onDone
{
	NSAssert(NO, @"template method");
}

-(void)onFailed
{
	NSAssert(NO, @"template method");
}

-(void)onProgress:(float)progress
{
}



#pragma mark ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    NSString *replasingString = @"https://emperorlab-app.s3.amazonaws.com";
    NSString *newString = [[newURL absoluteString] stringByReplacingOccurrencesOfString:replasingString withString:@"http://d2wayvjv7g3yn1.cloudfront.net"];
    newURL = [NSURL URLWithString:newString];
    
    
	[[GeneralCMS sharedInstance] trace:@"redirect to %@:\n%@\n", [newURL absoluteString]];
	[request redirectToURL:newURL];
    
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSString * totalSize = [_request.responseHeaders objectForKey:@"Content-Length"];
    totalBytes = [totalSize intValue];
}



- (void)requestFinished:(ASIHTTPRequest*)request
{
	NSUInteger statusCode = [request responseStatusCode];
	[[GeneralCMS sharedInstance] trace:@"response:\n%@\n", [NSString stringWithFormat:@"%d", statusCode]];
	
	BOOL fileIsFull = NO;
    
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    NSError * error = 0;
    NSDictionary * attr = [fileManager attributesOfItemAtPath:_filePath error:&error];
    
//    if ([attr fileSize] == [[request.responseHeaders objectForKey:@"Content-Length"] integerValue] || ([attr fileSize] > 5000))
    if ([attr fileSize] == totalBytes  && ([attr fileSize] > 5000))
        fileIsFull = YES;
    
    [fileManager release];
    
    [request autorelease];
    
//	NSLog(@"total Bytes - %d; attr fileSize - %lld path = %@", totalBytes,[attr fileSize], _filePath);
    
    if(statusCode < 400 && fileIsFull)
	{
        //        NSLog(@"Request Finished Size at Path - %lld", [attr fileSize]);
		[self onDone];
	}
	else
	{
           // [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
		[self onFailed];
	}
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
	[[GeneralCMS sharedInstance] trace:@"%@", [NSString stringWithFormat:@"%s requestFailed:\n%d\n%@\n",
											   __FUNCTION__,
											   [request responseStatusCode],
										   [request.error localizedDescription]]];
	[request autorelease];
  //  [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];

	[self onFailed];
}

#pragma mark ASIProgressDelegate
- (void)setProgress:(float)newProgress
{
	[self onProgress:newProgress];
}

@end
