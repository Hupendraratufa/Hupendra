//
//  UIColor+NewColor.h
//  Anti-Fat
//
//  Created by Vladislav on 9/13/12.
//  Copyright (c) 2012 EmperorLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NewColor)
+(UIColor*)myGreenColor;
+(UIColor*)myGreyColor;
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
+(UIColor*)randomColor;
@end
