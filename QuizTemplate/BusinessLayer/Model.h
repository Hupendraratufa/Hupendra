//
//  Model.h
//  Anti-Fat
//
//  Created by Yury Shubin on 05/06/2011.
//  Copyright 2011 EmperorLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerAdsLoader.h"

@interface Model : NSObject
{
    NSString *_appBannerIds;
    
    NSTimer *_timer;
    NSInteger _timerValue;
      NSInteger _timerWith2Min;
    
}

+(Model*)instance;
//-(NSNumber*)textIdForBanner;
-(BOOL)bIsShowBanner;
-(NSNumber*)languageId;
-(void)initializeDataWithSucces:(void (^)(void))complectionBlock onFailed:(void (^)(void))failedBlock;
-(void)startTimer:(BOOL)value;

@property (nonatomic, copy) void (^initComplited)();
@property (nonatomic, copy) void (^initFailed)();
@property (nonatomic, strong) BannerAdsLoader *bannerAdLoader;
@property (nonatomic, strong) NSString *appBannerIds;
@property (nonatomic, assign) BOOL serverRateAlert;
- (BOOL)isInternetAvailable;

-(void)prepareBannerAds;
-(NSArray*)offlineBanners;
@end
