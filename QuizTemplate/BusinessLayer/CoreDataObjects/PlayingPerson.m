//
//  PlayingPerson.m
//  AudioQuiz
//
//  Created by Vladislav on 5/28/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "PlayingPerson.h"
#import "Person.h"
#import "PlayingQuestion.h"
#import "GameCenterManager.h"
#import "GameModel.h"


@implementation PlayingPerson
@synthesize person = _person;
@synthesize isPlayerIsWaiting = _isPlayerIsWaiting;

-(id)initWithPerson:(Person*)person
{
    if ((self = [super init]) !=nil)
    {
        _person = person;
        
    }
    
    return self;
}

+(PlayingPerson*)PlayingPerson
{
    Person *person = [[Person allObjects] lastObject];
    return [[PlayingPerson alloc] initWithPerson:person];
}





-(NSInteger)personLastQuestionIndex
{
    return [_person.questionIndex integerValue];
}

-(void)encrementQuestionIndex
{
    _person.questionIndex = [NSNumber numberWithInteger:[_person.questionIndex integerValue] + 1];
    [DELEGATE saveContext];
}

-(NSDictionary*)calculateResultWithBid:(NSInteger)bid
{
    NSInteger myCoins = 0;
    NSInteger myPoints = 0;

    NSInteger myRights = 0;
    NSInteger opRights = 0;
    NSInteger myTotalTime = 0;
    NSInteger opTotalTime = 0;

    NSDictionary *myQuestions = [GameModel sharedInstance].myPlayingQuestions;
    NSDictionary *opQuestions = [GameModel sharedInstance].opponentPlayingQuestions;
    
    for (int i = 0; i < 5; i++)
    {
        PlayingQuestion *myPlQ = [myQuestions objectForKey:[NSNumber numberWithInt:i]];
        if (!myPlQ)
        {
            myPlQ = [PlayingQuestion playingQuestionWithId:i answerTime:TimerValue isRight:NO];
        }
        
        PlayingQuestion *opPlQ = [opQuestions objectForKey:[NSNumber numberWithInt:i]];
        if (!opPlQ)
        {
            opPlQ = [PlayingQuestion playingQuestionWithId:i answerTime:TimerValue isRight:NO];
        }
        
//        NSLog(@"For Quiestion - %d\n MyTime - %d Right - %@\n OpTime - %d Right - %@", i+1, myPlQ.questionTime,    myPlQ.bIsRightAnswer ? @"YES" : @"NO", opPlQ.questionTime, opPlQ.bIsRightAnswer ? @"YES" : @"NO");
    
        myTotalTime += myPlQ.questionTime;
        opTotalTime += opPlQ.questionTime;
        
        if (myPlQ.bIsRightAnswer)
        {
            myRights++;
            myPoints += 5;
        }
        if (opPlQ.bIsRightAnswer)
        {
            opRights++;
        }
    }

    NSInteger isMyWin = 0;
    BOOL resultByTime = NO;
    
    if (myRights > opRights)
    {
        isMyWin = 1;
//        myCoins += 5 * myRights;
        myCoins = bid;
    }
    else if (myRights < opRights)
    {
        isMyWin = 0;
//        myCoins -= 5 * 5;
        myCoins -= bid;
    }
    else // ==
    {
        
        if (myTotalTime < opTotalTime)
        {
            isMyWin = 1;
            resultByTime = YES;
//            myCoins += 5 * myRights;
            myCoins = bid;
        }
        else if (myTotalTime > opTotalTime)
        {
            isMyWin = 0;
            resultByTime = YES;
//            myCoins -= 5 * 5;
            myCoins -= bid;
        }
        else // ==
        {
            isMyWin = 3;
//            myCoins += 5 * myRights;
            if (myRights != 0)
                myCoins = bid;
        }
    }

    
    if (isMyWin == 1)
    {
        myPoints *= 2;
    }
    
    [self personGetCoins:myCoins];
   
    [self personGetPoints:myPoints];
    
    [self saveBotGameResult:isMyWin];
    
//    _person.coinsEarned = [NSNumber numberWithInteger:[_person.coinsEarned integerValue] + myCoins];
//    _person.points = [NSNumber numberWithInteger:[_person.points integerValue] + myPoints];
    
//    [DELEGATE saveContext];
    
    NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:myCoins], @"myCoins", [NSNumber numberWithInteger:myPoints],@"myPoints", [NSNumber numberWithInteger:isMyWin], @"isMyWin",[NSNumber numberWithBool:resultByTime], @"isByTime", nil];
    
    return res;
    
}

-(BOOL)personSpentCoins:(NSInteger)coins
{
    if ([_person.allPersonPoints integerValue] >= coins)
    {
        
        NSInteger earnedPoints = [_person.coinsEarned integerValue];
        NSInteger coinsBought = [_person.coinsBought integerValue];
        NSInteger tapPoints = [_person.cointsTapJoy integerValue];
        NSInteger nadoOtnat = coins;
        if (earnedPoints > 0 && earnedPoints < coins)
        {
            nadoOtnat = coins - earnedPoints;
            earnedPoints = 0;
        }
        
        if (earnedPoints >= coins)
        {
            earnedPoints -= coins;
        }
        else if (tapPoints >= nadoOtnat)
        {
            tapPoints -= nadoOtnat;
            
        }
        else if (coinsBought >= nadoOtnat)
        {
            coinsBought -= nadoOtnat;
        }
        _person.coinsEarned = [NSNumber numberWithInteger:earnedPoints];
        _person.coinsBought = [NSNumber numberWithInteger:coinsBought];
        _person.cointsTapJoy = [NSNumber numberWithInteger:tapPoints];
        
        [DELEGATE saveContext];
        
        
        return YES;
        
    }
    
    return NO;

}

-(void)personWinCoins:(NSInteger)coins
{
    _person.coinsEarned = [NSNumber numberWithInteger:[_person.winCoin integerValue] + coins];
    [DELEGATE saveContext];
}

-(void)personGetCoins:(NSInteger)coins
{
    _person.coinsEarned = [NSNumber numberWithInteger:[_person.coinsEarned integerValue] + coins];
    [DELEGATE saveContext];
}

-(void)personGetPoints:(NSInteger)points
{
    _person.points = [NSNumber numberWithInteger:[_person.points integerValue] + points];
    
    [DELEGATE saveContext];
    
    [[GameCenterManager sharedInstance] reportScore:[_person.points integerValue] forCategory:kLeaderboardID];
    
}

-(void)saveBotGameResult:(NSInteger)result
{
    if (result == 0)
    {
        _person.botWins = [NSNumber numberWithInteger:[_person.botWins integerValue] + 1];
    }
    else if (result == 1)
    {
        _person.botLoses = [NSNumber numberWithInteger:[_person.botLoses integerValue] + 1];
    }
    else if (result == 3)
        _person.botDraws = [NSNumber numberWithInteger:[_person.botDraws integerValue] + 1];
    
    [DELEGATE saveContext];
}
@end
