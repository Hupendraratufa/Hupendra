//
//  GetServerTimeRequest.h
//  Anti-Fat
//
//  Created by Vladislav on 2/11/13.
//  Copyright (c) 2013 EmperorLab. All rights reserved.
//

#import "BaseRequest.h"
#import "ASIFormDataRequest.h"

@class GetServerTimeRequest;

@protocol GetServerTimeRequestDelegate <NSObject>

-(void)getServerTimeRequestDone:(GetServerTimeRequest*)request;
-(void)getServerTimeRequestFailed:(GetServerTimeRequest*)request;

@end

@interface GetServerTimeRequest : BaseRequest
{
    id<GetServerTimeRequestDelegate> _delegate;
    NSDate *_serverDate;
}
@property (nonatomic, readonly) NSDate *serverDate;

-(id)initWitDelegate:(id<GetServerTimeRequestDelegate>)delegate;
-(void)send;

@end
