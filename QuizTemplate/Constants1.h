

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Chartboost/Chartboost.h>


//#define FLURRY_KEY      @""

//#define PLAYHAVEN_TOKEN         @""
//#define PLAYHAVEN_SECRET        @""
//#define PLAYHAVEN_PLACEMENT     @""

//#define VUNGLE_KEY              @"54d6019824ae960b720000d5"


#define IS_IOS7_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#ifdef DEBUG
#define DebugLog(f, ...) NSLog(f, ## __VA_ARGS__)
#else
#define DebugLog(f, ...)
#endif

#define FreeApp

#ifdef FreeApp
//#define kRevMobId @""

#define AdmobBannerID @"ca-app-pub-9381788539149191/2102575862"
#define AdmobInterstitialID @"ca-app-pub-9381788539149191/9625842667"

#define ChartBoostAppID @"5575589c0d6025534e75ea7d"
#define ChartBoostAppSignature @"f179ca87a0b51416cd3aad1593938e0fc1cd3ad6"

#ifdef IS_IOS7_AND_UP
#define kRateURL @"itms-apps://itunes.apple.com/app/id965524481"
#else
#define kRateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=965524481"
#endif

#endif

#ifdef PaidApp
//#define kRevMobId @""
#define AdmobBannerID @"54d603110d60252b918aac4f"
#define AdmobInterstitialID @"3fc3dc134fc244da553a6290c28d4293056f21cd"

#define ChartBoostAppID @"54d603110d60252b918aac4f" //
#define ChartBoostAppSignature @"3fc3dc134fc244da553a6290c28d4293056f21cd" //

#ifdef IS_IOS7_AND_UP
#define kRateURL @"itms-apps://itunes.apple.com/app/id965524481"
#else
#define kRateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=965524481"
#endif

#endif
