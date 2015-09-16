//
//  PlayingQuestion.h
//  AudioQuiz
//
//  Created by Vladislav on 5/28/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayingQuestion : NSObject
{
    NSInteger _questionId;
    NSInteger _questionTime;
    BOOL _bIsRightAnswer;
    
    NSInteger _winCoins;
    NSInteger _winPoints;
}

@property (nonatomic, assign) BOOL bIsRightAnswer;
@property (nonatomic, readonly) NSInteger questionId;
@property (readwrite, assign) NSInteger questionTime;
@property (readwrite, assign) NSInteger winCoins;
@property (readwrite, assign) NSInteger winPoints;

+(PlayingQuestion*)playingQuestionWithId:(NSInteger)qId answerTime:(NSInteger)time isRight:(BOOL)isRight;


@end

