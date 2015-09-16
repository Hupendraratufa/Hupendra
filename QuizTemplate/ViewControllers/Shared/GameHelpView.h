//
//  GameHelpViewController.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 13/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHK.h"
#import "SHKVkontakte.h"
#import "SHKItem.h"

@protocol GameHelpViewDelegate <NSObject>

-(void)gameHelpClose;
-(void)gameHelpDidRemoveOndeWrong;
-(void)gameHelpDidRemoveAllCells;
-(void)gameHelpDidCoins;
-(UIView*)shareView;
-(UIViewController*)gameHelpParentVC;
@end


@interface GameHelpView : UIView <SHKSharerDelegate>
{
    SHKSharer *mySharer;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageRu;
@property (weak, nonatomic) IBOutlet UIImageView *imageEn;
@property (nonatomic, assign) id <GameHelpViewDelegate> delegate;
- (IBAction)didVk:(id)sender;
- (IBAction)didFB:(id)sender;
- (IBAction)didRemoveOneWrong:(id)sender;
- (IBAction)didRemoveAllCells:(id)sender;
- (IBAction)didCoins:(id)sender;


@end
