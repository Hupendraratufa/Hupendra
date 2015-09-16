//
//  StavkaViewController.h
//  GuessTheCar2
//
//  Created by Uladzislau Yasnitski on 20/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StavkaViewControllerDelegate <NSObject>

-(void)stavkaViewDidBid:(NSInteger)bid;
-(void)stavkaViewDidClose;

@end
@interface StavkaViewController : UIViewController
@property (nonatomic, assign) id <StavkaViewControllerDelegate> delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMaxBit:(NSInteger)bid;
@end
