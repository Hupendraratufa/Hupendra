//
//  WinAlertViewOffline.m
//  GuessTheCar2
//
//  Created by Uladzislau Yasnitski on 02/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "WinAlertViewOffline.h"
#import "UIColor+NewColor.h"
#import "UIFont+CustomFont.h"
#import "Localization.h"
#import "AppReskManager.h"
#import "AppSettings.h"
#import "MKStoreManager.h"

int gmover_adcount=0;

@implementation WinAlertViewOffline

-(id)initAlertWithInfo:(NSDictionary *)info
{
    CGRect frame = CGRectMake(0, 0, 320, 480);
    
    self = [super initWithFrame:frame];
    if (self) {
        if (isPhone)
        {
            [[NSBundle mainBundle] loadNibNamed:@"WinAlertViewOffline_iPhone" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 320, 460);
        }
        else if (isPhone568)
        {
            [[NSBundle mainBundle] loadNibNamed:@"WinAlertViewOffline_iPhone" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 320, 548);
        }
        else
        {
            [[NSBundle mainBundle] loadNibNamed:@"WinAlertViewOffline_iPad" owner:self options:nil];
            self.frame = CGRectMake(0, 0, 768, 1004);
        }
        
        
        
        gmover_adcount++;
        
        
        
        if (gmover_adcount%3==0) {
            
            if(![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS])
                
            {
                [[AppReskManager instance]showChartboost_FullScreen];
            }
            gmover_adcount=0;
            
        }
        
        
        self.view.frame = self.frame;
        self.alpha = 0.1;
        self.lbPoints.text = [NSString stringWithFormat:@"+%@",[[info objectForKey:@"myPoints"] stringValue]];

      //  self.lbPoints.textColor = [UIColor myGreyColor];
        self.lbPoints.textAlignment = NSTextAlignmentCenter;
        //self.lbPoints.font = [UIFont myFontSize:isPad ? 55 : 25];
        self.lbPoints.adjustsFontSizeToFitWidth = YES;
        
        
        self.lbVictory.text = [[[Localization instance] stringWithKey:@"txt_right"] uppercaseString];
      //  self.lbVictory.textColor = [UIColor myGreenColor];
        self.lbVictory.textAlignment = NSTextAlignmentCenter;
     //   self.lbVictory.font = [UIFont myFontSize:isPad ? 50 : 30];
        self.lbVictory.adjustsFontSizeToFitWidth = YES;

        
        
        CGRect contentViewFrame = self.contentView.frame;
        contentViewFrame.origin.x = (self.frame.size.width - self.contentView.frame.size.width)/2;
        contentViewFrame.origin.y = (self.frame.size.height - self.contentView.frame.size.height)/2;
        self.contentView.frame = contentViewFrame;
        
        
        
        [self addSubview:self.view];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
        }];
        
        
        
    }
    return self;
    
}


@end
