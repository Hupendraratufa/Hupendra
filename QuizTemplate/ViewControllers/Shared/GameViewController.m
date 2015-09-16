//
//  GameViewController.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewController.h"
#import "Appirater.h"
#import "UIViewController+MJPopupViewController.h"
#import "CRFileUtils.h"
#import "SoundManager.h"
#import "AppReskManager.h"
#import "AppSettings.h"
#import "MKStoreManager.h"
#import <MediaPlayer/MediaPlayer.h>


@interface GameViewController ()

@end

@implementation GameViewController

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
    
//    _gameModel = [[GameModel alloc] init];
    [SoundManager sharedManager].allowsBackgroundMusic = NO;
    [[SoundManager sharedManager] prepareToPlay];
    [self showQuestion];
    
    [self.btnQuestionIndex setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnQuestionIndex setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.btnQuestionIndex.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.btnQuestionIndex.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)playWrongSound
{
    [[SoundManager sharedManager] playSound:@"error.mp3" looping:NO];
}

-(void)playRightAnswerSound
{
    [[SoundManager sharedManager] playSound:@"rightAnswer.mp3" looping:NO];
}
- (IBAction)didQuestionIndex:(id)sender {

}

-(IBAction)didBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showQuestion
{
 

}

;

-(void)questionDidAnswerQuestion:(Question *)question withAnswer:(QustionInfo *)answer{
    
    
    if ([answer.bIsRightAnswer boolValue])
    {
        [Localytics tagEvent:@"Every time user gets correct answer on level 1"];
        [self didForRightAnswer];
        
    }
    
    else
    {
         [Localytics tagEvent:@"Every time user gets incorrect answer on level 1"];
        [self didForWrongAnswer];
    }
    
    
    
    
}

-(void)questionDidHelp
{
    //tepmplate
}

-(BOOL)questionCanOpenCell
{
    //template
    return NO;
}


-(void)didForRightAnswer
{


}

-(void)didForWrongAnswer
{

    
}

-(void)alertDidDismissed:(AlertViewController *)alert
{
    if (alert.tag == 111)
    {
        // right answer
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        [self updateGameCenterPointsForLabel:self.lbPoints withAnimation:YES];
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self showQuestion];
        });
        
         [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
    }
    else if (alert.tag == 222)
    {
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
    else if (alert.tag == 666)
    {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }

}

-(void)alertControllerDidClose:(AlertViewController *)alert withButtonTag:(NSInteger)btnTag
{
    if (alert.tag == 111)
    {
        // right answer
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        [self updateGameCenterPointsForLabel:self.lbPoints withAnimation:YES];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self showQuestion];
        });
        
    }
    else if (alert.tag == 222)
    {
        [self updateCoinsForLabel:self.lbCoins withAnimation:YES];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
    }
    else if (alert.tag == 666)
    {
        if (btnTag == 300) {
            
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
            self.view.userInteractionEnabled = NO;
            
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.view.userInteractionEnabled = YES;
                [self didCoins];
                
            });
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
}


@end
