//
//  SetSessionContextRequest.h
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@class SetSessionContextRequest;

@protocol SetSessionContextRequestDelegate<NSObject>

-(void)setSessionContextRequestDone:(SetSessionContextRequest*)request;
-(void)setSessionContextRequestFailed:(SetSessionContextRequest*)request;

@end

/*
set session context. 

requirements: 
	user should be already logged in 
 
available parameters:
	key: "device" - device("ipad" or "iphone")
	key: "language" - languageid
*/
@interface SetSessionContextRequest : BaseRequest
{
	id<SetSessionContextRequestDelegate> _delegate;
}

-(id)initWithDelegate:(id<SetSessionContextRequestDelegate>)delegate params:(NSDictionary*)params;
-(void)send;

@end