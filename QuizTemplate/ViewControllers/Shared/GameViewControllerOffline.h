//
//  GameViewControllerOffline.h
//  QuizTemplate
//
//  Created by Vladislav Yasnicki on 16/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewController.h"
#import "GameHelpView.h"
#import "WinAlertViewOffline.h"
#import "LeaderBoardView.h"

@interface GameViewControllerOffline : GameViewController <GameHelpViewDelegate, GKLeaderboardViewControllerDelegate, WinAlertViewDelegate,WinAlertViewDelegate1>

@property (nonatomic, strong) IBOutlet GameHelpView *gameHelp_EN;
@property (strong, nonatomic) IBOutlet GameHelpView *gameHelp_RU;
@property (nonatomic, assign) BOOL languageIsRU;
@property(strong,nonatomic)IBOutlet UIView *leaderBoardView;
-(IBAction)didDismissView:(id)sender;
@end
