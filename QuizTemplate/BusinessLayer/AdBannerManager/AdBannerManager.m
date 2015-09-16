//
//  AdBannerManager.m
//  Anti-Fat
//
//  Created by Vladislav on 12/21/12.
//  Copyright (c) 2012 EmperorLab. All rights reserved.
//

#import "AdBannerManager.h"
#import "Model.h"
#import "AppSettings.h"
#import "CRFileUtils.h"
#import "UIViewController+MJPopupViewController.h"

@implementation AdBannerManager

AdBannerManager* adManagerSharedInstance = nil;

+(AdBannerManager*)sharedInstanse
{
    if (!adManagerSharedInstance)
        adManagerSharedInstance = [AdBannerManager new];
    
    return adManagerSharedInstance;
}

-(id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

-(void)appDidEnterForeground
{
    
    [self loadAdBanner];
}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    
    NSDate *startdate = fromDateTime;
    NSDate *toDate = toDateTime;
    
    int i = [startdate timeIntervalSince1970];
    int j = [toDate timeIntervalSince1970];
    
    double X = j-i;
    int days=(int)(((double)X/(3600.0*24.00))); // days between
    return days;
    
}

-(NSString*)bannerLink
{
    return [AppSettings  adBannerLink];
    //    return [[NSUserDefaults standardUserDefaults] objectForKey:@"adBannerLink"];
}

-(void)loadAdBanner
{
    _getBannerRequest = [[GetBannersRequest alloc] initWithDelegate:self ids:[NSArray arrayWithObject:[self bannerId]]];
    [_getBannerRequest send];
}

-(NSNumber*)bannerId
{
    if ([[AppSettings currentLanguage] isEqualToString:@"ru_RU"])
        return [NSNumber numberWithInt:AppEmperorBannerID_RU];
    
    return [NSNumber numberWithInt:AppEmperorBannerID_EN];
}

-(BOOL)needShowLink:(NSString*)link
{
    return ![[self bannerLink] isEqualToString:link];
}


#pragma mark GetBannerReaquestDelegate
-(void)getBannersRequestDone:(GetBannersRequest *)request
{
    for (GetBannersRequestItem *item in request.results)
    {
        //        NSLog(@"AD Banner Link - %@, imagePath - %@, description - %@", item.link, item.imagePath, item.text);
        if (![item.link isEqual:[NSNull null]])
        {
            if (![item.link isEqualToString:@"stop"])
            {
                // show Ad Banner
                if ([CRFileUtils fileExistsAtPath:item.imagePath] && [self needShowLink:item.link])
                {
                    BannerViewController *vc = [[BannerViewController alloc] initWithNibName:isPad ? @"BannerViewController_iPad" : @"BannerViewController_iPhone" bundle:nil];
                    
                    vc.delegate = self;
                    
                    [DELEGATE.navigationController.topViewController presentPopupViewController:vc animationType:MJPopupViewAnimationSlideTopTop];
                    [vc showWithBanner:item];
                    
                    [AppSettings  setAdBannerLink:item.link];
                    
                }
            }
        }
        else
            [AppSettings  setAdBannerLink:@"stop"];
    }
    
    
    _getBannerRequest = nil;
}

-(void)getBannersRequestFailed:(GetBannersRequest *)request
{
    
    _getBannerRequest = nil;
}

-(void)bannerDidClose
{
    [DELEGATE.navigationController.topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
}

@end
