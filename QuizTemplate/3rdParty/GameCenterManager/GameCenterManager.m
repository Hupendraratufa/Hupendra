/*
 
 File: GameCenterManager.m
 Abstract: Basic introduction to GameCenter
 
 Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "GameCenterManager.h"
#import "Localization.h"


@implementation GameCenterManager

@synthesize earnedAchievementCache;
@synthesize delegate;
@synthesize presentingViewController;
@synthesize match;
@synthesize playersDict;
@synthesize pendingInvite;
@synthesize pendingPlayersToInvite;
//@synthesize currentPlayer;

static GameCenterManager *sharedManager = nil;
+ (GameCenterManager *) sharedInstance {
    if (!sharedManager) {
        sharedManager = [[GameCenterManager alloc] init];
    }
    return sharedManager;
}

- (id) init
{
	self = [super init];
	if(self!= NULL)
	{
		earnedAchievementCache= NULL;
        
//        if([GameCenterManager isGameCenterAvailable]) {
        
            // this is very important... since we must know if the user logs in/out
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
//        }
	}
	return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	self.earnedAchievementCache= NULL;
    [match release];
    [playersDict release];
	[super dealloc];
}

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        
        userAuthenticated = TRUE;
        
        [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
            
            self.pendingInvite = acceptedInvite;
            self.pendingPlayersToInvite = playersToInvite;
            [self callDelegateOnMainThread:@selector(inviteReceived) withArg:nil error:nil];
        };
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        
        userAuthenticated = FALSE;
    }
}

- (void) callDelegate: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	assert([NSThread isMainThread]);
	if([delegate respondsToSelector: selector])
	{
		if(arg != NULL)
		{
			[delegate performSelector: selector withObject: arg withObject: err];
		}
		else
		{
			[delegate performSelector: selector withObject: err];
		}
	}
	else
	{
		NSLog(@"Missed Method - %@",NSStringFromSelector(selector));
	}
}


- (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
	{
	   [self callDelegate: selector withArg: arg error: err];
	});
}

+ (BOOL) isGameCenterAvailable
{
	// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

-(GKPlayer*)currentLocalPlayer
{
    return [GKLocalPlayer localPlayer];
}

-(GKPlayer*)oppozitePlayer
{
    for (NSString *key in playersDict)
        return [playersDict objectForKey:key];
    
    return nil;
}


- (void) authenticateLocalUser
{
	if([GKLocalPlayer localPlayer].authenticated == NO)
	{
        [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController,NSError *error) {
            if(error == nil)
            {
                if (viewController)
                    [[[DELEGATE.navigationController viewControllers] lastObject] presentViewController:viewController animated:YES completion:nil];
                
                 userAuthenticated = YES;
                [self callDelegateOnMainThread: @selector(processGameCenterAuth:) withArg: NULL error: error];
                [self reloadHighScoresForCategory:kLeaderboardID];
            }
            else
            {
                
            }
        };
	}
}

-(BOOL)isUserAuthenticated
{
    if (![GKLocalPlayer localPlayer].authenticated)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Unavailable" message:@"Player is not signed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    return [GKLocalPlayer localPlayer].authenticated;
}

- (void) reloadHighScoresForCategory: (NSString*) category
{
	GKLeaderboard* leaderBoard= [[[GKLeaderboard alloc] init] autorelease];
	leaderBoard.category= category;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
	{
		[self callDelegateOnMainThread: @selector(reloadScoresComplete:error:) withArg: leaderBoard error: error];
	}];
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category 
{
	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];	
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) 
	 {
		 [self callDelegateOnMainThread: @selector(scoreReported:) withArg: NULL error: error];
	 }];
}

- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete
{
	//GameCenter check for duplicate achievements when the achievement is submitted, but if you only want to report 
	// new achievements to the user, then you need to check if it's been earned 
	// before you submit.  Otherwise you'll end up with a race condition between loadAchievementsWithCompletionHandler
	// and reportAchievementWithCompletionHandler.  To avoid this, we fetch the current achievement list once,
	// then cache it and keep it updated with any new achievements.
	if(self.earnedAchievementCache == NULL)
	{
		[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
		{
			if(error == NULL)
			{
				NSMutableDictionary* tempCache= [NSMutableDictionary dictionaryWithCapacity: [scores count]];
				for (GKAchievement* score in scores)
				{
					[tempCache setObject: score forKey: score.identifier];
				}
				self.earnedAchievementCache= tempCache;
				[self submitAchievement: identifier percentComplete: percentComplete];
			}
			else
			{
				//Something broke loading the achievement list.  Error out, and we'll try again the next time achievements submit.
				[self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: NULL error: error];
			}

		}];
	}
	else
	{
		 //Search the list for the ID we're using...
		GKAchievement* achievement= [self.earnedAchievementCache objectForKey: identifier];
		if(achievement != NULL)
		{
			if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete))
			{
				//Achievement has already been earned so we're done.
				achievement= NULL;
			}
			achievement.percentComplete= percentComplete;
		}
		else
		{
			achievement= [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
			achievement.percentComplete= percentComplete;
			//Add achievement to achievement cache...
			[self.earnedAchievementCache setObject: achievement forKey: achievement.identifier];
		}
		if(achievement!= NULL)
		{
			//Submit the Achievement...
			[achievement reportAchievementWithCompletionHandler: ^(NSError *error)
			{
				 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: achievement error: error];
			}];
		}
	}
}

- (void) resetAchievements
{
	self.earnedAchievementCache= NULL;
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) 
	{
		 [self callDelegateOnMainThread: @selector(achievementResetResult:) withArg: NULL error: error];
	}];
}

- (void) mapPlayerIDtoPlayer: (NSString*) playerID
{
	[GKPlayer loadPlayersForIdentifiers: [NSArray arrayWithObject: playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error)
	{
		GKPlayer* player= NULL;
		for (GKPlayer* tempPlayer in playerArray)
		{
			if([tempPlayer.playerID isEqualToString: playerID])
			{
				player= tempPlayer;
				break;
			}
		}
		[self callDelegateOnMainThread: @selector(mappedPlayerIDToPlayer:error:) withArg: player error: error];
	}];
	
}

-(void)sendStringToAllPeers:(NSString *)dataString
{
    [self.match setDelegate:self];
    
    
    if(self.match == nil)
    {
                NSLog(@"Game Center Manager matchOrSession ivar was not set, this needs to be set with the GKMatch or GKSession before sending or receiving data");
        
        
        return;
    }
    
    NSData *dataToSend = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    GKSendDataMode mode = GKSendDataUnreliable;
       
    NSError *error = nil;

    [self.match sendDataToAllPlayers:dataToSend withDataMode:mode error:&error];
    
    if(error != nil)
    {
        NSLog(@"An error occurred while sending data: %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"Send String - %@",dataString);
    }

}


#pragma mark -
#pragma mark find match with min players
// Add new method, right after authenticateLocalUser
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GameCenterManagerDelegate>)theDelegate {
    
    if (![GameCenterManager isGameCenterAvailable]) return;
    
    _matchStarted = NO;
    matchCanceled = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;
    
//    if (pendingInvite != nil) {
//        
//        [presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithInvite:pendingInvite] autorelease];
//        mmvc.matchmakerDelegate = self;
//        [presentingViewController presentViewController:mmvc animated:YES completion:nil];
//        
//        self.pendingInvite = nil;
//        self.pendingPlayersToInvite = nil;
//        
//    } else {
//        
//        // with minPlayers/maxPlayers we define how many players our multiplayer
//        // game may or must have
//        [presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
//        request.minPlayers = minPlayers;
//        request.maxPlayers = maxPlayers;
//        request.playersToInvite = pendingPlayersToInvite;
//        
//        GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
//        mmvc.matchmakerDelegate = self;
//        
//        [presentingViewController presentViewController:mmvc animated:YES completion:nil];
//        
//        self.pendingInvite = nil;
//        self.pendingPlayersToInvite = nil;
//    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.presentingViewController.view];
    [self.presentingViewController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = [[Localization instance] stringWithKey:@"txt_search"];
    [HUD show:YES];
    HUD.allowsCancelation = YES;
    
    [self performSelector:@selector(playWithBots) withObject:nil afterDelay:15];
    
    
    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *theMatch, NSError *error) {
        
        if (error)
        {
            
            NSLog(@"Error finding match: %@", error.localizedDescription);
            
        }
        else
        {
            self.match = theMatch;
            theMatch.delegate = self;
            
            if (!_matchStarted && theMatch.expectedPlayerCount == 0 && !matchCanceled) {
                [self lookupPlayers];
            }
        }
    }];
}

#pragma mark -
#pragma mark get players info

- (void)lookupPlayers {
    
    NSLog(@"Looking up %lu players...", (unsigned long)match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (!matchCanceled)
        {
            if (error != nil) {
                NSLog(@"Error retrieving player info: %@", error.localizedDescription);
                _matchStarted = NO;

                [self callDelegateOnMainThread:@selector(matchEnded) withArg:nil error:nil];
            } else {
                
                // Populate players dict
//                matchStarted = YES;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:players.count];
                for (GKPlayer *player in players) {
                    NSLog(@"Found player: %@ with Player ID - %@", player.alias, player.playerID);
                    [dic setObject:player forKey:player.playerID];
                }
                
                [playersDict release];
                playersDict = [dic retain];
                [dic release];
                
                NSLog(@"My Id - %ld",(long)[[[[[self currentLocalPlayer] playerID] componentsSeparatedByString:@":"] lastObject] integerValue]);
                
                BOOL isServer = NO;
                if ([[[[[self currentLocalPlayer] playerID] componentsSeparatedByString:@":"] lastObject] integerValue] > [[[[[self oppozitePlayer] playerID] componentsSeparatedByString:@":"] lastObject] integerValue])
                {
                    isServer = YES;
                    NSLog(@"IsServer YES");
                }

                [self callDelegateOnMainThread:@selector(matchStartedWithBestPlayer:) withArg:[NSNumber numberWithBool:isServer] error:nil];

           }
        }
    }];
    
}
#pragma mark GKMatchmakerViewControllerDelegate
// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
    
    UIAlertView *resetAlert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
    [resetAlert show];
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.match = theMatch;
    match.delegate = self;
    if (!_matchStarted && match.expectedPlayerCount == 0) {
        [self callDelegateOnMainThread:@selector(gameStartLookUpPlayers) withArg:nil error:nil];
        // Add inside matchmakerViewController:didFindMatch, right after @"Ready to start match!":
        [self lookupPlayers];
    }
}

#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    if (match != theMatch)
    {
        NSLog(@"match != theMatch RETURN");
        return;
    }
    NSString* dataString = [NSString stringWithUTF8String:[data bytes]];
    
    NSLog(@"DID RECEIVE DATA - %@ %@", dataString, isPhone ? @"phone4" : @"phone5");
    
    if (dataString)
    {
        NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:dataString, playerID, match, nil] forKeys:[NSArray arrayWithObjects:@"data", @"peer", @"session", nil]];
        
        [self callDelegateOnMainThread: @selector(gameReceivedData:) withArg: dataDictionary error: nil];
    }
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    
    if (match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected:
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!_matchStarted && theMatch.expectedPlayerCount == 0) {
                
                NSLog(@"Ready to start match!");
                [self lookupPlayers];
            }
            
            break;
        case GKPlayerStateDisconnected:
            // a player just disconnected.
            NSLog(@"Player disconnected!");
            _matchStarted = NO;
            [self callDelegateOnMainThread:@selector(matchEnded) withArg:nil error:nil];
            break;
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    _matchStarted = NO;
    [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    _matchStarted = NO;
    [delegate matchEnded];
}

#pragma mark MBProgressHUDDelegate
-(void)hudDidCancel{
   
    [[GKMatchmaker sharedMatchmaker] cancel];
    matchCanceled = YES;
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    
}

-(void)cancelFindMath
{
    [[GKMatchmaker sharedMatchmaker] cancel];
    match = nil;
    _matchStarted = NO;
    matchCanceled = YES;
}

-(void)playWithBots
{
    if (!_matchStarted)
    {
        [self cancelFindMath];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameCenterNotFound" object:nil];

    }
}

//-(void)hudWasHidden:(MBProgressHUD *)hud
//{
//    
//}

@end
