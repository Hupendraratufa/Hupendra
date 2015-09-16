

#import "Constants1.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADInterstitial.h>
//#import "GADBannerView.h"
//#import "GADInterstitial.h"

typedef NS_ENUM(NSInteger, AdMobBannerType) {
    kAdMobBannerTop,
    kAdmobBannerBottom
  
};
#define isOrientationPortrait [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown

@interface AppReskManager : NSObject<ChartboostDelegate,GADInterstitialDelegate>
{
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;


}

@property(readwrite,assign) AdMobBannerType adMobBannerType;
+ (AppReskManager *) instance;

-(void)showRevmob_FullScreen;
-(void)showRevmob_LinkAd;
-(void)showChartboost_FullScreen;
-(void)showChartboost_MoreApps;
-(void) showApplovinFullscreen;

-(void)setupLocalNotification;

-(void)showRateApp;

-(void)showAdsOnPriority;

-(void)startFlurry;

-(void)showPlayhaven;

-(void)showVungleAds;

-(void)showAdmobBanner;

-(void)hideAdmobBanner;

-(void)showAdmobInterstitial;

-(void)preLoadAdmobInterstitial;

@end