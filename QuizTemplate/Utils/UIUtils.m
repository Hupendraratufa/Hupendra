//
//  UIUtils.m
//  Kitchen
//
//  Created by vlad on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils


+(UIButton*)createBackButtonWithTarget:(id)target selector:(SEL)selector
{
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* img = [UIImage imageNamed:@"b_back@2x.png"];
    UIImageView *imageBackButton = [[[UIImageView alloc] initWithImage:img] autorelease];
    imageBackButton.frame = CGRectMake(5, 5, 46, 29);
    
	backButton.frame = CGRectMake(0, 0, 90, 35);
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    [backButton addSubview:imageBackButton];
    
    
	[backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return backButton;	
    
}

@end
