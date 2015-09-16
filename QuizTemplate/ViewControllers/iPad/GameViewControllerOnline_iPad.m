//
//  GameViewControllerOnline_iPad.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 20/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewControllerOnline_iPad.h"

@interface GameViewControllerOnline_iPad ()

@end

@implementation GameViewControllerOnline_iPad

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
