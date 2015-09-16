//
//  MainViewController_iPad.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 20/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "MainViewController_iPad.h"
#import "GameViewControllerOffline_iPad.h"
#import "GameViewControllerOnline_iPad.h"
#import "AppReskManager.h"
#import "AppSettings.h"
#import "MKStoreManager.h"
@interface MainViewController_iPad ()

@end

@implementation MainViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    
    [self.btnStartGame setImage:[UIImage imageNamed:[NSString stringWithFormat:@"start-%@-ipad.png", currentLang]] forState:UIControlStateNormal];
    [self.btnStartOnlineGame setImage:[UIImage imageNamed:[NSString stringWithFormat:@"online-%@-ipad.png",currentLang]] forState:UIControlStateNormal];
    
    [self.btnLeaderBoard setBackgroundImage:[UIImage imageNamed:@"record-ipad.png"] forState:UIControlStateNormal];
    [self.btnRemoveAds setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ads-%@-ipad.png", currentLang]] forState:UIControlStateNormal];
    [self.btnDidCoins setBackgroundImage:[UIImage imageNamed:@"money-ipad.png"] forState:UIControlStateNormal];
    
    [self.btnInfo setBackgroundImage:[UIImage imageNamed:@"i.png"] forState:UIControlStateNormal];
    
    if(![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS])
    {
        [[AppReskManager instance]showAdmobBanner];
    }
    
    self.lbStartGame.font = [UIFont myFontSize:15];
    self.lbStartOnline.font = [UIFont myFontSize:12];
   // self.lbCoins.font = [UIFont myFontSize:24];
   // self.lbPoints.font = [UIFont myFontSize:24];

}

-(CGRect)focusImageFrame
{
    return CGRectMake(0, self.imageTopView.frame.origin.y + self.imageTopView.frame.size.height, self.view.frame.size.width, 260);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didStartOnlineGame:(id)sender {
    
    
    if (![[GameModel sharedInstance] isGameCenterUserAuthenticated])
    {
        return;
    }
    
    Person *person = [[Person allObjects] lastObject];
    StavkaViewController *vc = [[StavkaViewController alloc] initWithNibName:@"StavkaViewController_iPad"  bundle:nil withMaxBit:[person.allPersonPoints integerValue]];
    vc.delegate = self;
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [navVc setNavigationBarHidden:YES];
    
    [self presentPopupViewController:navVc animationType:MJPopupViewAnimationSlideLeftRight];
    
}

-(void)startOfflineGame
{
    GameViewControllerOffline_iPad *vc = [[GameViewControllerOffline_iPad alloc] initWithNibName:@"GameViewControllerOffline_iPad" bundle:nil];
    
    if(![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS])
    {
        [[AppReskManager instance]showAdmobBanner];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)startGameWithQuestionIds:(NSString*)ids isServer:(BOOL)isServer
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    GameViewControllerOnline_iPad *vc = [[GameViewControllerOnline_iPad alloc] initWithNibName:@"GameViewControllerOnline_iPad" bundle:nil questionIds:ids];
    [vc setIsHost:isServer];
    [vc setPlayerBid:self.playerBid];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
