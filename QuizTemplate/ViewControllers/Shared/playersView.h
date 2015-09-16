//
//  playersView.h
//  AudioQuiz
//
//  Created by Vladislav on 5/24/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterManager.h"
#import "PlayingPerson.h"
#import "PlayingQuestion.h"
//#import "PDColoredProgressView.h"




@interface playersView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UIImageView *opponentImage;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *opponentName;

@property (nonatomic, strong) NSDictionary *myProgrers;
@property (nonatomic, strong) NSDictionary *opponentProgrers;
@property (weak, nonatomic) IBOutlet UIProgressView *myFirst;
@property (weak, nonatomic) IBOutlet UIProgressView *mySecond;
@property (weak, nonatomic) IBOutlet UIProgressView *myThird;
@property (weak, nonatomic) IBOutlet UIProgressView *myFourth;
@property (weak, nonatomic) IBOutlet UIProgressView *myFiveth;
@property (weak, nonatomic) IBOutlet UIProgressView *opponFirst;
@property (weak, nonatomic) IBOutlet UIProgressView *opponSecond;
@property (weak, nonatomic) IBOutlet UIProgressView *opponThird;
@property (weak, nonatomic) IBOutlet UIProgressView *opponFourth;
@property (weak, nonatomic) IBOutlet UIProgressView *opponFiveth;


-(void)shoewView;
-(void)updateMyProgressForQuestionIndex:(NSInteger)index withValue:(NSInteger)seconds;
-(void)updateWithOpponentIsRight:(BOOL)isRight forQuestionIndex:(NSInteger)index timerValue:(NSInteger)seconds;
-(void)updateWithMeIsRight:(BOOL)isRight forQuestionIndex:(NSInteger)index timerValue:(NSInteger)seconds;

@end
