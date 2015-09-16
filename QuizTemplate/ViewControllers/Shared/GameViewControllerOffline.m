//
//  GameViewControllerOffline.m
//  QuizTemplate
//
//  Created by Vladislav Yasnicki on 16/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewControllerOffline.h"
#import "PopoverView.h"

@interface GameViewControllerOffline ()
{
    
}

@property (nonatomic, weak) PopoverView *popover;
@end

@implementation GameViewControllerOffline

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[GameModel sharedInstance] startWithOffline];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
       

}

-(IBAction)didBack
{
    [Localytics tagEvent:@"Every time user presses the back button"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didQuestionIndex:(id)sender {
    
    
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

-(void)showQuestion
{
    self.view.userInteractionEnabled = YES;
    [self.questionView removeFromSuperview];
    self.questionView = nil;
   // hupendra
    [self.btnQuestionIndex setTitle:[NSString stringWithFormat:@"%ld/300",[GameModel sharedInstance].questionIndex + 1] forState:UIControlStateNormal];
  
    [Localytics tagEvent:[NSString stringWithFormat:@"Every time user reaches level%ld",[GameModel sharedInstance].questionIndex + 1]];
    NSInteger questionIndex = [GameModel sharedInstance].questionIndex;
    
    if (questionIndex % 25 == 0 && ![AppSettings appIsRated] && [[Model instance] serverRateAlert] && questionIndex != 0)
    {
        [super showRateAlert];
    }
    
    self.questionView = [[QuestionView alloc] initWithDelegate:self question:[GameModel sharedInstance].question isOnline:NO];
    [self.view addSubview:self.questionView];

    [GameModel sharedInstance].openedCells = self.questionView.cellsCount;
    
    CGRect qFr;
    qFr.origin.x = 0;
    qFr.origin.y = self.imageTopView.frame.origin.y + self.imageTopView.frame.size.height;
    qFr.size.width = self.view.frame.size.width;
    qFr.size.height = self.view.frame.size.height - qFr.origin.y;
    
    self.questionView.frame = qFr;
    
}


-(void)didForRightAnswer
{
    Person *p = [[Person allObjects] lastObject];
    if ([p.allPersonPoints integerValue] <= 0)
    {
        [self showNoCoinsAlert];
        return;
    }
    
    [self playRightAnswerSound];
   
    NSLog(@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:@"gameCount"] intValue]);
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"gameCount"] intValue]>=4){
            [[GameModel sharedInstance] getCoins:0];
        }else {
            [[GameModel sharedInstance] getCoins:10];
        }

    
    NSDictionary *winWith = [[GameModel sharedInstance] didForRightQuestionOffline];
    NSNumber *pointsWin = [winWith objectForKey:@"winPoints"];
    NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:pointsWin, @"myPoints", nil];
    WinAlertViewOffline *alert = [[WinAlertViewOffline alloc] initAlertWithInfo:res];
    alert.delegate = self;
    [self.view addSubview:alert];
    
    //    NSString *message = [NSString stringWithFormat:[[Localization instance] stringWithKey:@"txt_winOffline"],coinsWin,pointsWin];
    //    AlertViewController *alert= [[AlertViewController alloc] initWithMessage:message buttonTitle:@"OK"];
    //    alert.tag = 111;
    //    alert.delegate = self;
    //    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:alert];
    //    [navVc setNavigationBarHidden:YES];
    //
    //    [self presentPopupViewController:navVc animationType:MJPopupViewAnimationFade];
    
}

/*-(void)didForRightAnswer
{
    Person *p = [[Person allObjects] lastObject];
    if ([p.allPersonPoints integerValue] <= 0)
    {
        [self showNoCoinsAlert];
        return;
    }
    
     [self playRightAnswerSound];
    NSDictionary *winWith = [[GameModel sharedInstance] didForRightQuestionOffline];
    
    NSNumber *pointsWin = [winWith objectForKey:@"winPoints"];
    
   
  
    NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:pointsWin, @"myPoints", nil];

    WinAlertViewOffline *alert = [[WinAlertViewOffline alloc] initAlertWithInfo:res];
    alert.delegate = self;
    [self.view addSubview:alert];
    
//    NSString *message = [NSString stringWithFormat:[[Localization instance] stringWithKey:@"txt_winOffline"],coinsWin,pointsWin];
//    AlertViewController *alert= [[AlertViewController alloc] initWithMessage:message buttonTitle:@"OK"];
//    alert.tag = 111;
//    alert.delegate = self;
//    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:alert];
//    [navVc setNavigationBarHidden:YES];
//    
//    [self presentPopupViewController:navVc animationType:MJPopupViewAnimationFade];

}*/

//VIVEK PATEL
-(void)winAlertClose
{
    // right answer
    double delayInSeconds = 0;
    
    if ([self.questionView cellsCount]>0)
    {
        [self.questionView removeAllCells];
        delayInSeconds = 2;
    };
    [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
    [self updateGameCenterPointsForLabel:self.lbPoints withAnimation:YES];
    self.view.userInteractionEnabled = NO;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self showQuestion];
         [self leaderBoardAction];
    });
  
    
}

-(void)leaderBoardAction {

//    NSDictionary *winWith = [[GameModel sharedInstance] didForRightQuestionOffline];
//    
//    NSNumber *pointsWin = [winWith objectForKey:@"winPoints"];
//    
//    NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:pointsWin, @"myPoints", nil];
//    
//    WinAlertViewOffline *alert = [[WinAlertViewOffline alloc] initAlertWithInfo:res];
//    alert.delegate = self;
//    [self.view addSubview:alert];
    
  // LeaderBoardView *alert = [[LeaderBoardView alloc] initAlertWithInfo];
   //alert.delegate = self;
  // [self.view addSubview:alert];
}

-(void)winAlertClose1 {
    
}


-(void)questionDidHelp
{
    CGPoint showPoint = [self.view convertPoint:self.questionView.btnHelp.frame.origin fromView:self.questionView];
    showPoint.x = self.view.frame.size.width / 2;
    _popover = [PopoverView showPopoverAtPoint:showPoint inView:self.view withContentView:_languageIsRU ? _gameHelp_RU : _gameHelp_EN delegate:nil];
}

-(BOOL)questionCanOpenCell
{
    if ([[GameModel sharedInstance] spendCoins:2])
    {
        
        [GameModel sharedInstance].openedCells--;
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        
        return YES;
    }
    else
    {
        [self showNoCoinsAlert];
    }
    
    return NO;
}

-(void)didForWrongAnswer
{
    
    Person *p = [[Person allObjects] lastObject];
    if ([p.allPersonPoints integerValue] <= 0)
    {
        [self showNoCoinsAlert];
        return;
    }
    
    [super playWrongSound];
    if ([[GameModel sharedInstance] spendCoins:5])
    {
        
        NSString *message = [NSString stringWithFormat:[[Localization instance] stringWithKey:@"txt_loseOffline"],[NSNumber numberWithInteger:-5]];
        int lossCoin=[[[NSUserDefaults standardUserDefaults] valueForKey:@"lossCoin"] intValue]-5;
        NSUserDefaults *stander=[NSUserDefaults standardUserDefaults];
        [stander setObject:[NSString stringWithFormat:@"%d",lossCoin] forKey:@"lossCoin"];
        [stander synchronize];

        AlertViewController *alert = [[AlertViewController alloc] initWithMessage:message button1Title:@"OK" button2Title:nil];
        alert.delegate = self;
        alert.tag = 222;
        UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:alert];
        [navVc setNavigationBarHidden:YES];
        
        [self presentPopupViewController:navVc animationType:MJPopupViewAnimationFade];
    }
    else
    {
        int lossCoin=[[[NSUserDefaults standardUserDefaults] valueForKey:@"lossCoin"] intValue]-5;
        NSUserDefaults *stander=[NSUserDefaults standardUserDefaults];
        [stander setObject:[NSString stringWithFormat:@"%d",lossCoin] forKey:@"lossCoin"];
        [stander synchronize];
        p.coinsEarned = [NSNumber numberWithInteger:[p.coinsEarned integerValue] - 5];
        [DELEGATE saveContext];
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        [self showNoCoinsAlert];
    }
}


/*-(void)didForWrongAnswer
{
    
    Person *p = [[Person allObjects] lastObject];
    if ([p.allPersonPoints integerValue] <= 0)
    {
        [self showNoCoinsAlert];
        return;
    }
    
    [super playWrongSound];
    if ([[GameModel sharedInstance] spendCoins:15])
    {
        
        NSString *message = [NSString stringWithFormat:[[Localization instance] stringWithKey:@"txt_loseOffline"],[NSNumber numberWithInteger:-5]];
        
        AlertViewController *alert = [[AlertViewController alloc] initWithMessage:message buttonTitle:@"OK"];
        alert.delegate = self;
        alert.tag = 222;
        UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:alert];
        [navVc setNavigationBarHidden:YES];
        [self presentPopupViewController:navVc animationType:MJPopupViewAnimationFade];
    }
    else
    {
        p.coinsEarned = [NSNumber numberWithInteger:[p.coinsEarned integerValue] - 5];
        [DELEGATE saveContext];
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        
        [self showNoCoinsAlert];
    }
}*/

#pragma mark GameHelpView
-(void)gameHelpClose
{
    [_popover dismiss];
    _popover = nil;
}

-(void)gameHelpDidCoins
{
    [self didCoins];
}

-(void)gameHelpDidRemoveAllCells
{
    if ([[GameModel sharedInstance] spendCoins:10])
    {
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        [self.questionView removeAllCells];
//        [GameModel sharedInstance].openedCells = 0;
    }
    else
        [self showNoCoinsAlert];
}

-(void)gameHelpDidRemoveOndeWrong
{
    if ([[GameModel sharedInstance] spendCoins:10])
    {
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        [self.questionView removeOneWrongAnswer];
    }
    else
        [self showNoCoinsAlert];
}

-(UIViewController*)gameHelpParentVC
{
    return self;
}

-(UIView*)shareView
{
    return self.questionView;
}

-(IBAction)didDismissView:(id)sender {
    [_popover dismiss];
    _popover = nil;
}
@end
