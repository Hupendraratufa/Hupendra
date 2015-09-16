//
//  GetFileRequest.h
//  ServerApi
//
//  Created by Vladislav on 2/16/12.
//  Copyright (c) 2012 IntellectSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIProgressDelegate.h"
#import "BaseRequest.h"

/*
download file by url
 
requirements: 
	user should be already logged in
	session should be setup 
*/
@interface GetFileRequest : BaseRequest<ASIHTTPRequestDelegate, ASIProgressDelegate>
{
	NSString* _filePath;
    int totalBytes;
}

@property(nonatomic, readonly) NSString* message;
@property(nonatomic, readonly) NSString* filePath;

-(id)initWithCall:(NSString*)call downloadFilePath:(NSString*)downloadFilePath;
-(void)send;

//template methods
-(void)onDone;
-(void)onFailed;
-(void)onProgress:(float)progress;


@end
