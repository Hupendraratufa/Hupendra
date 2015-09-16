//
//  QuestionView.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FonQuestion.h"
#import "Question.h"
#import "QustionInfo.h"

@protocol QuestionViewDelegate <NSObject>

-(void)questionDidAnswerQuestion:(Question*)question withAnswer:(QustionInfo*)answer;
-(void)questionDidHelp;
-(BOOL)questionCanOpenCell;

@end


@interface QuestionView : UIView <FonQuestionDelegate>
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *imageQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;
@property (weak, nonatomic) IBOutlet UIButton *btnFirst;
@property (weak, nonatomic) IBOutlet UIButton *btnSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnThird;
@property (weak, nonatomic) IBOutlet UIButton *btnFourth;
@property (nonatomic, assign) id <QuestionViewDelegate> delegate;

-(id)initWithDelegate:(id<QuestionViewDelegate>)delegate question:(Question*)question isOnline:(BOOL)isOnline;
//-(void)reloadView;

- (IBAction)didHelp:(id)sender;
- (IBAction)didAnswer:(id)sender;
-(NSInteger)cellsCount;
-(void)removeOneWrongAnswer;
-(void)removeAllCells;
@end
