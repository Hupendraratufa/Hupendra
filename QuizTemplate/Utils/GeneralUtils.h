//
//  GeneralUtils.h
//  Anti-Fat
//
//  Created by Yury Shubin on 05/06/2011.
//  Copyright 2011 EmperorLab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GeneralUtils : NSObject 
{

}
+ (void)roundCornersForImageView:(UIImageView *)imageView
                withCornerRadius:(float)cornerRadius andShadowOffset:(float)shadowOffset;
+(NSDate*)stringToDate:(NSString*)date;
+(NSString*)dateToStringSimple:(NSDate*)date useRussianStyle:(BOOL)ru;
+(NSInteger)daysFrom:(NSDate*)fromDate toDate:(NSDate*)endDate;
+(NSInteger)weeksFrom:(NSDate*)fromDate toDate:(NSDate*)endDate;
+(NSInteger)monthFrom:(NSDate*)fromDate toDate:(NSDate*)endDate;
+(NSInteger)minutesFrom:(NSDate*)fromDate toDate:(NSDate*)endDate;
+(NSString*)dateToString:(NSDate*)date;
+(NSString*)dateToStringWithoutMinutes:(NSDate*)date;
+(NSString*)timeToMinutes:(NSUInteger)seconds;
+(NSString*)timeToString:(NSUInteger)seconds;
+(NSString*)timeToStringWithHours:(NSUInteger)seconds;
+(NSString*)floatToStrWithDigits:(NSUInteger)digits value:(float)value;
+(NSNumber*)floatToNumberWithDigits:(NSUInteger)digits value:(float)value;
+(NSString*)kilosToFunts:(NSString*)kg;
+(NSString*)funtsToKilos:(NSString*)funt;
+(NSString*)centimToInch:(NSString*)cm;
+(NSString*)inchToCentim:(NSString*)inch;

+(NSUInteger)funtsToKg:(NSUInteger)funt;
+(NSUInteger)inchToCm:(NSUInteger)inch;

+(NSString*)floatToString:(float)val removeZero:(BOOL)value;
+(BOOL)dateInFuture:(NSDate*)myDate;
+(BOOL)isDateIsToday:(NSDate*)date;
+(NSDate*)dateForDay:(NSInteger)day fromDate:(NSDate*)startDate;
+(NSDate*)stringToServerDate:(NSString *)date;

@end
