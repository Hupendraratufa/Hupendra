//
//  Model.m
//  Anti-Fat
//
//  Created by Yury Shubin on 05/06/2011.
//  Copyright 2011 EmperorLab. All rights reserved.
//

#import "Model.h"
#import "math.h"
#import "GeneralCMS.h"
#import "AppSettings.h"
#import "MKSKSubscriptionProduct.h"
#import "MKStoreManager.h"
#import "PersonInitializer.h"
#import "QuestionInitializer.h"
#import "Person.h"
#import "Reachability.h"
#import "BotInitializer.h"

@interface Model (Private)



@end

@implementation Model

@synthesize appBannerIds = _appBannerIds;

Model* _instanceModel = nil;

-(BOOL)bIsShowBanner
{
    return ![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS];
}

//-(BOOL)bIsInviteFrinedsAvaliable
//{
//    NSDate *previousDate = [AppSettings inviteFriendsDate];
//    NSInteger daysBetween = [self daysBetweenDate:previousDate andDate:[NSDate date]];
//    
//    if (daysBetween >= 1)
//        return YES;
//    
//    return NO;
//    
//}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    
    NSDate *startdate = fromDateTime;
    NSDate *toDate = toDateTime;
    
    int i = [startdate timeIntervalSince1970];
    int j = [toDate timeIntervalSince1970];
    
    double X = j-i;
    int days=(int)(((double)X/(3600.0*24.00))); // two days between
    return days;
    
}


//-(NSNumber*)textIdForBanner
//{
//    // NOT FOR THIS APP
//    
//    NSUInteger Id = 303;
//    if (isPad)
//    {
//        Id = 305;
//        if ([[self languageId] integerValue] == 23) // russian
//            Id = 306;
//    }
//    else
//    {
//        Id = 303;
//        if ([[self languageId] integerValue] == 23) // russian
//            Id = 304;
//    }
//    
//    return [NSNumber numberWithInteger:Id];
//}

-(void)setAppBannerIds:(NSString *)appBannerIds
{
    _appBannerIds = appBannerIds ;
}

-(NSString*)appBannerIds
{
    return _appBannerIds;
}


-(NSNumber*)languageId
{
    
    if ([[AppSettings  currentLanguage] isEqualToString:@"en_US"])
        return [NSNumber numberWithInt:22];
    else if ([[AppSettings  currentLanguage]  isEqualToString:@"ru_RU"])
        return [NSNumber numberWithInt:23];
    
    return [NSNumber numberWithInt:22];
}

-(id)init
{
	if((self = [super init]) != nil)
	{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLog:) name:@"log" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLog:) name:@"GeneralCMS" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHasDeviceToken:) name:@"has_device_token" object:nil];
        [self startTimer:YES];
        
        _bannerAdLoader = [[BannerAdsLoader alloc] init];

	}
	return self;
}

-(void)startTimer:(BOOL)value
{

    _timerValue = 0;
    [_timer invalidate];
    _timer = nil;
    
    if ([self isInternetAvailable] && value)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerStep:) userInfo:nil repeats:YES];

    }
}

- (BOOL)isInternetAvailable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus == NotReachable) {
        return NO;
        } else {
        return YES;
    }
}
-(void)timerStep:(NSTimer*)timer
{
    _timerValue++;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:_timerValue] forKey:@"timerValue"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CoinTimerStep" object:nil userInfo:dic];
    if (_timerValue == 120)
    {
        NSLog(@"mintes Counting %ld",(long)_timerValue);
        _timerValue = 0;
        /*   if (_timerWith2Min==2) {
         [self addOneCoin];
         }else {
         _timerWith2Min++;
         }*/
        [self addOneCoin];
        [self startTimer:YES];
    }
}

-(void)addOneCoin
{
    _timerWith2Min=0;
    Person *person = [[Person allObjects] lastObject];
    NSInteger coins = [person.coinsEarned integerValue];
    NSLog(@"counter update %ld",(long)coins);
    //  coins++;
    
    if (coins>=125) {
        
    }else{
        coins=coins+5;
        NSLog(@"counter play %ld",(long)coins);
        person.coinsEarned = [NSNumber numberWithInteger:coins];
        [DELEGATE saveContext];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddOneCoinNotification" object:nil];
}-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;

}
-(void)initializeDataWithSucces:(void (^)(void))complectionBlock onFailed:(void (^)(void))failedBlock
{
    self.initComplited = complectionBlock;
    self.initFailed = failedBlock;

    if (![AppSettings  dataImported])
    {
        [DELEGATE clearAllData];
        
        [QuestionInitializer initializeCoreData];
        [PersonInitializer initializePerson];
        [BotInitializer initBots];
        
        [DELEGATE saveContext];
        [AppSettings  setDataImported:YES];

        if (self.initComplited)
            self.initComplited();
        
        self.initComplited = nil;
        self.initFailed = nil;
        
    }
    else
    {
            if (self.initComplited)
                self.initComplited();
            
            self.initComplited = nil;
            self.initFailed = nil;
    }
    
}

+(Model*)instance
{
    static dispatch_once_t once;
    static Model *sharedObject;
    dispatch_once(&once, ^ { sharedObject = [[Model alloc] init]; });
    return sharedObject;
}


-(void)prepareBannerAds
{
    [_bannerAdLoader downloadBannerMetaWithOnSuccess:^(NSArray *result) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerLoaderComplite" object:nil userInfo:[NSDictionary dictionaryWithObject:result forKey:@"result"]];
    } onFailed:^{
        
    }];
}

-(NSArray*)offlineBanners
{
    return [_bannerAdLoader configureOfflineBanners];
}

-(void)addLog:(NSString*)log
{
}

-(void)onLog:(NSNotification*)notification
{
	[self performSelectorOnMainThread:@selector(addLog:) withObject:notification.object waitUntilDone:YES];
}

-(void)onHasDeviceToken:(NSNotification*)notification
{
	NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"]);
}


@end
