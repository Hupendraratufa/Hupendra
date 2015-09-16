//
//  UIViewController+UpdateCoins.h
//  KatyaEnergy
//
//  Created by Vladislav on 8/5/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UpdateCoins)

-(void)updateCoinsForLabel:(UILabel*)lb withAnimation:(BOOL)animation;
-(void)updateGameCenterPointsForLabel:(UILabel*)lb withAnimation:(BOOL)animation;
//-(void)doRasePointsLabel:(UILabel*)lb;
@end
