//
//  AppSettings.m
//  AgeOfDeath
//
//  Created by Vladislav on 1/3/13.
//
//

#import "AppSettings.h"
#import "MKStoreManager.h"

@implementation AppSettings

+(void)setAppIsRated:(BOOL)isRated
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isRated] forKey:@"bIsRateAlertDID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)appIsRated
{
      return [[[NSUserDefaults standardUserDefaults] objectForKey:@"bIsRateAlertDID"] boolValue];
}

+(void)setInviteFriendsDate:(NSDate *)inviteFriendsDate
{
    [[NSUserDefaults standardUserDefaults] setObject:inviteFriendsDate forKey:@"inviteFriendsDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)inviteFriendsDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"inviteFriendsDate"];
}


+(void)setBIsRateAlertDID:(BOOL)bIsRateAlertDID
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bIsRateAlertDID] forKey:@"bIsRateAlertDID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)bIsRateAlertDID
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"bIsRateAlertDID"] boolValue];
}

+(void)setBIsShowBanner:(BOOL)bIsShowBanner
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bIsShowBanner] forKey:@"bIsShowBanner"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)bIsShowBanner
{
    BOOL bIsShow =[[[NSUserDefaults standardUserDefaults] objectForKey:@"bIsShowBanner"] boolValue];
    if (!bIsShow) {
        return NO;
    }
    if (bIsShow || ![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS])
        return YES;
    else
        return NO;
    
}

+(void)setUserPassword:(NSString *)userPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:userPassword forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)userPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"];
}

+(void)setUserLogin:(NSString *)userLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:userLogin forKey:@"userLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)userLogin
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userLogin"];
}

+(void)setCurrentLanguage:(NSString *)currentLanguage
{
    [[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:@"currentLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)currentLanguage
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"];
}

+(void)setDataImported:(BOOL)dataImported
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:dataImported] forKey:@"dataImported"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)dataImported
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"dataImported"] boolValue];
}

+(void)setAppBannerCount:(NSNumber *)appBannerCount
{
    [[NSUserDefaults standardUserDefaults] setObject:appBannerCount forKey:@"appBannerCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber*)appBannerCount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"appBannerCount"];
}

+(void)setAppVersion:(NSString *)appVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"appVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)appVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
}

+(void)setAdBannerLink:(NSString *)adBannerLink
{
    [[NSUserDefaults standardUserDefaults] setObject:adBannerLink forKey:@"adBannerLink"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)adBannerLink
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"adBannerLink"];
}


@end
