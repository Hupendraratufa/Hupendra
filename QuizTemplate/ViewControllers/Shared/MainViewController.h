//
//  MainViewController.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "BaseViewController.h"
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "StavkaViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface MainViewController : BaseViewController <UIAlertViewDelegate,GKLeaderboardViewControllerDelegate, StavkaViewControllerDelegate,SGFocusImageFrameDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnStartGame;
@property (weak, nonatomic) IBOutlet UIButton *btnStartOnlineGame;
@property (weak, nonatomic) IBOutlet UIButton *btnLeaderBoard;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveAds;
@property (weak, nonatomic) IBOutlet UIButton *btnDidCoins;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbStartGame;
@property (weak, nonatomic) IBOutlet UILabel *lbStartOnline;
@property (strong, nonatomic) IBOutlet UIView *viewAds;
@property (strong, nonatomic) IBOutlet UILabel *adsTimer;



@property (nonatomic) NSInteger playerBid;

- (IBAction)didStartGame:(id)sender;
- (IBAction)didStartOnlineGame:(id)sender;
- (IBAction)didLeaderBoard:(id)sender;
- (IBAction)didRemoveAds:(id)sender;
- (IBAction)didInfo:(id)sender;
@end
