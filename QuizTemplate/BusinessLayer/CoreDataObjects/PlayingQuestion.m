//
//  PlayingQuestion.m
//  AudioQuiz
//
//  Created by Vladislav on 5/28/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "PlayingQuestion.h"

@implementation PlayingQuestion


@synthesize bIsRightAnswer = _bIsRightAnswer;
@synthesize questionId = _questionId;
@synthesize questionTime = _questionTime;
@synthesize winCoins = _winCoins;
@synthesize winPoints = _winPoints;

+(PlayingQuestion*)playingQuestionWithId:(NSInteger)qId answerTime:(NSInteger)time isRight:(BOOL)isRight
{
    return [[PlayingQuestion alloc] initWithId:qId time:TimerValue - time isRight:isRight] ;
}

-(id)initWithId:(NSInteger)qId time:(NSInteger)time isRight:(BOOL)isRight
{
    if ((self = [super init]) != nil)
    {
        _bIsRightAnswer = isRight;
        _questionTime = time;
        _questionId = qId;
    }
    
    return self;
}


@end
