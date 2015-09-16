//
//  GameModel.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 13/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameModel.h"
#import "Question.h"
#import "GameCenterManager.h"
#import "PlayingQuestion.h"
#import "BaseViewController.h"
#import "Model.h"

#define MaxPersentOfWins 0.4
#define MaxPersentOfLoses 0.4

@interface GameModel ()
{
    NSInteger currentQuestionIndex;
}
@end

@implementation GameModel

+(GameModel*)sharedInstance
{
    static dispatch_once_t once;
    static GameModel *sharedObject;
    dispatch_once(&once, ^ { sharedObject = [[GameModel alloc] init]; });
    return sharedObject;
}

-(void)startWithOffline
{
    
    _allQuestions = [Question allQuestions];
    
    _playingPerson = [PlayingPerson PlayingPerson];
    
    currentQuestionIndex = [_playingPerson personLastQuestionIndex];
}

-(void)startWithQuestionIds:(NSString *)ids
{
    _allQuestions = [Question questionsByIndexes:ids];
    
    _playingPerson = [PlayingPerson PlayingPerson];
    
    currentQuestionIndex = 0;
    
    _myPlayingQuestions = [[NSMutableDictionary alloc] init];
    _opponentPlayingQuestions = [[NSMutableDictionary alloc] init];
}

-(id)init
{
    if (self = [super init])
    {
        [self authenticateLocalUser];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startGameWithBot) name:@"GameCenterNotFound" object:nil];

    }
    
    return self;
}

-(void)authenticateLocalUser
{
    if ([GameCenterManager isGameCenterAvailable]) {
        [[GameCenterManager sharedInstance] setDelegate:self];
        [[GameCenterManager sharedInstance] authenticateLocalUser];
    }
}

-(BOOL)isGameCenterUserAuthenticated
{
    if (![[Model instance] isInternetAvailable])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Unavailable" message:@"Player is not signed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

        return NO;
    }
    return [[GameCenterManager sharedInstance] isUserAuthenticated];
}

-(void)finishOnlineGame
{
    [[GameCenterManager sharedInstance] setDelegate:nil];
    [[[GameCenterManager sharedInstance] match] disconnect];
    [[GameCenterManager sharedInstance] setMatch:nil];
    _allQuestions = nil;
    
    [_myPlayingQuestions removeAllObjects];
    [_opponentPlayingQuestions removeAllObjects];
    
    
    [_playingBot stopBot];
    _playingBot = nil;
    _playingPerson = nil;

}
-(void)dealloc
{

}

-(Question*)question
{
    if (currentQuestionIndex < [_allQuestions count])
        return [_allQuestions objectAtIndex:currentQuestionIndex];
    return nil;
}

-(NSInteger)questionIndex
{
    return currentQuestionIndex;
}

-(BOOL)spendCoins:(NSInteger)coins
{
    return [_playingPerson personSpentCoins:coins];
}

-(void)getCoins:(NSInteger)coins
{
    [_playingPerson personGetCoins:coins];
}



-(NSDictionary*)didForRightQuestionOffline
{
    [_playingPerson encrementQuestionIndex];
    currentQuestionIndex = [_playingPerson personLastQuestionIndex];
    
    if (currentQuestionIndex >= [_allQuestions count])
    {
        self.playingPerson.person.questionIndex = 0;
        currentQuestionIndex = 0;
    }
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    app.gameEndCount=[[[NSUserDefaults standardUserDefaults] valueForKey:@"gameCount"] intValue];
    
    app.gameEndCount++;
    
    NSUserDefaults *stander=[NSUserDefaults standardUserDefaults];
    [stander setObject:[NSString stringWithFormat:@"%d",app.gameEndCount] forKey:@"gameCount"];
    
    
    int winCoin=[[[NSUserDefaults standardUserDefaults] valueForKey:@"winCoin"] intValue]+10;
    [stander setObject:[NSString stringWithFormat:@"%d",winCoin] forKey:@"winCoin"];
    [stander synchronize];

    
    if(app.gameEndCount>4){
        NSNumber *winPoints = [NSNumber numberWithInteger:0];
        [_playingPerson personGetPoints:_openedCells];
        return [NSDictionary dictionaryWithObjectsAndKeys:winPoints, @"winPoints", nil];
    }else {
         // [_playingPerson personGetCoins:10];
          NSNumber *winPoints = [NSNumber numberWithInteger:_openedCells +10];
         [_playingPerson personGetPoints:_openedCells];
        return [NSDictionary dictionaryWithObjectsAndKeys:winPoints, @"winPoints", nil];
    }
    
  
    
}

-(NSDictionary*)didForRightQuestionOnlineWithTimerValue:(NSInteger)timerValue
{

    PlayingQuestion *plQ = [PlayingQuestion playingQuestionWithId:currentQuestionIndex answerTime:timerValue isRight:YES];
    [self addPlayingQuestionsObject:plQ];
    
    if (_playingBot)
    {
        // send to bot that player answer right
        if (currentQuestionIndex < [_allQuestions count])
            [_playingBot playerAnswerRight:YES forQuestionIndex:currentQuestionIndex];
    }
    else
    {
        [[GameCenterManager sharedInstance] sendStringToAllPeers:[NSString stringWithFormat:@"$oprght:%lu:%lu",(unsigned long)currentQuestionIndex,(unsigned long)timerValue]];
    }
    
    currentQuestionIndex++;
    
    if (currentQuestionIndex < [_allQuestions count])
    {
        if ([self isOpponentAlreadyPlayedQuestion:currentQuestionIndex-1])
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"doTheNextQuestion"];
        else
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"showWaiting"];
        
    }
    else
    {
        
        if ([self isOpponentAlreadyPlayedQuestion:currentQuestionIndex-1])
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"doVictory"];
        else
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"showWaiting"];
        
    }


    [DELEGATE saveContext];
    
    return nil;
}

-(NSDictionary*)didForWrongQuestionOnlineWithTimerValue:(NSInteger)timerValue
{
    
    PlayingQuestion *plQ = [PlayingQuestion playingQuestionWithId:currentQuestionIndex answerTime:timerValue isRight:NO];
    [self addPlayingQuestionsObject:plQ];
    
    if (_playingBot)
    {
        // send to bot that player answer wrong
        if (currentQuestionIndex < [_allQuestions count])
            [_playingBot playerAnswerRight:NO forQuestionIndex:currentQuestionIndex];
    }
    else
    {
        [[GameCenterManager sharedInstance] sendStringToAllPeers:[NSString stringWithFormat:@"$opwrng:%lu:%lu",(unsigned long)currentQuestionIndex,(unsigned long)timerValue]];
    }
   
    currentQuestionIndex++;
    
    if (currentQuestionIndex < [_allQuestions count])
    {
        if ([self isOpponentAlreadyPlayedQuestion:currentQuestionIndex-1])
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"doTheNextQuestion"];
        else
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"showWaiting"];
        
    }
    else
    {
        
        if ([self isOpponentAlreadyPlayedQuestion:currentQuestionIndex-1])
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"doVictory"];
        else
            return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"showWaiting"];
        
    }
    
    
    [DELEGATE saveContext];
    
    return nil;

}

-(void)botDidAnswerForQuestionIndex:(NSInteger)qIndex withRight:(BOOL)isRight timerValue:(NSInteger)timerValue
{
    NSString *dataString = isRight ? [NSString stringWithFormat:@"$oprght:%lu:%lu",(unsigned long)qIndex,(unsigned long)timerValue] : [NSString stringWithFormat:@"$opwrng:%lu:%lu",(unsigned long)qIndex,(unsigned long)timerValue];
    
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObject:dataString forKey:@"data"];
    [self gameReceivedData:dataDictionary];
}


#pragma mark GameCentrManagerDelegate
- (void)gameReceivedData:(NSDictionary *)dataDictionary;
{
    NSNumber *questionIndex = nil;
    NSNumber *questionIsRight = nil;
    NSNumber *questionTimerValue = nil;
    NSNumber *doTheNextQuestion = [NSNumber numberWithBool:NO];
    NSNumber *doVictory = [NSNumber numberWithBool:NO];
    
    if ([[dataDictionary objectForKey:@"data"] hasPrefix:@"$oprght"])
    {
        NSArray *array = [[dataDictionary objectForKey:@"data"] componentsSeparatedByString:@":"];
        
        PlayingQuestion *plQ = [PlayingQuestion playingQuestionWithId:[[array objectAtIndex:1] integerValue] answerTime:[[array lastObject] integerValue] isRight:YES];
        [self addOpponentPlayingQuestionsObject:plQ];
        
        questionIndex = [NSNumber numberWithInteger:[[array objectAtIndex:1] integerValue]];
        questionIsRight = [NSNumber numberWithBool:YES];
        questionTimerValue = [NSNumber numberWithInteger:[[array lastObject] integerValue]];

        if (_playingPerson.isPlayerIsWaiting)
        {
            if (currentQuestionIndex == [_allQuestions count])
            {
                doVictory = [NSNumber numberWithBool:YES];
            }
            else
            {
                [_playingBot startWithQestionIndex:currentQuestionIndex];
                doTheNextQuestion = [NSNumber numberWithBool:YES];
            }
        }
        else if (currentQuestionIndex == [_allQuestions count])
            doVictory = [NSNumber numberWithBool:YES];
        
    }
    else if ([[dataDictionary objectForKey:@"data"] hasPrefix:@"$opwrng"])
    {
        NSArray *array = [[dataDictionary objectForKey:@"data"] componentsSeparatedByString:@":"];
        
        PlayingQuestion *plQ = [PlayingQuestion playingQuestionWithId:[[array objectAtIndex:1] integerValue] answerTime:[[array lastObject] integerValue] isRight:NO];
        [self addOpponentPlayingQuestionsObject:plQ];

        questionIndex = [NSNumber numberWithInteger:[[array objectAtIndex:1] integerValue]];
        questionIsRight = [NSNumber numberWithBool:NO];
        questionTimerValue = [NSNumber numberWithInteger:[[array lastObject] integerValue]];
        
        if (_playingPerson.isPlayerIsWaiting)
        {
            if (currentQuestionIndex == [_allQuestions count])
            {
                doVictory = [NSNumber numberWithBool:YES];
            }
            else
            {
                [_playingBot startWithQestionIndex:currentQuestionIndex];
                doTheNextQuestion = [NSNumber numberWithBool:YES];
            }
        }
        else if (currentQuestionIndex == [_allQuestions count])
            doVictory = [NSNumber numberWithBool:YES];
        
        
    }
    else if ([[dataDictionary objectForKey:@"data"] hasPrefix:@"$maystart"])
    {
        
        NSString *questionIds = [[dataDictionary objectForKey:@"data"] stringByReplacingOccurrencesOfString:@"$maystart:" withString:@""];
        _idsString = questionIds;
        
        if (!_isStart)
        {
            _isStart = YES;
            [self startAfterDelay:questionIds];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"startOnlineGame" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:questionIds, @"questionIds",[NSNumber numberWithBool:_IsServer],@"IsServer", nil]];

        }
        return;
    }
    
    if (questionIndex != nil && questionIsRight != nil && questionTimerValue != nil && doTheNextQuestion != nil && doVictory != nil)
    {
    
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:questionIndex, @"questionIndex", questionIsRight, @"questionIsRight",questionTimerValue, @"questionTimerValue",doTheNextQuestion, @"doTheNextQuestion", doVictory, @"doVictory", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameModelReceivedData" object:nil userInfo:result];
    }
}

- (void)matchEnded {
    
    NSLog(@"Match ended !");
    
    for (int i = 0; i < 5; i++)
    {
        PlayingQuestion *plq = [self.opponentPlayingQuestions objectForKey:[NSNumber numberWithInt:i]];
        if (!plq)
        {
            plq = [PlayingQuestion playingQuestionWithId:i answerTime:0 isRight:NO];
            [self addOpponentPlayingQuestionsObject:plq];
        }
    }
    
    NSNumber *doTheNextQuestion = [NSNumber numberWithBool:NO];
    
    if (_playingPerson.isPlayerIsWaiting)
    {
        if (currentQuestionIndex == [_allQuestions count])
        {
            doTheNextQuestion = [NSNumber numberWithBool:NO];
        }
        else
        {
            [_playingBot startWithQestionIndex:currentQuestionIndex];
            doTheNextQuestion = [NSNumber numberWithBool:YES];
        }
    }
    else if (currentQuestionIndex == [_allQuestions count])
        doTheNextQuestion = [NSNumber numberWithBool:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GameModelMatchEnded" object:nil userInfo:[NSDictionary dictionaryWithObject:doTheNextQuestion forKey:@"doTheNextQuestion"]];
    
}

-(void)startOnlineGameWithViewController:(UIViewController *)vc
{
    _isStart = NO;
    [[GameCenterManager sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:vc delegate:self]; 
}

- (void)matchStartedWithBestPlayer:(NSNumber *)isServer {
    _IsServer = [isServer boolValue];
    [self startGame];
}

- (void)startGame
{
    if (_IsServer)
    {
        NSString *dataString = [self questionIdsDataString];
        [[GameCenterManager sharedInstance] performSelector:@selector(sendStringToAllPeers:) withObject:dataString afterDelay:1];
        
        dataString = [dataString stringByReplacingOccurrencesOfString:@"$maystart:" withString:@""];
        [self performSelector:@selector(startAfterDelay:) withObject:dataString afterDelay:1.5];
    }
}

-(NSString*)questionIdsDataString
{
     NSString *dataString = @"$maystart";
    NSMutableArray *rand = [[NSMutableArray alloc] initWithCapacity:5];
    int max = 5;
    
    NSInteger count = [[Question allObjects] count];
    
    for(int i = 0; i < 5; i++)
    {
        int r = arc4random() % count;
        while([self foundNumber:r inArray:rand limit:i])
        {
            r = random() % max + 1;
        }
        [rand addObject:[NSNumber numberWithInt:r]];
        dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@":%@",[rand objectAtIndex:i]]];
    }
    
    return dataString;
}

-(void)startGameWithBot
{
    [[GameCenterManager sharedInstance] cancelFindMath];

     currentQuestionIndex = 0;
   

    NSString *ids = [self questionIdsDataString];
    _IsServer = YES;
    
    _playingPerson = [PlayingPerson PlayingPerson];
    _playingBot = [PlayingBot playingBot];
    _playingBot.delegate = self;
    
    [self startAfterDelay:ids];
    
}

-(void)onlineGameStarted
{
    if (_playingBot)
    {
        [_playingBot startWithQestionIndex:currentQuestionIndex];
    }
}

-(void)startAfterDelay:(NSString*)ids
{
    [GameCenterManager sharedInstance].matchStarted = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startOnlineGame" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:ids, @"questionIds",[NSNumber numberWithBool:_IsServer],@"IsServer", nil]];
}

- (BOOL) foundNumber:(int)r inArray:(NSMutableArray*)rand limit:(int)l {
    for(int i = 0; i < l; i++){
        if([[rand objectAtIndex:i] integerValue] == r) return YES;
    }
    return NO;
}

-(NSDictionary*)calculateResultWithBid:(NSInteger)bid
{
    NSDictionary *result = [_playingPerson calculateResultWithBid:bid];
//    NSUInteger isWin = [[result objectForKey:@"isMyWin"] integerValue];
    
   
   
    return result;
}

-(BotResults)botShoudWin
{
    NSInteger matches = _playingPerson.person.numberOfMatches;
    if (matches < 5)
        return BotResultRandom;
   
    if ([_playingPerson.person.botLoses floatValue] / (float) matches *10 > MaxPersentOfLoses * 10)
        return BotResultWin;
    
    if ([_playingPerson.person.botWins floatValue] / (float) matches * 10 > MaxPersentOfWins * 10)
        return BotResultLose;
    

    
    return BotResultRandom;
    
}

-(void)addPlayingQuestionsObject:(PlayingQuestion *)object
{
    [_myPlayingQuestions setObject:object forKey:[NSNumber numberWithInteger:object.questionId]];
}

-(NSInteger)numberOfRightPlayersAnswer
{
    NSInteger result = 0;
    for (NSNumber *key in [_myPlayingQuestions allKeys])
    {
        PlayingQuestion *q = [_myPlayingQuestions objectForKey:key];
        if (q.bIsRightAnswer)
            result++;
    }
    
    return result;
}

-(NSInteger)numberOfRightBotAnswer
{
    NSInteger result = 0;
    for (NSNumber *key in [_opponentPlayingQuestions allKeys])
    {
        PlayingQuestion *q = [_opponentPlayingQuestions objectForKey:key];
        if (q.bIsRightAnswer)
            result++;
    }
    
    return result;
}

-(void)addOpponentPlayingQuestionsObject:(PlayingQuestion *)object
{
    [_opponentPlayingQuestions setObject:object forKey:[NSNumber numberWithInteger:object.questionId]];
}

-(BOOL)isOpponentAlreadyPlayedQuestion:(NSInteger)qIndex
{
    if ([_opponentPlayingQuestions objectForKey:[NSNumber numberWithInteger:qIndex]])
        return YES;
    return NO;
}

-(void)reloadScoresComplete:(GKLeaderboard *)leaderBoard error:(NSError *)error
{
    PlayingPerson *p = [PlayingPerson PlayingPerson];
    p.person.points = [NSNumber numberWithInteger:leaderBoard.localPlayerScore.value];
    [DELEGATE saveContext];
    
    UIViewController *top = DELEGATE.navigationController.topViewController;
    if ([[top class] isSubclassOfClass:[BaseViewController class]])
    {
        BaseViewController *vc = (BaseViewController*)top;
        [vc updateGameCenterPointsForLabel:vc.lbPoints withAnimation:YES];
    }
}

-(void)processGameCenterAuth:(NSError *)error
{
    Person* p = [[Person allObjects] lastObject];
    [[GameCenterManager sharedInstance] reportScore:[p.points integerValue] forCategory:kLeaderboardID];
}

//-(void)scoreReported:(NSError *)error
//{
//    if (error == nil)
//    {
//        self 
//    }
//}



@end
