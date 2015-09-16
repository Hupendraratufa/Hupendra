//
//  BaseViewController.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+CustomFont.h"
#import "UIViewController+UpdateCoins.h"
#import "GetCoinsViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "AlertViewController.h"
#import "Appirater.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Localytics.h"

@interface BaseViewController : UIViewController <GADBannerViewDelegate, GetCoinsViewDelegate, AlertViewControllerDelegate, AppiraterDelegate>

@property (nonatomic, strong) UIProgressView *coinsProgress;
@property (nonatomic, weak) IBOutlet UILabel *lbCoins;
@property (nonatomic, weak) IBOutlet UILabel *lbPoints;
@property (nonatomic, weak) IBOutlet UIButton *btnBack;
@property (nonatomic, weak) IBOutlet UIButton *btntopCoins;
@property (nonatomic, weak) IBOutlet UIImageView *imageTopView;
@property (nonatomic, weak) IBOutlet UIImageView *imageBackgroundFon;
@property (nonatomic, strong) GADBannerView *admobBannerView;

-(IBAction)didCoins;
-(void)showRateAlert;
-(void)showNoCoinsAlert;
-(void)removeBanner;
-(IBAction)didDismissView:(id)sender;


@end
