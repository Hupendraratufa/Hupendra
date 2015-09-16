//
//  GeneralUtils.m
//  Anti-Fat
//
//  Created by Yury Shubin on 05/06/2011.
//  Copyright 2011 EmperorLab. All rights reserved.
//

#import "GeneralUtils.h"
#import "Localization.h"
#import <QuartzCore/QuartzCore.h>
NSDateFormatter* GeneralUtils_dateFormatter = nil;
NSNumberFormatter* GeneralUtils_numberFormatter = nil;
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation GeneralUtils

+(void)initialize
{
	GeneralUtils_dateFormatter = [NSDateFormatter new];
	GeneralUtils_numberFormatter = [NSNumberFormatter new];
}
+ (void)roundCornersForImageView:(UIImageView *)imageView
                withCornerRadius:(float)cornerRadius andShadowOffset:(float)shadowOffset
{
    const float CORNER_RADIUS = cornerRadius;
//    const float BORDER_WIDTH = 1.0;
    const float SHADOW_OFFSET = shadowOffset;
    const float SHADOW_OPACITY = 0.8;
    const float SHADOW_RADIUS = 3.0;
    
    //Our old image now is just background image view with shadow
    UIImageView *backgroundImageView = imageView;
    UIView *superView = backgroundImageView.superview;
    
    //Make wider actual visible rect taking into account shadow
    //offset
    CGRect oldBackgroundFrame = backgroundImageView.frame;
    CGRect newBackgroundFrame = CGRectMake(oldBackgroundFrame.origin.x, oldBackgroundFrame.origin.y, oldBackgroundFrame.size.width + SHADOW_OFFSET, oldBackgroundFrame.size.height + SHADOW_OFFSET);
    [backgroundImageView removeFromSuperview];
    backgroundImageView.frame = newBackgroundFrame;
    
    //Make new UIImageView with rounded corners and put our old image
    CGRect frameForRoundedImageView = CGRectMake(0, 0, oldBackgroundFrame.size.width, oldBackgroundFrame.size.height);
    UIImageView *roundedImageView = [[UIImageView alloc]initWithFrame:frameForRoundedImageView];
    roundedImageView.image = imageView.image;
    [roundedImageView.layer setCornerRadius:CORNER_RADIUS];
//    [roundedImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [roundedImageView.layer setBorderWidth:BORDER_WIDTH];
    [roundedImageView.layer setMasksToBounds:YES];
    
    //Set shadow preferences
    [backgroundImageView setImage:nil];
    [backgroundImageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [backgroundImageView.layer setShadowOpacity:SHADOW_OPACITY];
    [backgroundImageView.layer setShadowRadius:SHADOW_RADIUS];
    [backgroundImageView.layer setShadowOffset:CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET)];
    
    //Add out two image views back to the view hierarchy.
    [backgroundImageView addSubview:roundedImageView];
    [superView addSubview:backgroundImageView];
}
+(BOOL)dateInFuture:(NSDate *)myDate
{
    
    [GeneralUtils_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *firstDate = [[GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:myDate]] dateByAddingTimeInterval:60*60*24];
    NSDate *today = [NSDate date];
    
    NSComparisonResult result = [today compare:firstDate];
    switch (result)
    {
        case NSOrderedAscending:
            return YES;
         
        case NSOrderedDescending:
            return NO;

        default:
            return NO;
    }

}
+ (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) &&
			(components1.day == components2.day));
}
+(BOOL)isDateIsToday:(NSDate*)date
{
   return [self isEqualToDateIgnoringTime:date];
}

+(NSDate*)stringToDate:(NSString *)date
{
    [GeneralUtils_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [GeneralUtils_dateFormatter dateFromString:date];
}


+(NSDate*)stringToServerDate:(NSString *)date
{
    [GeneralUtils_dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [GeneralUtils_dateFormatter dateFromString:date];
}

+(NSDate*)dateForDay:(NSInteger)day fromDate:(NSDate *)startDate
{
    return [NSDate dateWithTimeInterval:day * 24 * 60 * 60 sinceDate:startDate];
}

+(NSInteger)daysFrom:(NSDate*)fromDate toDate:(NSDate*)endDate
{
    //dates needed to be reset to represent only yyyy-mm-dd to get correct number of days between two days.
    [GeneralUtils_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *stDt = [GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:fromDate]];
    NSDate *endDt =  [GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:endDate]];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:stDt  toDate:endDt  options:0];
    return [comps day];
}

+(NSInteger)weeksFrom:(NSDate*)fromDate toDate:(NSDate*)endDate
{
    //dates needed to be reset to represent only yyyy-mm-dd to get correct number of days between two days.
    [GeneralUtils_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *stDt = [GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:fromDate]];
    NSDate *endDt =  [GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:endDate]];
    unsigned int unitFlags = NSWeekCalendarUnit;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:stDt  toDate:endDt  options:0];
    return [comps week];
}

+(NSInteger)monthFrom:(NSDate*)fromDate toDate:(NSDate*)endDate
{
    //dates needed to be reset to represent only yyyy-mm-dd to get correct number of days between two days.
    [GeneralUtils_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *stDt = [GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:fromDate]];
    NSDate *endDt =  [GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:endDate]];
    unsigned int unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:stDt  toDate:endDt  options:0];
    return [comps month];
}

+(NSInteger)minutesFrom:(NSDate*)fromDate toDate:(NSDate*)endDate
{
    //dates needed to be reset to represent only yyyy-mm-dd to get correct number of days between two days.
    [GeneralUtils_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *stDt = [GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:fromDate]];
    NSDate *endDt =  [GeneralUtils_dateFormatter dateFromString:[GeneralUtils_dateFormatter stringFromDate:endDate]];
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:stDt  toDate:endDt  options:0];	
    return [comps minute];
}

+(NSString*)dateToString:(NSDate*)date
{
	[GeneralUtils_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	return [GeneralUtils_dateFormatter stringFromDate:date];
}

+(NSString*)dateToStringSimple:(NSDate*)date useRussianStyle:(BOOL)ru
{
    [GeneralUtils_dateFormatter setLocale:[Localization instance].locale];
    if (ru)
    {
        [GeneralUtils_dateFormatter setDateFormat:@"d MMM"];
    }
    else
    {
        [GeneralUtils_dateFormatter setDateFormat:@"MMM d"];
    }
    
	return [GeneralUtils_dateFormatter stringFromDate:date];
}

+(NSString*)dateToStringWithoutMinutes:(NSDate*)date
{
	NSDateFormatter* formatter = [[NSDateFormatter new] autorelease];
	[formatter setDateFormat:@"EEE, d MMM yyyy 'at' HH"];
//	NSLog(@"%@", [formatter stringFromDate:date]);
	return [formatter stringFromDate:date];
}

+(NSString*)timeToMinutes:(NSUInteger)seconds
{
    NSDateComponents* comps = [[[NSDateComponents alloc] init] autorelease];
	[comps setSecond:seconds];
	NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
	[GeneralUtils_dateFormatter setDateFormat:@"m"];
	return [GeneralUtils_dateFormatter stringFromDate:date];
}

+(NSString*)timeToString:(NSUInteger)seconds
{
	NSDateComponents* comps = [[[NSDateComponents alloc] init] autorelease];
	[comps setSecond:seconds];
	NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
	[GeneralUtils_dateFormatter setDateFormat:@"mm:ss"];
	return [GeneralUtils_dateFormatter stringFromDate:date];
}

+(NSString*)timeToStringWithHours:(NSUInteger)seconds
{
	NSDateComponents* comps = [[[NSDateComponents alloc] init] autorelease];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:seconds];
	NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
	[GeneralUtils_dateFormatter setDateFormat:@"HH:mm:ss"];
	return [GeneralUtils_dateFormatter stringFromDate:date];	
}

+(NSString*)floatToStrWithDigits:(NSUInteger)digits value:(float)value
{
	[GeneralUtils_numberFormatter setMaximumFractionDigits:digits];
	return [GeneralUtils_numberFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
}

+ (NSString *) floatToString:(float) val  removeZero:(BOOL)value
{
    NSString *ret = [NSString stringWithFormat:@"%f", val];

    if (!value)
        return [NSString stringWithFormat:@"%.f", val];;
                     int index = (int)[ret length] - 1;
                     BOOL trim = FALSE;
                     while (
                            ([ret characterAtIndex:index] == '0' ||
                             [ret characterAtIndex:index] == '.')
                            &&
                            index > 0)
                     {
                         index--;
                         trim = TRUE;
                     }
                     if (trim)
                         ret = [ret substringToIndex: index +1];
    return ret;
}

+(NSNumber*)floatToNumberWithDigits:(NSUInteger)digits value:(float)value
{
	[GeneralUtils_numberFormatter setMaximumFractionDigits:digits];
	NSString* str = [GeneralUtils_numberFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
	return [NSNumber numberWithFloat:[str floatValue]];	
}

+(NSString*)funtsToKilos:(NSString *)funt
{
    float kg = [funt floatValue] * 0.453f;
    return [NSString stringWithFormat:@"%.2f",kg]; 
}

+(NSUInteger)funtsToKg:(NSUInteger)funt
{
    float kg = funt * 0.453f;
    return kg;
}


+(NSString*)kilosToFunts:(NSString *)kg 
{
    float funt = [kg floatValue] * 2.2f;
    return [NSString stringWithFormat:@"%.2f",funt];
}

+(NSString*)inchToCentim:(NSString *)inch
{
    float cm = [inch floatValue] * 2.54f;
    return [NSString stringWithFormat:@"%.2f",cm];
}

+(NSUInteger)inchToCm:(NSUInteger)inch
{
    float cm = inch * 2.54f;
    return cm;
}

+(NSString*)centimToInch:(NSString *)cm
{
    float inch = [cm floatValue] * 0.3937f;
    return [NSString stringWithFormat:@"%.2f",inch];
}
@end

