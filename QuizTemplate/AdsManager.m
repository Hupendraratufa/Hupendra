
#import "AdsManager.h"

#pragma mark -
#pragma mark Private Category
//**************************************************
//	Private Category
//**************************************************

@interface AppReskManager()

// Make any initialization of your class.
- (id) initSingleton;

@end

#pragma mark -
#pragma mark Public Interface
#pragma mark -
//**********************************************************************************************************
//
//	Public Interface
//
//**********************************************************************************************************

typedef enum AdsPriority : NSUInteger
{
    CHARTBOOST=0,
//    REVMOB,
    APPLOVIN,
}AdsPriority;

@implementation AppReskManager

#pragma mark -
#pragma mark Properties
//**************************************************
//	Properties
//**************************************************


#pragma mark -
#pragma mark Constructors
//**************************************************
//	Constructors
//**************************************************
@synthesize adMobBannerType;
- (id) initSingleton
{
	if ((self = [super init]))
	{
		// Initialization code here.
//        rateManager = [RateManager sharedManager];
	}
	
	return self;
}

#pragma mark -
#pragma mark Private Methods
//**************************************************
//	Private Methods
//**************************************************

#pragma mark -
#pragma mark Self Public Methods
//**************************************************
//	Self Public Methods
//**************************************************

+ (AppReskManager *) instance
{
	// Persistent instance.
	static AppReskManager *_default = nil;
	
	// Small optimization to avoid wasting time after the
	// singleton being initialized.
	if (_default != nil)
	{
		return _default;
	}
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	// Allocates once with Grand Central Dispatch (GCD) routine.
	// It's thread safe.
	static dispatch_once_t safer;
	dispatch_once(&safer, ^(void)
				  {
					  _default = [[AppReskManager alloc] initSingleton];
				  });
#else
	// Allocates once using the old approach, it's slower.
	// It's thread safe.
	@synchronized([AppReskManager class])
	{
		// The synchronized instruction will make sure,
		// that only one thread will access this point at a time.
		if (_default == nil)
		{
			_default = [[AppReskManager alloc] initSingleton];
		}
	}
#endif
	return _default;
}

#pragma mark -
#pragma mark Override Public Methods
//**************************************************
//	Override Public Methods
//**************************************************

- (id) retain
{
	return self;
}

- (oneway void) release
{
	// Does nothing here.
}

- (id) autorelease
{
	return self;
}

- (NSUInteger) retainCount
{
    return INT32_MAX;
}

-(void)dealloc
{
    [super dealloc];
}

#pragma mark - CHARTBOOST -
-(void)showChartboost_FullScreen
{
    
    [Chartboost startWithAppId:ChartBoostAppID appSignature:ChartBoostAppSignature delegate:self];
        
        [Chartboost cacheInterstitial:CBLocationDefault];
    
        // Show an ad at location "CBLocationHomeScreen"
        [Chartboost showInterstitial:CBLocationDefault];
}


-(void)showChartboost_MoreApps
{

        [Chartboost startWithAppId:ChartBoostAppID appSignature:ChartBoostAppSignature delegate:self];

        
        [Chartboost cacheMoreApps:CBLocationDefault];

        // Then show the MoreApps page:
        [Chartboost showMoreApps:CBLocationDefault];
}


#pragma mark - CHARTBOOST DELEGATES-
// All of the delegate methods below are optional.
// Implement them only when you need to more finely control Chartboost's behavior.


- (void)didDismissInterstitial:(NSString *)location {
}

- (void)didDismissMoreApps {
}



/// Called when an interstitial has been received and cached.
- (void)didCacheInterstitial:(CBLocation)location
{
    
}

/// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial:(CBLocation)location  withError:(CBLoadError)error
{
    
}


/// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(CBLocation)location
{
    
}

/// Same as above, but only called when dismissed for a click
- (void)didClickInterstitial:(CBLocation)location
{
    
}

/// Called when the App Store sheet is dismissed, when displaying the embedded app sheet.
- (void)didCompleteAppStoreSheetFlow
{
    
}



/// Called when the More Apps page has been received and cached
- (void)didCacheMoreApps
{
    
}

/// Called when a more apps page has failed to come back from the server
- (void)didFailToLoadMoreApps:(CBLoadError)error
{
    
}



/// Same as above, but only called when dismissed for a close
- (void)didCloseMoreApps
{
    
}

/// Same as above, but only called when dismissed for a click
- (void)didClickMoreApps
{
    
    
}

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return NO;
}



#pragma mark - LOCAL NOTIFICATION -

-(void)setupLocalNotification
{
    [[[LocalNotificationManager alloc]initWithMessage:@"Show your Local message here"]autorelease];
}

#pragma mark - RATE MANAGER -
-(void)showRateApp
{
    [[RateManager sharedManager]showReviewApp];
}

#pragma mark -
#pragma mark - PRIORITY ADS
-(void)showAdsOnPriority
{
    
}



#pragma mark -
#pragma mark - AdMob

-(void)showAdmobBanner
{
    if(isOrientationPortrait)
    {
     bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    }
    else
    {
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    }
    bannerView_.adUnitID=AdmobBannerID;
    bannerView_.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:bannerView_];
    GADRequest *request = [GADRequest request];
    [bannerView_ loadRequest:request];
    CGRect frame = bannerView_.frame;
    frame.origin.x=0.0f;
    
    switch (adMobBannerType) {
        case kAdMobBannerTop:
             frame.origin.y=0.0f;
             break;
            
        case kAdmobBannerBottom:
        {
             frame.origin.y=[[UIScreen mainScreen]bounds].size.height-frame.size.height;
        }
             break;
            
        default:
             break;
    }
    
    
    
    
    
    bannerView_.frame=frame;

}

-(void)hideAdmobBanner
{
    
[bannerView_ removeFromSuperview];

}

-(void)preLoadAdmobInterstitial
{
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    GADRequest *request = [GADRequest request];
//    interstitial_ = [[GADInterstitial alloc] init];
//    interstitial_.adUnitID = AdmobInterstitialID;
    interstitial_=[[GADInterstitial alloc]initWithAdUnitID:AdmobInterstitialID];
   // [interstitial_ presentFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    interstitial_.delegate = self;
    [interstitial_ loadRequest:request];
    
}


-(void)showAdmobInterstitial
{
    
    //Call this method when you want to show the interstitial - the method should double check that the interstitial has not been used before trying to present it
    if ([interstitial_ isReady]) [interstitial_ presentFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
   // [interstitial_ presentFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    //An interstitial object can only be used once - so it's useful to automatically load a new one when the current one is dismissed
    [self preLoadAdmobInterstitial];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(preLoadAdmobInterstitial) userInfo:nil repeats:NO];
}

@end
