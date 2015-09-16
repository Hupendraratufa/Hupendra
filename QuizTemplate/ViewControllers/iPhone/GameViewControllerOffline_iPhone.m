//
//  GameViewController_iPhone.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewControllerOffline_iPhone.h"
#import "UIViewController+MJPopupViewController.h"



@interface GameViewControllerOffline_iPhone ()
@end

@implementation GameViewControllerOffline_iPhone
//@synthesize leaderBoardView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (isPhone)
        nibNameOrNil = [nibNameOrNil stringByAppendingString:@"_4"];
    else
        nibNameOrNil = [nibNameOrNil stringByAppendingString:@"_5"];

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnQuestionIndex.titleLabel setFont:[UIFont myFontSize:15]];
    if ([[AppSettings currentLanguage] isEqualToString:@"ru_RU"])
    {
        self.languageIsRU = YES;
        self.gameHelp_RU.imageRu.image = [UIImage imageNamed:@"podskazka_ru_RU.png"];
        self.gameHelp_RU.delegate = self;
    }
    else
    {
        self.languageIsRU = NO;
        self.gameHelp_EN.imageEn.image = [UIImage imageNamed:@"podskazka_en_US.png"];
        self.gameHelp_EN.delegate = self;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(IBAction)didDismissView:(id)sender {
//    
//}


@end
