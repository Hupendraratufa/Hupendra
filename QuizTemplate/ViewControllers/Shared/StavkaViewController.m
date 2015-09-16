//
//  StavkaViewController.m
//  GuessTheCar2
//
//  Created by Uladzislau Yasnitski on 20/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "StavkaViewController.h"
#import "Localization.h"
#import "UIFont+CustomFont.h"
#import "UIColor+NewColor.h"
#import "Localytics.h"

#define minBid 25
#define medBid 50
#define higBid 75
#define vipBid 100

@interface StavkaViewController ()
{
    NSInteger maxBid;
}
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn25;
@property (weak, nonatomic) IBOutlet UIButton *btn50;
@property (weak, nonatomic) IBOutlet UIButton *btn75;
@property (weak, nonatomic) IBOutlet UIButton *btn100;
@end

@implementation StavkaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMaxBit:(NSInteger)bid
{
    if (self = [self initWithNibName:nibNameOrNil bundle:nil])
    {
        // Custom initialization
     
        maxBid = bid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _lbTitle.text = [[Localization instance] stringWithKey:@"txt_makeBid"];
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [UIColor darkGrayColor];
    _lbTitle.font = [UIFont myFontSize:isPad ? 40 : 25];
    _lbTitle.adjustsFontSizeToFitWidth = YES;
    
    
    
    [self configLabel:_btn25 withText:[[Localization instance] stringWithKey:@"txt_makeMinimum"] bid:minBid];
    [self configLabel:_btn50 withText:[[Localization instance] stringWithKey:@"txt_makeMedium"] bid:medBid];
    [self configLabel:_btn75 withText:[[Localization instance] stringWithKey:@"txt_makeHigh"] bid:higBid];
    [self configLabel:_btn100 withText:[[Localization instance] stringWithKey:@"txt_makeVip"] bid:vipBid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configLabel:(UIButton*)btn withText:(NSString*)text bid:(NSInteger)bid
{
  
    
    [btn setTitle:text forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setUserInteractionEnabled:maxBid < bid ? NO : YES];
    [btn.titleLabel setFont:[UIFont myFontSize:isPad ? 30 : 18]];

    [btn setTitleColor:(maxBid < bid ? [UIColor grayColor] : [UIColor whiteColor]) forState:UIControlStateNormal];
    
    btn.tag = bid;
}

- (IBAction)didStavka:(UIButton *)sender {
    
    if (sender.tag==0) {
        [Localytics tagEvent:@"Every time user chooses \"25 Coins Game\""];
    }else if (sender.tag==1) {
         [Localytics tagEvent:@"Every time user chooses \"50 Coins Game\""];
    }else if (sender.tag==2) {
         [Localytics tagEvent:@"Every time user chooses \"75 Coins Game\""];
    }else if (sender.tag==3) {
         [Localytics tagEvent:@"Every time user chooses \"100 Coins Game\""];
    }
    [_delegate stavkaViewDidBid:sender.tag];
}
- (IBAction)didClose:(id)sender {
     [Localytics tagEvent:@"Every time user closes dialog without choosing an option"];
    [_delegate stavkaViewDidClose];
}
@end
