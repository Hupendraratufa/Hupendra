//
//  UIFont+CustomFont.h
//  TanksQuiz
//
//  Created by Vladislav on 9/12/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (CustomFont)
+(UIFont*)myFontSize:(CGFloat)size;

+ (UIFont*)fontWithMaxSize:(CGFloat)maxSize constrainedToSize:(CGSize)labelSize forText:(NSString*)text;
@end
