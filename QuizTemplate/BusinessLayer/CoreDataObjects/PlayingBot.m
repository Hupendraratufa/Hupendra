//
//  PlayingBot.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 18/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "PlayingBot.h"
#import "GameModel.h"

@interface PlayingBot ()
{
    NSInteger botQuestionIndex;
    NSTimer *_timer;
    NSInteger _timerValue;
    
    NSInteger _anserTimerValue;
    
    NSArray* _randomQuestionIndexesForRightQuestion;
    
    BotResults _resultForMatch;
}

@end

@implementation PlayingBot

-(id)initWithBot:(Bot*)bot
{
    if ((self = [super init]) !=nil)
    {
        _bot = bot;
        botQuestionIndex = 0;
        _anserTimerValue = 0;
        [self generateRandomQuestionIndexesForRightQuestion];
        _resultForMatch = [self botShoudWin];
    }
    
    return self;
}

-(void)generateRandomQuestionIndexesForRightQuestion
{
    NSMutableArray *rand = [[NSMutableArray alloc] initWithCapacity:2];
    int max = 4;
    
    for(int i = 0; i < 2; i++)
    {
        int r = arc4random() % max;
        while([self foundNumber:r inArray:rand limit:i])
        {
            r = random() % max + 1;
        }
        [rand addObject:[NSNumber numberWithInt:r]];
        NSLog(@"BOT RIGHT ANSSWER - %d",r);
    }
    
    _randomQuestionIndexesForRightQuestion = [NSArray arrayWithArray:rand];
}

- (BOOL) foundNumber:(int)r inArray:(NSMutableArray*)rand limit:(int)l {
    for(int i = 0; i < l; i++){
        if([[rand objectAtIndex:i] integerValue] == r) return YES;
    }
    return NO;
}

+(PlayingBot*)playingBot
{
    Bot *bot = [Bot randomBot];
    return [[PlayingBot alloc] initWithBot:bot];
}

-(UIImage*)playingBotImage
{
    return [UIImage imageWithContentsOfFile:_bot.botImagePath];
}

-(NSString*)playingBotName
{
    return _bot.botName;
}

-(void)releaseTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)startTimer
{
    _timerValue = TimerValue;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

-(void)onTimer:(NSTimer*)timer
{
    --_timerValue;
    NSLog(@"Bot timer Value - %lu",(unsigned long)_timerValue);
    
    if (_timerValue == _anserTimerValue)
    {
        [self releaseTimer];
        [_delegate botDidAnswerForQuestionIndex:botQuestionIndex withRight:[self generateRightOrWrongAnswerForQuestion:botQuestionIndex] timerValue:_timerValue];
        
    }
}

-(void)stopBot
{
    [self releaseTimer];
    _randomQuestionIndexesForRightQuestion = nil;
}

-(void)generateAnswerTimeValueForQuestionIndex:(NSInteger)qIndex
{
    if ([_randomQuestionIndexesForRightQuestion containsObject:[NSNumber numberWithInteger:qIndex]])
    {
        _anserTimerValue = TimerValue - ( 1 + arc4random() % 2);
     }
    else
    {
        _anserTimerValue = TimerValue - (1 + arc4random() % (_resultForMatch == BotResultWin ? 3 : 6)); // чем больше % x , тем дольше Бот думает
     }

    NSLog(@"Bot TimerValue for qIndex - %ld = %ld",(long)qIndex, (long)_anserTimerValue);
}

-(BOOL)generateRightOrWrongAnswerForQuestion:(NSInteger)qIndex
{
    if ([_randomQuestionIndexesForRightQuestion containsObject:[NSNumber numberWithInteger:qIndex]])
        return YES;
    
    if (_resultForMatch == BotResultWin)
    {
        if ([[GameModel sharedInstance] numberOfRightPlayersAnswer] >= [[GameModel sharedInstance] numberOfRightBotAnswer])
            return YES;
        
        return NO;
    }
    else if (_resultForMatch == BotResultLose)
    {
        if ([[GameModel sharedInstance] numberOfRightBotAnswer] >= [[GameModel sharedInstance] numberOfRightPlayersAnswer])
            return NO;
        
        return YES;
    }
    else if (_resultForMatch == BotResultDraw)
    {
        if ([[GameModel sharedInstance] numberOfRightBotAnswer] > [[GameModel sharedInstance] numberOfRightPlayersAnswer])
            return NO;
        else
            if ([[GameModel sharedInstance] numberOfRightPlayersAnswer] > [[GameModel sharedInstance] numberOfRightBotAnswer])
                return YES;
    }
    
    int randomval = arc4random() % 2;
    NSLog(@"Bot Right for qIndex - %ld = %d",(long)qIndex, randomval);
    return randomval;
}

-(BotResults)botShoudWin
{
    return [[GameModel sharedInstance] botShoudWin];
}



-(void)startWithQestionIndex:(NSInteger)qIndex
{
    botQuestionIndex = qIndex;
    
    [self generateAnswerTimeValueForQuestionIndex:qIndex];
    [self releaseTimer];
    [self startTimer];
}


-(void)playerAnswerRight:(BOOL)right forQuestionIndex:(NSInteger)qIndex
{
    if (!_timer.isValid)
        [self startWithQestionIndex:qIndex + 1];
}



@end
