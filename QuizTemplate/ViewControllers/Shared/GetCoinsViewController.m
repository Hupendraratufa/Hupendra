//
//  GetCoinsViewController.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 14/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GetCoinsViewController.h"
#import "MKStoreManager.h"
#import "MBProgressHUD.h"
#import "UIViewController+MJPopupViewController.h"
#import "AppSettings.h"
#import "Localization.h"
#import "UIFont+CustomFont.h"
#import "Person.h"
#import "BaseViewController.h"
#import <AdColony/AdColony.h>

@interface GetCoinsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgFon;
@property (weak, nonatomic) IBOutlet UIButton *btn_300;
@property (weak, nonatomic) IBOutlet UIButton *btn_750;
@property (weak, nonatomic) IBOutlet UIButton *btn_1800;
@property (weak, nonatomic) IBOutlet UIButton *btn_3000;
@property (weak, nonatomic) IBOutlet UIButton *btnTapJoy;
@property (nonatomic, weak) IBOutlet UIButton *btnRestore;
@property (nonatomic, weak) IBOutlet UILabel *restore;
@property (nonatomic, weak) IBOutlet UILabel *restoreSub;
- (IBAction)didDismiss:(id)sender;
@end

@implementation GetCoinsViewController

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
    _imgFon.image = [UIImage imageNamed:[NSString stringWithFormat:@"IAP_%@.jpg", [AppSettings currentLanguage]]];

    _restore.text = [[Localization instance] stringWithKey:@"txt_restoreAds"];
    _restore.font = [UIFont myFontSize:isPad ? 24 : 12];
    _restore.textColor = [UIColor whiteColor];
    _restore.textAlignment = NSTextAlignmentCenter;
    
    _restoreSub.text = [[Localization instance] stringWithKey:@"txt_ads"];
    _restoreSub.font = [UIFont myFontSize:isPad ? 20 : 10];
    _restoreSub.textColor = [UIColor whiteColor];
    _restoreSub.textAlignment = NSTextAlignmentCenter;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)did_300:(id)sender {
    [Localytics tagEvent:@"Every time user presses \"+300\" IAP"];
    [self purchaseForItem:APP_DONATE_300_POINTS];
}

- (IBAction)did_750:(id)sender {
    [Localytics tagEvent:@"Every time user presses \"+750\" IAP"];
    [self purchaseForItem:APP_DONATE_750_POINTS];
}
- (IBAction)did_1800:(id)sender {
     [Localytics tagEvent:@"Every time user presses \"+1800\" IAP"];
    [self purchaseForItem:APP_DONATE_1800_POINTS];
}
- (IBAction)did_3000:(id)sender {
     [Localytics tagEvent:@"Every time user presses \"+3000\" IAP"];
    [self purchaseForItem:APP_DONATE_3000_POINTS];
}
- (IBAction)didTapJoy:(id)sender {
    
    [Localytics tagEvent:@" Every time user presses \"Watch A Free Video\""];
   
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isAdS=YES;
    
    [AdColony playVideoAdForZone:@"vz813738b46300478ab4" withDelegate:nil];
    
    Person *person = [[Person allObjects] lastObject];
    person.coinsBought = [NSNumber numberWithInteger:[person.coinsBought integerValue] + 50];
    [DELEGATE saveContext];
}

-(IBAction)didRestore
{
    [Localytics tagEvent:@"Every time user presses \"Restore Purchase\""];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
       
        [self feyturePurshased:nil];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)feyturePurshased:(NSString*)feature
{
    NSInteger coins = 0;
    if ([feature isEqualToString:APP_DONATE_300_POINTS])
        coins = 300;
    else if ([feature isEqualToString:APP_DONATE_750_POINTS])
        coins = 750;
    else if ([feature isEqualToString:APP_DONATE_1800_POINTS])
        coins = 1800;
    else if ([feature isEqualToString:APP_DONATE_3000_POINTS])
        coins = 3000;
    else if ([feature isEqualToString:APP_REMOVE_ADS])
    {
        UIViewController *top = DELEGATE.navigationController.topViewController;
        if ([[top class] isSubclassOfClass:[BaseViewController class]])
        {
            BaseViewController *vc = (BaseViewController*)top;
            [vc removeBanner];
        }
    }
    Person *p = [[Person allObjects] lastObject];
    p.coinsBought = [NSNumber numberWithInteger:[p.coinsBought integerValue] + coins];
    [DELEGATE saveContext];
    
    [self didDismiss:nil];
}

-(void)purchaseForItem:(NSString*)str
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[MKStoreManager sharedManager] buyFeature:str onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self feyturePurshased:purchasedFeature];
        
    } onCancelled:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)didDismiss:(id)sender {
     [Localytics tagEvent:@"Every time user closes store"];
    [_delegate getCoinsDismissed];
}
@end
