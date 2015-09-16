//
//  UIColor+NewColor.m
//  Anti-Fat
//
//  Created by Vladislav on 9/13/12.
//  Copyright (c) 2012 EmperorLab. All rights reserved.
//

#import "UIColor+NewColor.h"

@implementation UIColor (NewColor)
+(UIColor*)myGreenColor
{
    return [UIColor colorWithRed:41./255. green:185./255. blue:13./255. alpha:1.0];
}

+(UIColor*)myGreyColor
{
    return [UIColor colorWithRed:144./255. green:125./255. blue:116./255. alpha:1.0];
}

+(UIColor *)randomColor{
    UIColor *color;
    float randomRed = rand()%255;//3:you can write any number as you wish...
    float randomGreen =rand()%255;//2:you can write any number as you wish...
    float randomBlue =rand()%255;//4:you can write any number as you wish...
    color= [UIColor colorWithRed:randomRed/255. green:randomGreen/255. blue:randomBlue/255. alpha:1.0];
    return color;
}

+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

@end
