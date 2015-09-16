//
//  PlayingBot.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 18/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bot.h"

@protocol PlayingBotDelegate <NSObject>

-(void)botDidAnswerForQuestionIndex:(NSInteger)qIndex withRight:(BOOL)isRight timerValue:(NSInteger)timerValue;

@end

@interface PlayingBot : NSObject
{
    
}

@property (nonatomic, readonly) Bot *bot;
@property (nonatomic, assign) id <PlayingBotDelegate> delegate;
+(PlayingBot*)playingBot;


-(UIImage*)playingBotImage;
-(NSString*)playingBotName;

-(void)playerAnswerRight:(BOOL)right forQuestionIndex:(NSInteger)qIndex;
-(void)startWithQestionIndex:(NSInteger)qIndex;

-(void)stopBot;
@end
