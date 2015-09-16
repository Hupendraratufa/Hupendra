//
//  BannerAdsManager.m
//  KatyaEnergy
//
//  Created by Vladislav on 7/17/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "BannerAdsLoader.h"
#import "SBJsonParser.h"
#import "AppSettings.h"
#import "CRFileUtils.h"

@implementation BannerAdsLoader

@synthesize bannerIdsRequest;
@synthesize getBannerRequest;

-(void)downloadBannerMetaWithOnSuccess:(void (^)(NSArray *))successBlock onFailed:(void (^)())failedBloc
{
    onFailed = failedBloc;
    onSuccess = successBlock;
    
    pendingItems = 0;

    NSInteger textID = [[AppSettings currentLanguage] isEqualToString:@"ru_RU"] ? 351 : 350;
    
    bannerIdsRequest = [[GetTextsRequest alloc] initWithDelegate:self ids:[NSArray arrayWithObject:[NSNumber numberWithInteger:textID]]];
        [bannerIdsRequest send];

}

-(NSArray*)configureOfflineBanners
{
 
    NSArray *banners = [NSArray arrayWithContentsOfFile:[CRFileUtils resourcePath:[NSString stringWithFormat:@"/Banners/OfflineBanners_%@.plist",[AppSettings currentLanguage]]]];
    
    NSMutableArray *bannerItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary *banner in banners)
    {
        NSUInteger Id = [[banner objectForKey:@"bannerId"] intValue];
        NSString *link = [banner objectForKey:@"bannerLink"];
        NSString *imagePath = [CRFileUtils resourcePath:[NSString stringWithFormat:@"/Banners/banner_%d.png",Id]];
        GetBannersRequestItem* item = [GetBannersRequestItem itemWithId:Id  text:nil link:link imagePath:imagePath];
        [bannerItems addObject:item];
    }
    return bannerItems;
}

#pragma mark GetTextRequestDelegate
-(void)getTextsRequestDone:(GetTextsRequest *)request
{
    GetTextsRequestItem *item = [request.results lastObject];
    NSString *result = item.text;
    NSArray* metadata = [[SBJsonParser new] objectWithString:result];
    NSMutableArray *bannerIds = [[NSMutableArray alloc] init];
    for (NSDictionary* info in metadata)
    {
        [bannerIds addObject:[info objectForKey:@"bannerId"]];
    }
    bannerIdsRequest = nil;
    
    getBannerRequest = [[GetBannersRequest alloc] initWithDelegate:self ids:bannerIds];
    [getBannerRequest send];
}

-(void)getTextsRequestFailed:(GetTextsRequest *)request
{
    onFailed();
    onFailed = nil;
    onSuccess = nil;
    bannerIdsRequest = nil;
}

#pragma mark GetBannerRequestDelegate
-(void)getBannersRequestDone:(GetBannersRequest *)request
{
    onSuccess(request.results);
    onFailed = nil;
    onSuccess = nil;
    getBannerRequest = nil;

}

-(void)getBannersRequestFailed:(GetBannersRequest *)request
{
    onFailed();
    onFailed = nil;
    onSuccess = nil;
    getBannerRequest = nil;

}
@end
