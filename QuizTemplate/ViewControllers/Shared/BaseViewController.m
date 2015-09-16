//
//  BaseViewController.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+UpdateCoins.h"
#import "Person.h"
#import "Appirater.h"
#import "AppSettings.h"
#import "Model.h"
#import "MainViewController.h"
#import "UIColor+NewColor.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerStep:) name:@"CoinTimerStep" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOneCoin) name:@"AddOneCoinNotification" object:nil];
        
    }
    return self;
}

- (void)getUpdatedPoints:(NSNotification*)notifyObj
{
	NSNumber *tapPoints = notifyObj.object;
    Person *person = [[Person allObjects] lastObject];
    
    person.cointsTapJoy = tapPoints;
    
    [DELEGATE saveContext];
    
    [self updateCoinsForLabel:_lbCoins withAnimation:YES];
    
}

-(void)removeBanner
{
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   
    [_btntopCoins setTitle:nil forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor colorWith8BitRed:161 green:230 blue:229 alpha:1];
    
    _lbCoins.text = nil;
    _lbCoins.textColor = [UIColor whiteColor];
    _lbCoins.textAlignment = NSTextAlignmentCenter;
    _lbCoins.adjustsFontSizeToFitWidth = YES;
   // [_lbCoins setFont:[UIFont myFontSize:isPad ? 24 : 12]];
    
    //_lbCoins.backgroundColor=[UIColor redColor];
    
    
    _lbPoints.text = nil;
    //_lbPoints.textColor = [UIColor whiteColor];
//    _lbPoints.textColor=[UIColor blackColor];
    _lbPoints.textAlignment = NSTextAlignmentCenter;
    _lbPoints.adjustsFontSizeToFitWidth = YES;
   // [_lbPoints setFont:[UIFont myFontSize:isPad ? 24 : 12]];
    _coinsProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(_lbCoins.frame.origin.x, _lbCoins.frame.origin.y + _lbCoins.frame.size.height, _lbCoins.frame.size.width, 2)];
    [_coinsProgress setProgressTintColor:[UIColor myGreenColor]];
    [self.view addSubview:_coinsProgress];
    
}

-(void)createADBannerView
{
    if (self.admobBannerView)
        [self.admobBannerView removeFromSuperview];
    
    GADAdSize adSize = kGADAdSizeSmartBannerPortrait;
    self.admobBannerView = [[GADBannerView alloc] initWithAdSize:adSize] ;
    CGRect bannerFrame = self.admobBannerView.frame;
    
    bannerFrame.origin = CGPointMake(0, self.view.frame.size.height);
    self.admobBannerView.frame = bannerFrame;
    
    // 3
    
    self.admobBannerView.adUnitID = AdMob_ID;
    
    self.admobBannerView.rootViewController = self;
    self.admobBannerView.delegate = self;
    
    // 4
    [self.view addSubview:self.admobBannerView];
    [self.admobBannerView loadRequest:[GADRequest request]];
    
    
    [self updateFrameWithAdmobBanner];
  
}

-(void)updateFrameWithAdmobBanner
{
    // template
}


-(IBAction)didCoins
{
    
    [Localytics tagEvent:@"Every time Store / Coins button is pressed / opened"];
    
    GetCoinsViewController *vc = [[GetCoinsViewController alloc] initWithNibName:isPad ? @"GetCoinsViewController_iPad" : @"GetCoinsViewController_iPhone" bundle:nil];
    vc.delegate = self;
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [navVc setNavigationBarHidden:YES];
    
    [self presentPopupViewController:navVc animationType:MJPopupViewAnimationSlideRightRight dismissed:^{
        [self updateCoinsForLabel:_lbCoins withAnimation:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timerStep:(NSNotification*)notification
{
    Person *person = [[Person allObjects] lastObject];
    NSInteger coins = [person.coinsEarned integerValue];
    
    if(coins>=125){
         [_coinsProgress setProgress:120];
    }else {
        NSDictionary *dic = notification.userInfo;
        if (![dic count])
            return;
        NSInteger timerValue = [[dic objectForKey:@"timerValue"] integerValue];
        [_coinsProgress setProgress:(float)timerValue / 120];
    }

}
-(void)addOneCoin
{
    [self updateCoinsForLabel:_lbCoins withAnimation:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCoinsForLabel:_lbCoins withAnimation:NO];
    [self updateGameCenterPointsForLabel:_lbPoints withAnimation:YES];
 
       
    
    if ([[Model instance] bIsShowBanner])
    {
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        if(appDelegate.isAdS){
            appDelegate.isAdS=NO;
        }else {
            [self createADBannerView];
        }
    }
    else
    {
        [self removeBanner];
    }
    
}

-(void)showNoCoinsAlert
{
      AlertViewController *alert = [[AlertViewController alloc] initWithMessage:[[Localization instance] stringWithKey:@"txt_noCoins"] button1Title:[[Localization instance] stringWithKey:@"txt_buyCoins"] button2Title:[[Localization instance] stringWithKey:@"txt_watchVideo"]];
    alert.tag = 666;
    alert.delegate = self;
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:alert];
    [navVc setNavigationBarHidden:YES];

    [self presentPopupViewController:navVc animationType:MJPopupViewAnimationFade];
}



-(void)showRateAlert
{
     [Appirater setDelegate:self];
    [Appirater showPrompt];
   
}

-(void)appiraterDidOptToRate:(Appirater *)appirater
{
    [AppSettings  setAppIsRated:YES];
    
    Person *person = [[Person allObjects] lastObject];
    person.coinsBought = [NSNumber numberWithInteger:[person.coinsBought integerValue] + 50];
    [DELEGATE saveContext];
    
    [self updateCoinsForLabel:_lbCoins withAnimation:YES];
}

//-(void)alertControllerDidClose:(AlertViewController *)alert
//{
//  
//    if (alert.tag == 666)
//    {
//        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//        [self performSelector:@selector(didCoins) withObject:nil afterDelay:1];
//        
//    }
//    else
//        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//    
//    
//}
//

-(void)alertControllerDidClose:(AlertViewController *)alert withButtonTag:(NSInteger)btnTag
{
    
    if (alert.tag == 666)
    {
        if (btnTag == 300)
        {
            
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
            [self performSelector:@selector(didCoins) withObject:nil afterDelay:1.0];
        }
        else
        {
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
            NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gameDemo" ofType:@"mov"]];
            MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
            [self presentMoviePlayerViewControllerAnimated:movieController];
            [movieController.moviePlayer play];
        }
    }
    else
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    
}



-(void)alertDidDismissed:(AlertViewController *)alert
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void)getCoinsDismissed
{
    [self updateCoinsForLabel:_lbCoins withAnimation:YES];
    
    if (![[Model instance] bIsShowBanner])
    {
        [self removeBanner];
    }
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}

-(IBAction)didDismissView:(id)sender {

}

@end
