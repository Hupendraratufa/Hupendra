//
//  AppSettings.h
//  AgeOfDeath
//
//  Created by Vladislav on 1/3/13.
//
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject
{
}

+(void)setAdBannerLink:(NSString *)adBannerLink;
+(NSString*)adBannerLink;

+(void)setAppVersion:(NSString *)appVersion;
+(NSString*)appVersion;

+(void)setDataImported:(BOOL)dataImported;
+(BOOL)dataImported;

+(void)setCurrentLanguage:(NSString *)currentLanguage;
+(NSString*)currentLanguage;

+(void)setUserLogin:(NSString *)userLogin;
+(NSString*)userLogin;

+(void)setUserPassword:(NSString *)userPassword;
+(NSString*)userPassword;

+(void)setAppIsRated:(BOOL)isRated;
+(BOOL)appIsRated;
@end
