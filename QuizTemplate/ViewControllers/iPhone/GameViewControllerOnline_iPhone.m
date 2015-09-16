//
//  GameViewControllerOnline_iPhone.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 18/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewControllerOnline_iPhone.h"

@interface GameViewControllerOnline_iPhone ()

@end

@implementation GameViewControllerOnline_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil questionIds:(NSString*)str;
{
    if (isPhone)
        nibNameOrNil = [nibNameOrNil stringByAppendingString:@"_4"];
    else
        nibNameOrNil = [nibNameOrNil stringByAppendingString:@"_5"];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil questionIds:str];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
