                                                           //
//  MainViewController_iPhone.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "MainViewController_iPhone.h"
#import "GameViewControllerOffline_iPhone.h"
#import "GameViewControllerOnline_iPhone.h"
#import "AppReskManager.h"
#import "AppSettings.h"
#import "MKStoreManager.h"

@interface MainViewController_iPhone ()

@end

@implementation MainViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (isPhone)
        nibNameOrNil = [nibNameOrNil stringByAppendingString:@"_4"];
    else
        nibNameOrNil = [nibNameOrNil stringByAppendingString:@"_5"];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *currentLang = [AppSettings currentLanguage];
    
    [self.btnStartGame setImage:[UIImage imageNamed:[NSString stringWithFormat:@"start-%@-iphone.png", currentLang]] forState:UIControlStateNormal];
    [self.btnStartOnlineGame setImage:[UIImage imageNamed:[NSString stringWithFormat:@"online-%@-iphone.png",currentLang]] forState:UIControlStateNormal];
    
    [self.btnLeaderBoard setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    [self.btnRemoveAds setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ads-%@.png", currentLang]] forState:UIControlStateNormal];
    [self.btnDidCoins setImage:[UIImage imageNamed:@"money.png"] forState:UIControlStateNormal];
    
    [self.btnInfo setImage:[UIImage imageNamed:@"i.png"] forState:UIControlStateNormal];
    
    if(![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS])
    {
        [[AppReskManager instance]showAdmobBanner];
    }
    
    self.lbStartGame.font = [UIFont myFontSize:15];
    self.lbStartOnline.font = [UIFont myFontSize:12];
    //self.lbCoins.font = [UIFont myFontSize:12];
    //self.lbPoints.font = [UIFont myFontSize:12];
    
}

-(CGRect)focusImageFrame
{
    return CGRectMake(5, self.imageTopView.frame.origin.y + self.imageTopView.frame.size.height, 310, 105);
}

- (IBAction)didStartOnlineGame:(id)sender {
    
    
    [Localytics tagEvent:@"Every time Online Competition Button is Pressed / Opened"];
    
    if (![[GameModel sharedInstance] isGameCenterUserAuthenticated])
    {
        return;
    }
    
    Person *person = [[Person allObjects] lastObject];
    StavkaViewController *vc = [[StavkaViewController alloc] initWithNibName:@"StavkaViewController_iPhone"  bundle:nil withMaxBit:[person.allPersonPoints integerValue]];
    vc.delegate = self;
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [navVc setNavigationBarHidden:YES];
    
    [self presentPopupViewController:navVc animationType:MJPopupViewAnimationSlideLeftRight];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)startOfflineGame
{
    
    [Localytics tagEvent:@"Every time Start Game Button is Pressed / Opened"];
    if(![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS])
{
    [[AppReskManager instance]showAdmobBanner];
}
    
    GameViewControllerOffline_iPhone *vc = [[GameViewControllerOffline_iPhone alloc] initWithNibName:@"GameViewControllerOffline_iPhone" bundle:nil];
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)startGameWithQuestionIds:(NSString*)ids isServer:(BOOL)isServer
{
 
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    GameViewControllerOnline_iPhone *vc = [[GameViewControllerOnline_iPhone alloc] initWithNibName:@"GameViewControllerOnline_iPhone" bundle:nil questionIds:ids];
    [vc setIsHost:isServer];
    [vc setPlayerBid:self.playerBid];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
