//
//  UIViewController+UpdateCoins.m
//  KatyaEnergy
//
//  Created by Vladislav on 8/5/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "UIViewController+UpdateCoins.h"
#import "Person.h"
#import "UIColor+NewColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIViewController (UpdateCoins)

-(void)updateCoinsForLabel:(UILabel *)lb withAnimation:(BOOL)animation
{
    Person *person = [[Person allObjects] lastObject];
    lb.adjustsFontSizeToFitWidth = YES;
    lb.minimumScaleFactor = 0.5;
    
    if (animation)
    {
        CAKeyframeAnimation *scaleAnimation =
        [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.delegate = self;
        
        CATransform3D transform = CATransform3DMakeScale(1.3, 1.3, 1); // Scale in x and y
        
        [scaleAnimation setValues:[NSArray arrayWithObjects:
                                   // [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                   [NSValue valueWithCATransform3D:transform],
                                   [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                   nil]];
        
        [scaleAnimation setDuration: .5];
        
        CATransition *animation = [CATransition animation];
        animation.duration = .5;
        animation.type = kCATransitionFade;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [lb.layer addAnimation:scaleAnimation forKey:@"scaleText"];
        [lb.layer addAnimation:animation forKey:@"changeTextTransition"];
        NSInteger oldValue = [lb.text integerValue];
        NSInteger newValue = [person.allPersonPoints integerValue];
        UIColor *color = [UIColor whiteColor];
        if (newValue > oldValue)
            color = [UIColor myGreenColor];
        else if (newValue < oldValue)
            color = [UIColor redColor];
        
        
        lb.text = [person.allPersonPoints stringValue];
        
        [UIView transitionWithView:lb duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [lb setTextColor:color];
            
        } completion:^(BOOL finished) {
            
            [lb setTextColor:[UIColor whiteColor]];
        }];
    }
    else
    {
        if ([person.allPersonPoints integerValue] > 0)
        {
            lb.text = [person.allPersonPoints stringValue];
            lb.textColor = [UIColor whiteColor];
        }
        else if ([person.allPersonPoints integerValue] <= 0)
        {
            lb.text = [person.allPersonPoints stringValue];
            lb.textColor = [UIColor redColor];
        }
    }
}

-(void)updateGameCenterPointsForLabel:(UILabel *)lb withAnimation:(BOOL)animation
{
    Person *person = [[Person allObjects] lastObject];
    lb.adjustsFontSizeToFitWidth = YES;
    lb.minimumScaleFactor = 0.5;
    
    if (animation)
    {
        CAKeyframeAnimation *scaleAnimation =
        [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.delegate = self;
        
        CATransform3D transform = CATransform3DMakeScale(1.3, 1.3, 1); // Scale in x and y
        
        [scaleAnimation setValues:[NSArray arrayWithObjects:
                                   // [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                   [NSValue valueWithCATransform3D:transform],
                                   [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                   nil]];
        
        [scaleAnimation setDuration: .5];
        
        CATransition *animation = [CATransition animation];
        animation.duration = .5;
        animation.type = kCATransitionFade;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [lb.layer addAnimation:scaleAnimation forKey:@"scaleText"];
        [lb.layer addAnimation:animation forKey:@"changeTextTransition"];
        NSInteger oldValue = [lb.text integerValue];
        NSInteger newValue = [person.points integerValue];
        
        UIColor *color = [UIColor whiteColor];
        if (newValue > oldValue)
            color = [UIColor myGreenColor];
        else if (newValue < oldValue)
            color = [UIColor redColor];
        
        lb.text = [person.points stringValue];
        
        [UIView transitionWithView:lb duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [lb setTextColor:color];
            
        } completion:^(BOOL finished) {
            
            [lb setTextColor:[UIColor whiteColor]];
        }];
    }
    else
    {
        if ([person.points integerValue] > 0)
        {
            lb.text = [person.points stringValue];
            lb.textColor = [UIColor whiteColor];
        }
        else if ([person.points integerValue] <= 0)
        {
            lb.text = [person.points stringValue];
            lb.textColor = [UIColor redColor];
        }
    }

}


//-(void)doRaseAnimationLabel:(UILabel *)label withText:(NSString *)newText
//{
//
//    CAKeyframeAnimation *scaleAnimation =
//    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    scaleAnimation.delegate = self;
//    
//    CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1); // Scale in x and y
//    
//    [scaleAnimation setValues:[NSArray arrayWithObjects:
//                               // [NSValue valueWithCATransform3D:CATransform3DIdentity],
//                               [NSValue valueWithCATransform3D:transform],
//                               [NSValue valueWithCATransform3D:CATransform3DIdentity],
//                               nil]];
//    
//    [scaleAnimation setDuration: .5];
//    
//    CATransition *animation = [CATransition animation];
//    animation.duration = .5;
//    animation.type = kCATransitionFade;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    
//    [label.layer addAnimation:scaleAnimation forKey:@"scaleText"];
//    [label.layer addAnimation:animation forKey:@"changeTextTransition"];
//    label.text = newText;
//    
//    [UIView transitionWithView:label duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        [label setTextColor:[UIColor myGreenColor]];
//        
//    } completion:^(BOOL finished) {
//        
//        [label setTextColor:[UIColor darkGrayColor]];
//    }];
//    
//}

@end
