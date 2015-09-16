//
//  WinAlertView.m
//  AudioQuiz
//
//  Created by Vladislav on 5/29/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "WinAlertView.h"
#import "Localization.h"
#import "UIColor+NewColor.h"
#import "UIFont+CustomFont.h"
#import "AppReskManager.h"
#import "AppSettings.h"
#import "MKStoreManager.h"
#import "Person.h"

int gmover_adcount1=0;

@implementation WinAlertView

-(id)initAlertWithInfo:(NSDictionary *)info
{
    CGRect frame = CGRectMake(0, 0, 320, 480);
    
    self = [super initWithFrame:frame];
    if (self) {
        if (isPhone)
        {
            [[NSBundle mainBundle] loadNibNamed:@"WinAlertView_iPhone" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 320, 460);
        }
        else if (isPhone568)
        {
            [[NSBundle mainBundle] loadNibNamed:@"WinAlertView_iPhone" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 320, 548);
        }
        else
        {
            [[NSBundle mainBundle] loadNibNamed:@"WinAlertView_iPad" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 768, 1004);
        }
        
        gmover_adcount1++;
        
        
        
        if (gmover_adcount1%3==0) {
            
            if(![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS])
                
            {
                
                [[AppReskManager instance]showChartboost_FullScreen];
                
            }
            
            gmover_adcount1=0;
            
            
            
        }
        
        
        _view.frame = self.frame;
        self.alpha = 0.1;
        _lbCoins.text = [[info objectForKey:@"myCoins"] integerValue] > 0 ? [NSString stringWithFormat:@"+%@",[[info objectForKey:@"myCoins"] stringValue]] : [[info objectForKey:@"myCoins"] stringValue];
        _lbPoints.text = [NSString stringWithFormat:@"+%@",[[info objectForKey:@"myPoints"] stringValue]];
   
        NSInteger isWin = [[info objectForKey:@"isMyWin"] integerValue];
        if (isWin == 0)
        {
            _lbVictory.text = [[[Localization instance] stringWithKey:@"txt_lose"] uppercaseString];
            if ([[info objectForKey:@"isByTime"] boolValue] == YES)
                _lbVictory.text = [_lbVictory.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",[[Localization instance] stringWithKey:@"txt_badTime"]]];
        }
        else if (isWin == 1)
        {
            _lbVictory.text = [[[Localization instance] stringWithKey:@"txt_victory"] uppercaseString];
            if ([[info objectForKey:@"isByTime"] boolValue] == YES)
                _lbVictory.text = [_lbVictory.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",[[Localization instance] stringWithKey:@"txt_bestTime"]]];
        }
        else if (isWin == 3)
        {
            _lbVictory.text = [[[Localization instance] stringWithKey:@"txt_draw"] uppercaseString];
        }
        
        _lbCoins.textColor = isWin ? [UIColor myGreenColor] : [UIColor redColor];
        _lbPoints.textColor = isWin ? [UIColor myGreenColor] : [UIColor myGreenColor];
        _lbVictory.textColor = isWin ? [UIColor myGreenColor] : [UIColor redColor];
        
        _lbCoins.textAlignment = NSTextAlignmentCenter;
        _lbPoints.textAlignment = NSTextAlignmentCenter;
        _lbVictory.textAlignment = NSTextAlignmentCenter;
        
      //  _lbCoins.font = [UIFont myFontSize:isPad ? 45 : 25];
       // _lbPoints.font = [UIFont myFontSize:isPad ? 45 : 25];
      //  _lbVictory.font = [UIFont myFontSize:isPad ? 50 : 30];
        
        _lbCoins.adjustsFontSizeToFitWidth = YES;
        _lbPoints.adjustsFontSizeToFitWidth = YES;
        _lbVictory.adjustsFontSizeToFitWidth = YES;

        
        _lbOk.text = @"OK";
        _lbOk.textAlignment = NSTextAlignmentCenter;
        _lbOk.textColor = [UIColor blackColor];
        _lbOk.font = [UIFont myFontSize:isPad ? 40 : 20];
        _lbOk.adjustsFontSizeToFitWidth = YES;
        
        CGRect contentViewFrame = _contentView.frame;
        contentViewFrame.origin.x = (self.frame.size.width - _contentView.frame.size.width)/2;
        contentViewFrame.origin.y = (self.frame.size.height - _contentView.frame.size.height)/2;
        _contentView.frame = contentViewFrame;
        
        
        
        [self addSubview:_view];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
        }];
        
        
        
    }
    return self;

}

- (IBAction)didClose:(id)sender {

    self.alpha = 0;

    [self performSelector:@selector(close) withObject:nil afterDelay:0.1];
}

-(void)close
{
    
   [_delegate winAlertClose];
  [self removeFromSuperview];
    
   Person *person = [[Person allObjects] lastObject];
    NSLog(@"%@",person);
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"winCoin"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lossCoin"]);
    
//    AppDelegate *appDelegate=(AppDelegate *)[UIApplication  sharedApplication].description;
//    
//    if(appDelegate.gameEndCount==4){
//        
//        [self removeFromSuperview];
//    }else {
//        [_delegate winAlertClose];
//         [self removeFromSuperview];
//    }
    
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    
    [_view release];
    [_contentView release];
    [_lbCoins release];
    [_lbPoints release];
    [_lbVictory release];
    [_lbOk release];
    [super dealloc];
}
@end
