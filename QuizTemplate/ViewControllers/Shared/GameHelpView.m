//
//  GameHelpViewController.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 13/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "GameHelpView.h"
#import "AppSettings.h"
#import "CRFileUtils.h"
#import "MBProgressHUD.h"
#import "Localization.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "Localytics.h"
#import <Tapdaq/Tapdaq.h>

@interface GameHelpView ()

@end

@implementation GameHelpView


-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (IBAction)didVk:(id)sender {
    
    CGRect rect = [[_delegate shareView] bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[_delegate shareView].layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString  *imagePath = [CRFileUtils documentPath:@"tempImage.jpg"];
    [UIImageJPEGRepresentation(capturedImage, 0.95) writeToFile:imagePath atomically:YES];
    
    SHKItem *item = [SHKItem image:[UIImage imageWithContentsOfFile:imagePath] title:[NSString stringWithFormat:@"%@\n%@\n%@",[[Localization instance] stringWithKey:@"txt_appName"], iTunesLink, [[Localization instance] stringWithKey:@"txt_shareTitle"]]];
    
    
    SHKSharer *vk = [[SHKVkontakte alloc] init];
    mySharer = vk;
    mySharer.shareDelegate = self;
    [mySharer setItem:item];
    [mySharer share];
}

- (IBAction)didFB:(id)sender {
    
    [Localytics tagEvent:@" Every time user pressed / opens \"Ask Your Friends\""];

 
    CGRect rect = [[_delegate shareView] bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[_delegate shareView].layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString  *imagePath = [CRFileUtils documentPath:@"tempImage.jpg"];
    [UIImageJPEGRepresentation(capturedImage, 0.95) writeToFile:imagePath atomically:YES];
    
    //__block UIViewController* vc = [_delegate gameHelpParentVC];
    
   // [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    
   // [self facebookInterigration];
    
    [[Tapdaq sharedSession] showInterstitial];
    
    
}

#pragma mark:-FaceBook Functioanlity
-(void)facebookInterigration {
    
    NSLog(@"%@",[FBSDKAccessToken currentAccessToken].tokenString);
    if ( [FBSDKAccessToken currentAccessToken]) {
        
    }else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_friends"]  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                NSLog(@"error==%@",error);
            } else if (result.isCancelled) {
                
                NSLog(@"result.isCancelled==%d",result.isCancelled);
            } else {
                
                
                NSLog(@"%@",result.accessibilityElements);
                NSLog(@"%@",result.grantedPermissions);
                if ([result.grantedPermissions containsObject:@"email"]) {
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         
                         FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                         content.contentURL =
                         [NSURL URLWithString:@"https://www.facebook.com/FacebookDevelopers"];
                         
                         NSLog(@"result==%@",result);
                         
                         if (!error) {
                             NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
                             NSLog(@"%@",[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",[NSString stringWithFormat:@"%@",[result valueForKey:@"id"]]]);
                             
                         }
                     }];
                    
                }
            }
        }];
        
    }
    
}



- (IBAction)didRemoveOneWrong:(id)sender {
   [Localytics tagEvent:@"Every time user presses \"Remove 1 Incorrect Answer\""];
    [_delegate gameHelpDidRemoveOndeWrong];
    [_delegate gameHelpClose];
}

- (IBAction)didRemoveAllCells:(id)sender {
   [Localytics tagEvent:@" Every time user presses \"Remove All Tiles In The Photo\""];
    [_delegate gameHelpDidRemoveAllCells];
    [_delegate gameHelpClose];
}

- (IBAction)didCoins:(id)sender {
    [Localytics tagEvent:@" Every time user presses / opens \"Buy Or Get Coins Free\""];
    [_delegate gameHelpDidCoins];
    [_delegate gameHelpClose];
}

#pragma mark ShareDelegate
- (void)sharerStartedSending:(SHKSharer *)sharer
{
	if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Saving to %@", [[sharer class] sharerTitle])];
}


- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    if (!sharer.quiet)
        [[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Saved!")];
    [_delegate gameHelpClose];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    [[SHKActivityIndicator currentIndicator] hide];
    
    //if user sent the item already but needs to relogin we do not show alert
    if (!sharer.quiet && sharer.pendingAction != SHKPendingShare && sharer.pendingAction != SHKPendingSend)
	{
		[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Error")
                                    message:sharer.lastError!=nil?[sharer.lastError localizedDescription]:SHKLocalizedString(@"There was an error while sharing")
                                   delegate:nil
                          cancelButtonTitle:SHKLocalizedString(@"Close")
                          otherButtonTitles:nil] show];
    }
    if (shouldRelogin) {
        [sharer promptAuthorization];
	}
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    
}

- (void)sharerAuthDidFinish:(SHKSharer *)sharer success:(BOOL)success
{
    
}

@end
