//
//  WinAlertView.h
//  AudioQuiz
//
//  Created by Vladislav on 5/29/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "KSLabel.h"

@protocol WinAlertViewDelegate <NSObject>

-(void)winAlertClose;

@end

@interface WinAlertView : UIView
@property (retain, nonatomic) IBOutlet UIView *view;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *lbCoins;
@property (retain, nonatomic) IBOutlet UILabel *lbPoints;
@property (retain, nonatomic) IBOutlet UILabel *lbVictory;
@property (nonatomic, assign) id<WinAlertViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *lbOk;

-(id)initAlertWithInfo:(NSDictionary*)info;
- (IBAction)didClose:(id)sender;

@end
