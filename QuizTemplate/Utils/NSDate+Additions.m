//
//  NSDate+Additions.m
//  AudioQuiz
//
//  Created by Vladislav on 5/29/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "NSDate+Additions.h"
#import "AppSettings.h"

@implementation NSDate (Additions)
+(NSDate*)ServerDate
{
    return [NSDate date];
//    NSDate *date = [[AppSettings instanse] serverDate];
//    if (!date)
//        date = [NSDate date];
//    return date;
}
@end
