//
//  GameViewControllerOnliner.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 15/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameViewController.h"
#import "playersView.h"
#import "GameCenterManager.h"
#import "WinAlertView.h"

@interface GameViewControllerOnline : GameViewController <WinAlertViewDelegate, UIAlertViewDelegate>
{

}
@property (nonatomic, strong) IBOutlet playersView *playersView;
@property (nonatomic, assign) BOOL isHost;
@property (nonatomic) NSInteger playerBid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil questionIds:(NSString*)str;
@end
