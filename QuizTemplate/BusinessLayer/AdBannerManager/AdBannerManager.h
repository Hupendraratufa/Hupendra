//
//  AdBannerManager.h
//  Anti-Fat
//
//  Created by Vladislav on 12/21/12.
//  Copyright (c) 2012 EmperorLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetBannersRequest.h"
#import "BannerViewController.h"

@interface AdBannerManager : NSObject <GetBannersRequestDelegate, BannertViewDelegate>
{
    GetBannersRequest *_getBannerRequest;
}

+(AdBannerManager*)sharedInstanse;
-(void)appDidEnterForeground;


@end
