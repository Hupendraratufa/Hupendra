//
//  PlayingPerson.h
//  AudioQuiz
//
//  Created by Vladislav on 5/28/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@class PlayingQuestion;

@interface PlayingPerson : NSObject
{
    Person *_person;
    BOOL _isPlayerIsWaiting;
}

@property (nonatomic, readonly) Person *person;

@property (nonatomic, assign) BOOL isPlayerIsWaiting;


+(PlayingPerson*)PlayingPerson;


-(NSDictionary*)calculateResultWithBid:(NSInteger)bid;

-(BOOL)personSpentCoins:(NSInteger)coins;
-(void)personGetCoins:(NSInteger)coins;
-(void)personGetPoints:(NSInteger)points;

-(NSInteger)personLastQuestionIndex;
-(void)encrementQuestionIndex;

-(void)saveBotGameResult:(NSInteger)result;

//Hupendra
-(void)personWinCoins:(NSInteger)coins;

@end
