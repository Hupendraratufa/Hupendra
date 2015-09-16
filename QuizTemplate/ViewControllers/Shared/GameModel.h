//
//  GameModel.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 13/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingPerson.h"
#import "Person.h"
#import "Question.h"
#import "GameCenterManager.h"
#import "PlayingBot.h"

@interface GameModel : NSObject <GameCenterManagerDelegate, PlayingBotDelegate>

@property (nonatomic, strong) NSArray *allQuestions;
@property (nonatomic, strong) PlayingPerson *playingPerson;
@property (nonatomic, strong) PlayingBot *playingBot;
@property (nonatomic) NSInteger openedCells;

@property (nonatomic, strong) NSString *idsString;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) BOOL IsServer;

@property (nonatomic, strong) NSMutableDictionary *myPlayingQuestions;
@property (nonatomic, strong) NSMutableDictionary *opponentPlayingQuestions;

+(GameModel*)sharedInstance;

-(void)authenticateLocalUser;
-(void)startWithQuestionIds:(NSString*)ids;
-(void)startWithOffline;

-(BOOL)spendCoins:(NSInteger)coins;

-(Question*)question;
-(NSInteger)questionIndex;

-(NSDictionary*)didForRightQuestionOffline;
-(NSDictionary*)didForRightQuestionOnlineWithTimerValue:(NSInteger)timerValue;
-(NSDictionary*)didForWrongQuestionOnlineWithTimerValue:(NSInteger)timerValue;

-(void)finishOnlineGame;
-(BOOL)isGameCenterUserAuthenticated;
-(void)startOnlineGameWithViewController:(UIViewController*)vc;
-(NSDictionary*)calculateResultWithBid:(NSInteger)bid;
-(void)startGameWithBot;
-(void)onlineGameStarted;

-(void)addPlayingQuestionsObject:(PlayingQuestion *)object;
-(void)addOpponentPlayingQuestionsObject:(PlayingQuestion *)object;
-(BOOL)isOpponentAlreadyPlayedQuestion:(NSInteger)qIndex;

-(NSInteger)numberOfRightPlayersAnswer;
-(NSInteger)numberOfRightBotAnswer;
-(BotResults)botShoudWin;

-(BOOL)getCoins:(NSInteger)coins;
@end
