//
//  MainViewController.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "MainViewController.h"
#import "Model.h"
#import "MBProgressHUD.h"
#import "Localization.h"
#import "UIColor+NewColor.h"
#import "UIFont+CustomFont.h"
#import "Person.h"
#import "Question.h"
#import "PlayingPerson.h"
#import "MKStoreManager.h"
#import "GameModel.h"
#import "AppSettings.h"
#import "GetBannersRequest.h"
#import "AppReskManager.h"



@interface MainViewController () {
    
    int timercount1;
    BOOL isAds;
    BOOL isTimer;
    NSTimer *timer;
    BOOL isFirstTime;
}

@property (nonatomic, strong) SGFocusImageFrame *focusImageView;
@property (nonatomic, strong) UILabel  *lblTimeTimer;

@end

@implementation MainViewController
@synthesize viewAds;
@synthesize adsTimer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [GameModel sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOnlineGame:) name:@"startOnlineGame" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureBannerAds:) name:@"BannerLoaderComplite" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAdd) name:@"removeTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdd) name:@"showTimer" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    isAds = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Model instance] initializeDataWithSucces:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } onFailed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    _playerBid = 25;
    
    if ([[Model instance] bIsShowBanner])
    {
        
        
    }
    else
    {
        [self removeBanner];
    }
    
    /*hh*/
    viewAds=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height )];
    // viewAds.backgroundColor=[UIColor grayColor];
    //viewAds.alpha=0.8;
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10,180,300,300)];
    [viewAds addSubview:imgView];
    //  [imgView setBackgroundColor:[UIColor redColor]];
    [imgView setImage:[UIImage imageNamed:@"banner_img.png"]];
    [self.view addSubview:viewAds];
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:viewAds];
    
    UIButton *btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCross setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, 30, 30)];
    
    [btnCross addTarget:self action:@selector(closeAdView) forControlEvents:UIControlEventTouchUpInside];
    
    [btnCross setImage:[UIImage imageNamed:@"cross_image.png"] forState:UIControlStateNormal];
    
    [btnCross setBackgroundColor:[UIColor greenColor]];
    [viewAds addSubview:btnCross];
    adsTimer=[[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+5,imgView.frame.origin.y+imgView.frame.size.height-35, 100, 25)];
    [viewAds addSubview:adsTimer];
    adsTimer.text=@"10:10";
    adsTimer.textColor=[UIColor whiteColor];
    adsTimer.backgroundColor=[UIColor clearColor];
    viewAds.hidden=YES;
    ///
    _lbStartGame.text = [[[Localization instance] stringWithKey:@"txt_startOffline"] uppercaseString];
    _lbStartGame.textAlignment = NSTextAlignmentCenter;
    _lbStartGame.textColor = [UIColor whiteColor];
    _lbStartGame.highlightedTextColor = [UIColor lightGrayColor];
    _lbStartGame.font = [UIFont myFontSize:15];
    
    _lbStartOnline.text = [[[Localization instance] stringWithKey:@"txt_startOnline"] uppercaseString];
    _lbStartOnline.textAlignment = NSTextAlignmentCenter;
    _lbStartOnline.textColor = [UIColor whiteColor];
    _lbStartOnline.highlightedTextColor = [UIColor lightGrayColor];
    _lbStartOnline.font = [UIFont myFontSize:12];
    
    
    //    [_btnRemoveAds setTitle:[[Localization instance] stringWithKey:@"txt_adFree"] forState:UIControlStateNormal];
    //    [_btnRemoveAds setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //    [_btnStartGame setTitle:nil forState:UIControlStateNormal];
    //    [_btnStartOnlineGame setTitle:nil forState:UIControlStateNormal];
    //    [_btnDidCoins setTitle:nil forState:UIControlStateNormal];
    //    [_btnLeaderBoard setTitle:nil forState:UIControlStateNormal];
    //    [_btnRemoveAds setTitle:nil forState:UIControlStateNormal];
    //    [_btnInfo setTitle:nil forState:UIControlStateNormal];
    
    
    
    NSString *msg = [NSString stringWithFormat:[[Localization instance] stringWithKey:@"txt_everyMinuteCoins"],isPad ? @"iPad" : @"iPhone"];
    
    AlertViewController *alert = [[AlertViewController alloc] initWithMessage:msg button1Title:@"OK" button2Title:nil];
    alert.delegate = self;
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:alert];
    [navVc setNavigationBarHidden:YES];
    
    [self presentPopupViewController:navVc animationType:MJPopupViewAnimationFade];
    
    NSArray *bannersOfflineItems = [[Model instance] offlineBanners];
    [self showImageFocusViewWithBanners:bannersOfflineItems];
    
    //isAds=YES;
    timercount1=0;
    
}



-(void)closeAdView
{
    isAds=NO;
    [viewAds setHidden:YES];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

#pragma mark
#pragma mark -- Timer Logic
-(void)targetMethod :(NSString *)info {
    
    timercount1++;
    
    /*
     //  strCheckDate = @"2015-04-20";
     NSDateFormatter *dateFormatterVSP = [[NSDateFormatter alloc]init];
     [dateFormatterVSP setDateFormat:@"yyyy-mm-dd"];
     
     NSDate *installedDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"installedDate"];
     
     NSDate *currentDate = [NSDate date];
     
     NSDateFormatter *dateFormatterVSP2 = [[NSDateFormatter alloc]init];
     [dateFormatterVSP2 setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
     
     NSDateFormatter *dateFormatterHr = [[NSDateFormatter alloc]init];
     [dateFormatterHr setDateFormat:@"HH"];
     
     NSDateFormatter *dateFormatterSec = [[NSDateFormatter alloc]init];
     [dateFormatterSec setDateFormat:@"ss"];
     
     NSDateFormatter *dateFormatterMin = [[NSDateFormatter alloc]init];
     [dateFormatterMin setDateFormat:@"mm"];
     
     //    NSString *hrInstalledDate = [dateFormatterHr stringFromDate:installedDate];
     //    NSString *minInstalledDate = [dateFormatterMin stringFromDate:installedDate];
     //    NSString *secInstalledDate = [dateFormatterSec stringFromDate:installedDate];
     
     NSString *hrCurrentDate = [dateFormatterHr stringFromDate:currentDate];
     NSString *minCurrentDate = [dateFormatterMin stringFromDate:currentDate];
     NSString *secCurrentDate = [dateFormatterSec stringFromDate:currentDate];
     
     NSInteger remainingHr = 23- [hrCurrentDate integerValue];
     NSInteger remainingMin = 59- [minCurrentDate integerValue];
     NSInteger remainingSec = 60- [secCurrentDate integerValue];
     if (remainingSec == 60)
     {
     remainingSec = 0;
     }
     if (remainingMin == -1)
     {
     remainingMin = 59;
     }
     
     NSString *strCurrentDate = [dateFormatterVSP stringFromDate:currentDate];
     
     NSString *strInstalledDate = [dateFormatterVSP stringFromDate:installedDate];
     
     NSDate *newCurrentDate = [dateFormatterVSP dateFromString:strCurrentDate];
     NSDate *newInstalledDate = [dateFormatterVSP dateFromString:strInstalledDate];
     
     NSInteger days = [self daysBetweenDate:newInstalledDate andDate:newCurrentDate];
     
     if([minCurrentDate integerValue]==5 || [minCurrentDate integerValue]==10 || [minCurrentDate integerValue]==15)
     {
     if(isAds)
     {
     viewAds.hidden=NO;
     [self adsViewDisplay];
     }
     }else if ([minCurrentDate integerValue]>15)
     {
     if ([minCurrentDate integerValue]%5==0)
     {
     if(isAds)
     {
     viewAds.hidden=NO;
     [self adsViewDisplay];
     }
     }
     else
     {
     isAds=YES;
     viewAds.hidden=YES;
     }
     }
     else
     {
     isAds=YES;
     viewAds.hidden=YES;
     
     }
     
     */
    
    NSDate *installedDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"installedDate"];
    
    NSDate *currentDate = [NSDate date];
    NSInteger duration = [currentDate timeIntervalSinceDate:installedDate];
    
    NSInteger days = duration/86400;
    
    NSInteger newDuration = duration - 86400*days;
    
    NSInteger hours =  newDuration/3600;
    
    NSInteger minutes = newDuration/60;
    
    NSInteger hrToBeShown = 23 - hours;
    
    NSInteger minToBeShown = 59-(minutes - (60*hours));
    
    NSInteger secToBeShown = 60-(newDuration - (60*minutes));
    
    if (minutes%60 == 0)
    {
        minToBeShown = 59;
    }
    if (newDuration%60 == 0)
    {
        secToBeShown = 0;
    }
    /*
     if(days==3 || days==7 || days==30)
     {
     if(isAds)
     {
     viewAds.hidden=NO;
     [self adsViewDisplay];
     }
     }else if (days>30)
     {
     if (days%3==0)
     {
     if(isAds)
     {
     viewAds.hidden=NO;
     [self adsViewDisplay];
     }
     }
     else
     {
     isAds=YES;
     viewAds.hidden=YES;
     }
     }
     else
     {
     isAds=YES;
     viewAds.hidden=YES;
     
     }
     */
    
    if(days==2 || days==6 || days==13 || days==29)
    {
        isTimer = YES;
        if(isAds)
        {
            _lblTimeTimer.hidden = NO;

            NSArray *bannersOfflineItems = [[Model instance] offlineBanners];
            [self showImageFocusViewWithBanners:bannersOfflineItems];
            viewAds.hidden=NO;
            [self adsViewDisplay];

        }
    }else if (days>30)
    {
        if (days%3==0)
        {
            isTimer = YES;
            
            if(isAds)
            {
                _lblTimeTimer.hidden = NO;

                NSArray *bannersOfflineItems = [[Model instance] offlineBanners];
                if (bannersOfflineItems != nil)
                {
                    [self showImageFocusViewWithBanners:bannersOfflineItems];
                }

                viewAds.hidden=NO;
                [self adsViewDisplay];

            }
        }
        else
        {
            isTimer = NO;
            
            if (!isAds)
            {
                _lblTimeTimer.hidden = YES;

                NSMutableArray *bannersOfflineItems = [[[Model instance] offlineBanners] mutableCopy];
                if (bannersOfflineItems.count>0)
                {
                    [bannersOfflineItems removeObjectAtIndex:0];
                    [self showImageFocusViewWithBanners:bannersOfflineItems];
                }
                
            }
            isAds=YES;
            viewAds.hidden=YES;
        }
    }
    else if (days==0)
    {
        isTimer = YES;
        
        if(isAds)
        {
            _lblTimeTimer.hidden = NO;

            NSArray *bannersOfflineItems = [[Model instance] offlineBanners];
            if (bannersOfflineItems != nil)
            {
                [self showImageFocusViewWithBanners:bannersOfflineItems];
            }
            
            isAds=NO;
           // viewAds.hidden=NO;
          //  [self adsViewDisplay];

        }
    }
    else
    {
        
        if (!isAds)
        {
            NSMutableArray *bannersOfflineItems = [[[Model instance] offlineBanners] mutableCopy];
            if (bannersOfflineItems.count>0)
            {
                [bannersOfflineItems removeObjectAtIndex:0];
                [self showImageFocusViewWithBanners:bannersOfflineItems];
            }
        }
        isTimer = NO;
        
        _lblTimeTimer.hidden = YES;
        viewAds.hidden=YES;
        isAds=YES;
    }
    
    NSString *hr = @"";
    NSString *min = @"";
    NSString *sec = @"";
    if (hrToBeShown<10) {
        
        hr = [NSString stringWithFormat:@"0%ld",(long)hrToBeShown];
    }
    else
    {
        hr = [NSString stringWithFormat:@"%ld",(long)hrToBeShown];
        
    }
    if (minToBeShown<10)
    {
        min = [NSString stringWithFormat:@"0%ld",(long)minToBeShown];
    }
    else
    {
        min = [NSString stringWithFormat:@"%ld",(long)minToBeShown];
        
    }
    if (secToBeShown<10) {
        sec = [NSString stringWithFormat:@"0%ld",(long)secToBeShown];
        
    }
    else
    {
        sec = [NSString stringWithFormat:@"%ld",(long)secToBeShown];
        
    }
    _lblTimeTimer.text= [NSString stringWithFormat:@"%@:%@:%@",hr,min,sec];
    adsTimer.text= [NSString stringWithFormat:@"%@:%@:%@",hr,min,sec];
    
}


-(NSDate *)oldDatesFromCurrentDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    NSLog(@"today=%@",today);
    NSLog(@"yesterday=%@",yesterday);
    NSLog(@"thisWeek=%@",thisWeek);
    NSLog(@"lastWeek=%@",lastWeek);
    NSLog(@"thisMonth=%@",thisMonth);
    NSLog(@"lastMonth=%@",lastMonth);
    return yesterday;
}


//Ad remove particuler index

-(void)removeAdd {
    _lblTimeTimer.hidden=YES;
}

-(void)showAdd {
    
    if (isTimer)
    {
        _lblTimeTimer.hidden=NO;
    }
}


-(void)adsViewDisplay {
    
        isAds=NO;
        
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             viewAds.transform=CGAffineTransformMakeScale(1.2, 1.2);
                         }
                         completion:^(BOOL finished){
                             viewAds.transform=CGAffineTransformIdentity;
                         }];
    }
    
   


-(void)showImageFocusViewWithBanners:(NSArray*)banners
{
    
    [_focusImageView removeFromSuperview];
    
    NSMutableArray *focusImages = [[NSMutableArray alloc] init];
    
    for (GetBannersRequestItem *item in banners)
    {
        SGFocusImageItem *focusItem = [[SGFocusImageItem alloc] initWithTitle:nil image:[UIImage imageWithContentsOfFile:item.imagePath] tag:[focusImages count] link:item.link];
        [focusImages addObject:focusItem];
    }
    
    _focusImageView = [[SGFocusImageFrame alloc] initWithFrame:[self focusImageFrame] delegate:self focusImageItemsArrray:focusImages];
    _focusImageView.delegate = self;
    _focusImageView.backgroundColor = [UIColor clearColor];
    
    [_lblTimeTimer removeFromSuperview];
    _lblTimeTimer=[[UILabel alloc] initWithFrame:CGRectMake(_focusImageView.frame.size.width-80,_focusImageView.frame.size.height-25, 80, 25)];
    [_focusImageView addSubview:_lblTimeTimer];
    _lblTimeTimer.textColor = [UIColor whiteColor];
    [_lblTimeTimer setFont: [UIFont fontWithName:@"TOONISH" size:18]];
    [self.view addSubview:_focusImageView];
    
}

-(void)showAdsButton:(BOOL)value
{
    CGRect btnAdsFrame = _btnRemoveAds.frame;
    btnAdsFrame.origin.x = value ? self.view.frame.size.width - btnAdsFrame.size.width-10 : self.view.frame.size.width-10;
    _btnRemoveAds.alpha = value;
    
    [UIView animateWithDuration:0.5 animations:^{
        _btnRemoveAds.frame = btnAdsFrame;
    }];
    
}

-(void)configureBannerAds:(NSNotification*)notif
{
    NSArray *banners = [notif.userInfo objectForKey:@"result"];
    [self showImageFocusViewWithBanners:banners];
}

-(CGRect)focusImageFrame
{
    // template
    return CGRectNull;
}

#pragma mark SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    if ([item.link isEqualToString:@"purchase"])
    {
        //custom method
        //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[MKStoreManager sharedManager] buyFeature:APP_DONATE_1000_POINTS onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
            
            if ([purchasedFeature  isEqualToString:APP_DONATE_1000_POINTS])
            {
                Person *p = [[Person allObjects] lastObject];
                p.coinsBought = [NSNumber numberWithInteger:[p.coinsBought integerValue] + 1000];
                [DELEGATE saveContext];
                
                [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } onCancelled:^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else
    {
        
        if([@"http://itunes.apple.com/app/cars-guess-win!/id648838825" isEqualToString:item.link]) {
            [Localytics tagEvent:@"the Banners is pressed 1"];
        }else if([@"http://itunes.apple.com/app/movies-photo-quiz.-guess-movie!/id770845053" isEqualToString:item.link]) {
            [Localytics tagEvent:@"the Banners is pressed 2"];
        }else if([@"http://itunes.apple.com/app/guess-the-tank!/id704317910" isEqualToString:item.link]) {
             [Localytics tagEvent:@"the Banners is pressed 3"];
        }else if([@"http://itunes.apple.com/app/movies-photo-quiz.-guess-movie!/id770845053" isEqualToString:item.link]) {
             [Localytics tagEvent:@"the Banners is pressed 4"];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.link]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(targetMethod:)
                                           userInfo:nil
                                            repeats:YES];
    
    Person *p = [[Person allObjects] lastObject];
    
    if (![AppSettings appIsRated] && [[Model instance] serverRateAlert] && [p.allPersonPoints integerValue] <= 0)
    {
        [super showRateAlert];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showAdsButton:[[Model instance] bIsShowBanner]];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [timer invalidate];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self showAdsButton:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didStartGame:(id)sender {
    if ([[[[Person allObjects] lastObject] allPersonPoints] integerValue] <= 0)
    {
        [self showNoCoinsAlert];
        
    }
    else
    {
        [self startOfflineGame];
    }
}

-(void)startOfflineGame
{
    // template
}

- (IBAction)didStartOnlineGame:(id)sender {
    
    // template
}

-(void)stavkaViewDidClose
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void)stavkaViewDidBid:(NSInteger)bid
{
    _playerBid = bid;
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
    [[GameModel sharedInstance] startOnlineGameWithViewController:self];
}

- (IBAction)didLeaderBoard:(id)sender {
  
      [Localytics tagEvent:@"Every time Leaderboard is pressed / opened"];
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init] ;
    if (leaderboardController != NULL)
    {
        leaderboardController.category = kLeaderboardID;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [self presentViewController:leaderboardController animated:YES completion:nil];
    }
    
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)removeBanner
{
    [_btnRemoveAds removeFromSuperview];
}
- (IBAction)didRemoveAds:(id)sender {
   //hupendrafdfdf
    [Localytics tagEvent:@"Every time Admob Ad is pressed / opened "];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MKStoreManager sharedManager] buyFeature:APP_REMOVE_ADS onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
       [Localytics tagEvent:@"Every time user confirms and pays for Remove Ad Option"];
        [self removeBanner];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } onCancelled:^{
        [Localytics tagEvent:@"Every time Admob Ad is pressed / opened"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (IBAction)didInfo:(id)sender {
    
    [Localytics tagEvent:@" Every time the info button is pressed / opened"];
    AlertViewController *alert = [[AlertViewController alloc] initWithMessage:[[Localization instance] stringWithKey:@"txt_alertInfo"] button1Title:@"OK" button2Title:nil];
    alert.delegate = self;
    alert.showMailController = YES;
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:alert];
    [navVc setNavigationBarHidden:YES];
    
    [self presentPopupViewController:navVc animationType:MJPopupViewAnimationFade];
}

-(void)startOnlineGame:(NSNotification*)notif
{
    NSDictionary *result = notif.userInfo;
    NSString *ids = [result objectForKey:@"questionIds"];
    BOOL server = [[result objectForKey:@"IsServer"] boolValue];
    
    [self startGameWithQuestionIds:ids isServer:server];
}

-(void)startGameWithQuestionIds:(NSString*)ids isServer:(BOOL)isServer
{
    // template
}



@end
