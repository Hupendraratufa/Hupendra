//
//  BaseRequest.m
//  ServerApi
//
//  Created by Vladislav on 5/12/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest

@synthesize message = _message;

-(BOOL)parseForErrors:(NSDictionary*)dict
{
	if(![[dict objectForKey:@"success"] boolValue])
	{
		_message = [[dict objectForKey:@"message"] retain];
		return NO;
	}
	return YES;
}

-(void)cancelRequest
{
    [_request cancel];
    [_request clearDelegatesAndCancel];
	_request = nil;
}

-(void)dealloc
{
	[self cancelRequest];
	[_message release];
	[super dealloc];
}

@end
