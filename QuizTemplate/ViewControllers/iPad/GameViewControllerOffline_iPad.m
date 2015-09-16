//
//  GameViewControllerOffline_iPad.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 20/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewControllerOffline_iPad.h"

@interface GameViewControllerOffline_iPad ()

@end

@implementation GameViewControllerOffline_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    [self.btnQuestionIndex.titleLabel setFont:[UIFont myFontSize:30]];
    
    if ([[AppSettings currentLanguage] isEqualToString:@"ru_RU"])
    {
        self.languageIsRU = YES;
        self.gameHelp_RU.imageRu.image = [UIImage imageNamed:@"podskazka_ru_RU-ipad.png"];
        self.gameHelp_RU.delegate = self;
    }
    else
    {
        self.languageIsRU = NO;
        self.gameHelp_EN.imageEn.image = [UIImage imageNamed:@"podskazka_en_US-ipad.png"];
        self.gameHelp_EN.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
