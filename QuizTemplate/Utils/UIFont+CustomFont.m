//
//  UIFont+CustomFont.m
//  TanksQuiz
//
//  Created by Vladislav on 9/12/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)

+(UIFont*)myFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"TOONISH" size:size];
}

+ (UIFont*)fontWithMaxSize:(CGFloat)maxSize constrainedToSize:(CGSize)labelSize forText:(NSString*)text {
    
    UIFont* font = [UIFont myFontSize:maxSize];
    CGFloat minSize = 5;
    CGSize constraintSize = CGSizeMake(labelSize.width, MAXFLOAT);
    NSRange range = NSMakeRange(minSize, maxSize);
    
    int fontSize = 0;
    for (NSInteger i = maxSize; i > minSize; i--)
    {
        fontSize = ceil(((float)range.length + (float)range.location) / 2.0);
        
        font = [font fontWithSize:fontSize];
        CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        if (size.height <= labelSize.height)
            range.location = fontSize;
        else
            range.length = fontSize - 1;
        
        if (range.length == range.location)
        {
            font = [font fontWithSize:range.location];
            break;
        }
    }
    
    return font;
}

@end
