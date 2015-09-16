//
//  Bot.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 18/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CrManagedObject.h"

@interface Bot : CrManagedObject

@property (nonatomic, retain) NSString *botName;

-(NSString*)botImagePath;
+(Bot*)randomBot;
@end
