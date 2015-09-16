//
//  GameViewControllerOnliner.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 15/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewControllerOnline.h"

@interface GameViewControllerOnline ()
{
    NSTimer *questionTimer;
    NSInteger timerValue;
    MBProgressHUD *HUD;
}
@end

@implementation GameViewControllerOnline

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil questionIds:(NSString*)str;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[GameModel sharedInstance] startWithQuestionIds:str];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameModelReceivedData:) name:@"GameModelReceivedData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameModelMatchEnded:) name:@"GameModelMatchEnded" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect playersViewFrame = _playersView.frame;
    playersViewFrame.origin.y = self.imageTopView.frame.origin.y + self.imageTopView.frame.size.height;
    _playersView.frame = playersViewFrame;
    [_playersView shoewView];
    [self.view addSubview:_playersView];
    
    [[GameModel sharedInstance] onlineGameStarted];
    
    self.btnQuestionIndex.userInteractionEnabled = NO;
    self.btntopCoins.userInteractionEnabled = NO;
}

-(void)onBack
{
    [self releaseTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[GameModel sharedInstance]finishOnlineGame];
}

-(void)enterBackground
{
    [HUD removeFromSuperview];
    HUD = nil;
    [self onBack];
}

-(void)releaseTimer
{
	[questionTimer invalidate];
	questionTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123)
        [self onBack];
}

-(void)showQuestion
{
    [self.questionView removeFromSuperview];
    self.questionView = nil;
    
    [self.btnQuestionIndex setTitle:[NSString stringWithFormat:@"%u/5",[GameModel sharedInstance].questionIndex + 1] forState:UIControlStateNormal];
    
    
    if (![[Model instance] isInternetAvailable])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[Localization instance] stringWithKey:@"txt_error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 123;
        [alert show];
    }
    
    
    Question *qe = [GameModel sharedInstance].question;
    if (!qe)
    {
        [self doVictoryGame];
        return;
    }
    self.questionView = [[QuestionView alloc] initWithDelegate:self question:qe isOnline:YES];
    [self.view addSubview:self.questionView];
    
    CGRect qFr;
    qFr.origin.x = 0;
    qFr.origin.y = self.imageTopView.frame.origin.y + self.imageTopView.frame.size.height + _playersView.frame.size.height;
    qFr.size.width = self.view.frame.size.width;
    qFr.size.height = self.view.frame.size.height - qFr.origin.y;
   
    self.questionView.frame = qFr;
    
    [self releaseTimer];
    [self hideWaitOpponent];
    
    timerValue = TimerValue;
    
    questionTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];

}

-(void)onTimer:(NSTimer*)timer
{
    --timerValue;
    
    NSLog(@"timer Value - %lu",(unsigned long)timerValue);
   
    [_playersView updateMyProgressForQuestionIndex:[GameModel sharedInstance].questionIndex withValue:timerValue];
    if (timerValue <= 0)
    {
        NSLog(@"Timer is OVEr");
        [self didForWrongAnswer];
        
    }
}

-(void)showWaitOpponentLabel
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = [[Localization instance] stringWithKey:@"txt_wait"];
    [HUD show:YES];
    
    [GameModel sharedInstance].playingPerson.isPlayerIsWaiting = YES;
}

-(void)hideWaitOpponent
{
    [HUD removeFromSuperview];
    HUD = nil;
    [GameModel sharedInstance].playingPerson.isPlayerIsWaiting = NO;
}

-(BOOL)isCurrentStateIsWaitingForOpponent
{
    return [GameModel sharedInstance].playingPerson.isPlayerIsWaiting;
}
-(void)doVictoryGame
{
    if (!self.questionView)
        return;
  
    [self.questionView removeFromSuperview];
    self.questionView = nil;
    
    [self hideWaitOpponent];
        
    NSDictionary *result = [[GameModel sharedInstance] calculateResultWithBid:_playerBid];
    
//    NSInteger resCoins = [[result objectForKey:@"myCoins"] integerValue] ;
//    NSInteger resPoitns = [[result objectForKey:@"myPoints"] integerValue] ;
    
    [[GameModel sharedInstance] finishOnlineGame];
    
    WinAlertView *alert = [[WinAlertView alloc] initAlertWithInfo:result];
    alert.delegate = self;
    [self.view addSubview:alert];
}

-(void)didForRightAnswer
{
     [self playRightAnswerSound];
    [self releaseTimer];
    
    [_playersView updateWithMeIsRight:YES forQuestionIndex:[GameModel sharedInstance].questionIndex timerValue:timerValue];
  
    NSDictionary *result = [[GameModel sharedInstance] didForRightQuestionOnlineWithTimerValue:timerValue];
    
    if ([[result objectForKey:@"doTheNextQuestion"] boolValue])
    {
        [self showQuestion];
    }
    else if ([[result objectForKey:@"showWaiting"] boolValue])
    {
        [self showWaitOpponentLabel];
    }
    else if ([[result objectForKey:@"doVictory"] boolValue])
    {
        [self doVictoryGame];
    }
    
//    [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
//    [self updateGameCenterPointsForLabel:self.lbPoints withAnimation:YES];
}

-(void)didForWrongAnswer
{
    [super playWrongSound];
    [self releaseTimer];
    
    [_playersView updateWithMeIsRight:NO forQuestionIndex:[GameModel sharedInstance].questionIndex timerValue:timerValue];
    
    NSDictionary *result = [[GameModel sharedInstance] didForWrongQuestionOnlineWithTimerValue:timerValue];
    
    if ([[result objectForKey:@"doTheNextQuestion"] boolValue])
    {
        [self showQuestion];
    }
    else if ([[result objectForKey:@"showWaiting"] boolValue])
    {
        [self showWaitOpponentLabel];
    }
    else if ([[result objectForKey:@"doVictory"] boolValue])
    {
        [self doVictoryGame];
    }
    
//    [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
//    [self updateGameCenterPointsForLabel:self.lbPoints withAnimation:YES];
    
}

-(void)gameModelReceivedData:(NSNotification*)notif
{
    NSDictionary *result = notif.userInfo;
    
    NSNumber *questionIndex = [result objectForKey:@"questionIndex"];
    BOOL questionIsRight = [[result objectForKey:@"questionIsRight"] boolValue];
    NSNumber *questionTimerValue = [result objectForKey:@"questionTimerValue"];
    BOOL doTheNextQuestion = [[result objectForKey:@"doTheNextQuestion"] boolValue];
    BOOL doVicotry = [[result objectForKey:@"doVictory"] boolValue];
    
    [_playersView updateWithOpponentIsRight:questionIsRight forQuestionIndex:[questionIndex integerValue] timerValue:[questionTimerValue integerValue]];

    if (doTheNextQuestion)
    {
        [self showQuestion];
    }
    else if (doVicotry)
    {
        [self doVictoryGame];
    }
}

-(void)gameModelMatchEnded:(NSNotification*)notif
{
    NSDictionary *result = notif.userInfo;
    BOOL doTheNextQuestion = [[result objectForKey:@"doTheNextQuestion"] boolValue];
   
    if (doTheNextQuestion)
    {
        [self showQuestion];
    }
    else
    {
        [self doVictoryGame];
    }

}

-(void)winAlertClose
{
    [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
    [self updateGameCenterPointsForLabel:self.lbPoints withAnimation:YES];
    
    [self performSelector:@selector(onBack) withObject:nil afterDelay:0.5];
}

@end
