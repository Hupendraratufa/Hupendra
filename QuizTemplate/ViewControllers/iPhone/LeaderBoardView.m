//
//  LeaderBoardView.m
//  GuessTheCar2
//
//  Created by HupendraRaghuwanshi on 10/09/15.
//  Copyright (c) 2015 Uladzislau Yasnitski. All rights reserved.
//

#import "LeaderBoardView.h"

@implementation LeaderBoardView


-(id)initAlertWithInfo
{
    CGRect frame = CGRectMake(0, 0, 320, 480);
    
    self = [super initWithFrame:frame];
    if (self) {
        if (isPhone)
        {
            [[NSBundle mainBundle] loadNibNamed:@"LeaderBoardView" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 320, 460);
        }
        else if (isPhone568)
        {
            [[NSBundle mainBundle] loadNibNamed:@"LeaderBoardView" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 320, 548);
        }
        else
        {
            [[NSBundle mainBundle] loadNibNamed:@"LeaderBoardView" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 768, 1004);
        }
        _mainView.frame = self.frame;
        self.alpha = 0.1;
        
        _lblWinpoints.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"winCoin"];
        _lblLossPoint.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"lossCoin"];
        
        CGRect contentViewFrame = _contentView.frame;
        contentViewFrame.origin.x = (self.frame.size.width - _contentView.frame.size.width)/2;
        contentViewFrame.origin.y = (self.frame.size.height - _contentView.frame.size.height)/2;
        _contentView.frame = contentViewFrame;
        
        [self addSubview:_mainView];
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
        }];
        
        
        
    }
    return self;
    
}

- (IBAction)didClose:(id)sender {

    self.alpha = 0;
   [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
