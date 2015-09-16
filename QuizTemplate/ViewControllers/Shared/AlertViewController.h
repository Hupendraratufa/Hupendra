//
//  AlertViewController.h
//  GuessTheCar2
//
//  Created by Uladzislau Yasnitski on 20/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class AlertViewController;

@protocol AlertViewControllerDelegate <NSObject>

-(void)alertControllerDidClose:(AlertViewController*)alert withButtonTag:(NSInteger)btnTag;
-(void)alertDidDismissed:(AlertViewController*)alert;
@end

@interface AlertViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (nonatomic) NSInteger tag;
@property (nonatomic, assign) id <AlertViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL showMailController;
-(id)initWithMessage:(NSString*)message button1Title:(NSString*)btn1Title button2Title:(NSString *)btn2Title;

@end
