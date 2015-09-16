//
//  LeaderBoardView.h
//  GuessTheCar2
//
//  Created by HupendraRaghuwanshi on 10/09/15.
//  Copyright (c) 2015 Uladzislau Yasnitski. All rights reserved.
//

@protocol WinAlertViewDelegate1 <NSObject>

-(void)winAlertClose1;

@end

#import <UIKit/UIKit.h>

@interface LeaderBoardView : UIView
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *lblWinpoints;
@property (strong, nonatomic) IBOutlet UILabel *lblLossPoint;
@property (nonatomic, assign) id<WinAlertViewDelegate1> delegate;
-(id)initAlertWithInfo;
@end
