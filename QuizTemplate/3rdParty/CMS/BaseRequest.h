//
//  BaseRequest.h
//  ServerApi
//
//  Created by Vladislav on 5/12/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface BaseRequest : NSObject<ASIHTTPRequestDelegate>
{
	ASIHTTPRequest* _request;
	NSString* _message;
}

-(BOOL)parseForErrors:(NSDictionary*)dict;
-(void)cancelRequest;

@property(nonatomic, readonly) NSString* message;

@end
