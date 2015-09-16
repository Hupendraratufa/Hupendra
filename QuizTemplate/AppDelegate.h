//
//  AppDelegate.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (readwrite, nonatomic) BOOL  isEndGame;
@property (readwrite, nonatomic) BOOL  isAdS;
@property(nonatomic,readwrite) int gameEndCount;
@property(readwrite,nonatomic) NSInteger *strGameEndCount;


- (void)saveContext;
-(void)clearAllData;
- (NSURL *)applicationDocumentsDirectory;
+(AppDelegate *)shareAppDelegate;
@end
