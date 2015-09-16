//
//  playersView.m
//  AudioQuiz
//
//  Created by Vladislav on 5/24/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "playersView.h"
#import "UIColor+NewColor.h"
#import "GameModel.h"

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
@implementation playersView

-(void)shoewView
{
    self.backgroundColor = [UIColor clearColor];
    _myName.adjustsFontSizeToFitWidth = YES;
    _myName.numberOfLines = 1;
    _myName.font = [UIFont boldSystemFontOfSize:isPad ? 25 : 10];
    _myName.textColor = [UIColor blackColor];
    _myName.textAlignment = NSTextAlignmentCenter;
    
    _opponentName.adjustsFontSizeToFitWidth = YES;
    _opponentName.numberOfLines = 1;
    _opponentName.font = [UIFont boldSystemFontOfSize:isPad ? 25 : 10];
    _opponentName.textColor = [UIColor blackColor];
    _opponentName.textAlignment = NSTextAlignmentCenter;
    
    GameCenterManager *gcManager = [GameCenterManager sharedInstance];
    
    [[gcManager currentLocalPlayer] loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
        _myImage.image = photo;
    }];
    _myName.text = [[gcManager currentLocalPlayer] alias];
    
    if ([GameModel sharedInstance].playingBot)
    {
        _opponentImage.image = [[GameModel sharedInstance].playingBot playingBotImage];
        _opponentName.text = [[GameModel sharedInstance].playingBot playingBotName];
    }
    else
    {
        [[gcManager oppozitePlayer] loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
            _opponentImage.image = photo;
        }];
        
        _opponentName.text = [[gcManager oppozitePlayer] alias];
    }
    /////
    
     _myProgrers = [[NSDictionary alloc] initWithObjectsAndKeys:_myFirst, [NSNumber numberWithInt:0], _mySecond, [NSNumber numberWithInt:1], _myThird, [NSNumber numberWithInt:2], _myFourth, [NSNumber numberWithInt:3], _myFiveth, [NSNumber numberWithInt:4], nil];
  
   _opponentProgrers= [[NSDictionary alloc] initWithObjectsAndKeys:_opponFirst, [NSNumber numberWithInt:0], _opponSecond, [NSNumber numberWithInt:1], _opponThird, [NSNumber numberWithInt:2], _opponFourth, [NSNumber numberWithInt:3], _opponFiveth, [NSNumber numberWithInt:4], nil];

    
    CGFloat heigh = isPad ? 9 : 5;
    for (UIProgressView *pr in [_myProgrers allValues])
    {
        CGRect frame = pr.frame;
        frame.size.height = heigh;
        pr.frame = frame;
    }
    
    for (UIProgressView *pr in [_opponentProgrers allValues])
    {
        CGRect frame = pr.frame;
        frame.size.height = heigh;
        pr.frame = frame;
    }
    
}


-(void)configureProgressView:(UIProgressView*)progressView
{
    progressView.progress = 0;
}


-(void)updateMyProgressForQuestionIndex:(NSInteger)index withValue:(NSInteger)seconds
{

    UIProgressView *pr = [_myProgrers objectForKey:[NSNumber numberWithInteger:index]];
    [pr setProgress:(float)seconds / TimerValue animated:YES];
//    [pr setProgress:(float)seconds / TimerValue animated:YES];
    if (seconds == 0)
    {
        NSLog(@"Seconds == 0");
        pr.progress = 0;
    }

    [pr setProgressTintColor:[UIColor yellowColor]];
    
}

-(void)updateWithMeIsRight:(BOOL)isRight forQuestionIndex:(NSInteger)index timerValue:(NSInteger)seconds
{
    UIProgressView *label = [_myProgrers objectForKey:[NSNumber numberWithInteger:index]];
    [label setProgressTintColor:isRight ? [UIColor myGreenColor] : [UIColor redColor]];
    label.progress = (float)(TimerValue - seconds) / TimerValue;
    [label setNeedsDisplay];
    
}

-(void)updateWithOpponentIsRight:(BOOL)isRight forQuestionIndex:(NSInteger)index timerValue:(NSInteger)seconds
{
    UIProgressView *label = [_opponentProgrers objectForKey:[NSNumber numberWithInteger:index]];
    [label setProgressTintColor:isRight ? [UIColor myGreenColor] : [UIColor redColor]];
    label.progress = (float)(TimerValue - seconds) / TimerValue;
    [label setNeedsDisplay];
    
    
}

@end
