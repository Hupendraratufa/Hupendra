//
//  AppDelegate.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"
#import "AppSettings.h"
#import "Localization.h"
#import "MKStoreManager.h"
#import "LoginManager.h"
#import "MainViewController.h"
#import "MainViewController_iPhone.h"
#import "MainViewController_iPad.h"
#import "Model.h"
#import "CRFileUtils.h"
#import "GameModel.h"
#import "SHKConfiguration.h"
#import "ShareKitDemoConfigurator.h"
#import "SHKVkontakte.h"
#import <AdColony/AdColony.h>
#import "AppReskManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Localytics.h"
#import <Tapdaq/Tapdaq.h>


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize isEndGame;
@synthesize gameEndCount;
@synthesize strGameEndCount;
@synthesize isAdS;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    isAdS=NO;
    gameEndCount=0;
    strGameEndCount=0;

    NSUserDefaults *stander=[NSUserDefaults standardUserDefaults];
    
    
    if ([stander valueForKey:@"gameCount"]==nil) {
        [stander setObject:@"0" forKey:@"gameCount"];
        [stander setObject:@"0" forKey:@"winCoin"];
        [stander setObject:@"0" forKey:@"lossCoin"];
        [stander setBool:YES forKey:@"isFirstTime"];
       
    }
    
    if ([stander objectForKey:@"installedDate"]==nil)
    {
        [stander setObject:[NSDate date] forKey:@"installedDate"];
    }
    
    [stander synchronize];

    NSMutableDictionary *tapdaqConfig = [[NSMutableDictionary alloc] init];
    
#ifdef DEBUG
     [tapdaqConfig setObject:@YES forKey:@"testAdvertsEnabled"];
#endif
    
    [[Tapdaq sharedSession] setApplicationId:@"55f941ece9eca3f41e3253b5"
         clientKey:@"42c3408f-c6d7-41c7-8ca2-f94d89ccfe14"
           config:tapdaqConfig];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
      //  isEndGame=NO;
      //  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
     //   isEndGame=YES;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    //[Localytics autoIntegrate:@"0b7808e62675c0f6e650e76-f28c6e8a-5b78-11e5-babd-0013a62af900" launchOptions:launchOptions];
    
     [Localytics autoIntegrate:@" 307ff4403b3b6781337440d-e5646c38-5c47-11e5-bb42-0013a62af900" launchOptions:launchOptions];
    
   
    [Localytics tagEvent:@"App open"];
    
    NSDictionary *dictionary = @{@"display units":@"1000", @"age range":@"18"};
    [Localytics tagEvent:@"Options Saved" attributes:dictionary];
    
    NSLog(@"event dictionary ===%@",dictionary);
    
    
    [AdColony configureWithAppID:@"app85710f082dce437ca9" zoneIDs:@[@"vz813738b46300478ab4", @"vz813738b46300478ab4"] delegate:self logging:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] || ![AppSettings  dataImported])
    {
        
        NSString *currentLang = [self systemLanguage];
        
        [Localization instance].locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLang];
        [AppSettings  setCurrentLanguage:currentLang];

        [[MKStoreManager sharedManager] removeAllKeychainData];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    }
    else
    {
        NSString *currentLang = [self systemLanguage];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLang] ;
        [[Localization instance] setLocale:locale];
        [AppSettings  setCurrentLanguage:currentLang];
    }
    
  
    
    DefaultSHKConfigurator *configurator = [[ShareKitDemoConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    [SHK flushOfflineQueue];
    [SHK logoutOfAll];
    [SHKVkontakte logout];


    [[LoginManager sharedInstance] appLaunched];
    
    
    [[MKStoreManager sharedManager] purchasableObjectsDescription];
    
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [application setIdleTimerDisabled:YES];
    application.applicationIconBadgeNumber = 0;
    
    
 
    if (![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS]) {
        
        [[AppReskManager instance]showChartboost_FullScreen];
    }

    
    MainViewController *vc = nil;
    if (isPad)
    {
        vc = [[MainViewController_iPad alloc] initWithNibName:@"MainViewController_iPad" bundle:nil];
    }
    else
    {
        vc = [[MainViewController_iPhone alloc] initWithNibName:@"MainViewController_iPhone" bundle:nil];
    }
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.navigationController.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    if (![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS]) {
        [[AppReskManager instance]showChartboost_FullScreen];
    }
    
    return YES;

}

+(AppDelegate *)shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark:-Handle Back URL For Enetr App From Facebook
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
}




-(NSString*)systemLanguage
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString *localizationLang = [NSString stringWithFormat:@"en_US"];
 
    if ([language isEqualToString:@"ru"])
        localizationLang = @"ru_RU";
    
    return localizationLang;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[Model instance] startTimer:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
      [[LoginManager sharedInstance] appEnterForeground];
    [[MKStoreManager sharedManager] purchasableObjectsDescription];
    
    [[Model instance] startTimer:YES];
    
    [[GameModel sharedInstance] authenticateLocalUser];
    
    if (![MKStoreManager isFeaturePurchased:APP_REMOVE_ADS]) {
        
        [[AppReskManager instance]showChartboost_FullScreen];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [application setIdleTimerDisabled:NO];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}
- (void)clearAllData {
    
    //Erase the persistent store from coordinator and also file manager.
    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
    NSError *error = nil;
    NSURL *storeURL = store.URL;
    [self.persistentStoreCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    
    
    NSLog(@"Data Reset");
    
    //Make new persistent store for future saves
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // do something with the error
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QuizTemplate" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QuizTemplate.sqlite"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {

        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
