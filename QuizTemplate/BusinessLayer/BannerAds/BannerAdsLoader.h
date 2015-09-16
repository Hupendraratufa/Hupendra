//
//  BannerAdsManager.h
//  KatyaEnergy
//
//  Created by Vladislav on 7/17/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import "GetTextsRequest.h"
#import "GetBannersRequest.h"

@interface BannerAdsLoader : NSObject <GetTextsRequestDelegate, GetBannersRequestDelegate>
{
    void (^onSuccess)(NSArray* bannerAds);
    void (^onFailed)();
    
//    dispatch_queue_t backgroundQueue;
    int pendingItems;
    
}

@property (nonatomic, retain) GetBannersRequest *getBannerRequest;
@property (nonatomic, retain) GetTextsRequest *bannerIdsRequest;

-(void)downloadBannerMetaWithOnSuccess:(void (^)(NSArray* result))successBlock onFailed:(void(^)())failedBloc;
-(NSArray*)configureOfflineBanners;
@end
