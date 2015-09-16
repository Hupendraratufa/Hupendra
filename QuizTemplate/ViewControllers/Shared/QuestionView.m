//
//  QuestionView.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "QuestionView.h"
#import "UIColor+NewColor.h"
#import "GeneralUtils.h"
#import "UIFont+CustomFont.h" 
#import "OpenedCell.h"
#import "AppSettings.h"
#import "NSMutableArray+Shuffling.h"
#import "Localytics.h"

@interface QuestionView ()

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSDictionary *answers;
@property (nonatomic, retain) NSMutableDictionary *buttons;
//@property (nonatomic, retain) NSMutableDictionary *labels;

@property (nonatomic, strong) FonQuestion *fonQuestion;
@end

@implementation QuestionView

- (id)initWithDelegate:(id<QuestionViewDelegate>)delegate question:(Question *)question isOnline:(BOOL)isOnline
{
    if (isPad)
    {
        [[NSBundle mainBundle] loadNibNamed:isOnline ? @"QuestionViewOnline_iPad" : @"QuestionViewOffline_iPad" owner:self options:nil];
    }
    else
    {
        if (isPhone)
            [[NSBundle mainBundle] loadNibNamed:isOnline ? @"QuestionViewOnline_iPhone_4" : @"QuestionViewOffline_iPhone_4" owner:self options:nil];
        else
            [[NSBundle mainBundle] loadNibNamed:isOnline ? @"QuestionViewOnline_iPhone_5" : @"QuestionViewOffline_iPhone_5" owner:self options:nil];
    }
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _delegate = delegate;
        _question = question;
        [self addSubview:_view];
        
        if (!isOnline && ![_question.questionRemoveAllCells boolValue])
        {
            
            NSMutableArray *openedIndexes = [[NSMutableArray alloc] init];
            for (OpenedCell *cell in [[_question openedCells] allObjects])
            {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:[cell.cellY integerValue] inSection:[cell.cellX integerValue]];
                [openedIndexes addObject:ip];
            }
            
            _fonQuestion = [[FonQuestion alloc] initWithFrame:_imageQuestion.frame openedIndexes:openedIndexes];
            _fonQuestion.delegate = self;
            [_view addSubview:_fonQuestion];
        }
        
        
        
        _answers = [NSDictionary dictionaryWithObjects:[_question allQuestionInfos] forKeys:[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], nil]];

        _btnFirst.tag = 0;
        _btnSecond.tag = 1;
        _btnThird.tag = 2;
        _btnFourth.tag = 3;
        
        _buttons = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_btnFirst, [NSNumber numberWithInt:0], _btnSecond,[NSNumber numberWithInt:1], _btnThird, [NSNumber numberWithInt:2], _btnFourth, [NSNumber numberWithInt:3], nil];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_buttons];
        NSMutableDictionary *array = [NSMutableDictionary dictionaryWithDictionary:_answers];
        
        
        NSMutableArray *colors = [[NSMutableArray alloc] initWithObjects:[UIColor colorWith8BitRed:115 green:121 blue:153 alpha:1],[UIColor colorWith8BitRed:219 green:87 blue:49 alpha:1], [UIColor colorWith8BitRed:0 green:166 blue:165 alpha:1], [UIColor colorWith8BitRed:144 green:192 blue:70 alpha:1], nil];
        [colors shuffle];
        
        CGFloat fontSize = isPad ? 33 : 18;
        
        [dic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
            UIButton *btn = [dic objectForKey:key];
            QustionInfo *answer = [_answers objectForKey:key];
            
            if ([answer.bIsRemoved boolValue])
            {
                UIButton *btn = [_buttons objectForKey:key];
                [btn removeFromSuperview];
                [_buttons removeObjectForKey:key];
                [array removeObjectForKey:key];
            }
            
            [btn setTitle:answer.title forState:UIControlStateNormal];
            [btn setBackgroundColor:[colors objectAtIndex:[key integerValue]]];
//            if ([answer.bIsRightAnswer boolValue])
//                [btn setBackgroundColor:[UIColor redColor]];
            
            [btn.titleLabel setFont:[UIFont myFontSize:fontSize]];
        }];
        
        _answers = array;
        
        _imageQuestion.image = [UIImage imageWithContentsOfFile:_question.questionImagePath];
        
        NSString *btnImageName;
        if (isPad)
        {
            btnImageName = [NSString stringWithFormat:@"help-ipad_%@.png",[AppSettings currentLanguage]];
        }
        else
        {
            btnImageName = [NSString stringWithFormat:@"help-iphone_%@.png",[AppSettings currentLanguage]];
        }
        [_btnHelp setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//-(void)reloadView
//{
//   
//}


-(void)removeOneWrongAnswer
{
    BOOL needElse = YES;
    
    NSMutableDictionary *array = [NSMutableDictionary dictionaryWithDictionary:_answers];
    
    while (needElse) {
        int index = arc4random() % 4;
        QustionInfo *answer = [array objectForKey:[NSNumber numberWithInt:index]];
        if (answer && ![answer.bIsRightAnswer boolValue])
        {
            [array removeObjectForKey:[NSNumber numberWithInt:index]];
            UIButton *btn = [_buttons objectForKey:[NSNumber numberWithInt:index]];
            [btn removeFromSuperview];
            [_buttons removeObjectForKey:[NSNumber numberWithInt:index]];
            
            answer.bIsRemoved = [NSNumber numberWithBool:YES];
//            UILabel *lb = [_labels objectForKey:[NSNumber numberWithInt:index]];
//            [lb removeFromSuperview];
//            [_labels removeObjectForKey:[NSNumber numberWithInt:index]];

            needElse = NO;
        }
    }
    
    _answers = array;
    [DELEGATE saveContext];
    
}
-(NSInteger)cellsCount
{
    return [_fonQuestion cellsCount];
}
-(void)removeAllCells
{
    SystemSoundID toneSSID = 1104;
    AudioServicesPlaySystemSound(toneSSID);
    [_fonQuestion removeAllCellsComplection:^{
        
        _question.questionRemoveAllCells = [NSNumber numberWithBool:YES];
        [DELEGATE saveContext];
        [_fonQuestion removeFromSuperview];
        _fonQuestion = nil;
    }];
}

- (IBAction)didHelp:(id)sender {
    [Localytics tagEvent:@"Every time user presses / opens Hints"];
    [_delegate questionDidHelp];
}

- (IBAction)didAnswer:(id)sender {
    [_delegate questionDidAnswerQuestion:_question withAnswer:[_answers objectForKey:[NSNumber numberWithInt:[sender tag]]]];
}

-(BOOL)fonQuestionCanOpenVopr:(Cell *)cell
{
    if ([_delegate questionCanOpenCell])
    {
        OpenedCell *openCell = (OpenedCell*)[OpenedCell createObject];
        openCell.cellX = [NSNumber numberWithInt:cell.cellIndexPath.section];
        openCell.cellY = [NSNumber numberWithInt:cell.cellIndexPath.row];
        openCell.question = _question;
        [DELEGATE saveContext];
        return YES;
    }
    return NO;
}
@end
