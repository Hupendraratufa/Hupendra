//
//  GameViewController.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "BaseViewController.h"
#import "QuestionView.h"
#import "GameModel.h"
#import "Localization.h"
#import "AppSettings.h"
#import "Model.h"

@interface GameViewController : BaseViewController <QuestionViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnQuestionIndex;
@property (nonatomic, strong) QuestionView *questionView;


- (IBAction)didQuestionIndex:(id)sender;
-(void)showQuestion;
-(IBAction)didBack;



-(void)playWrongSound;
-(void)playRightAnswerSound;
@end
