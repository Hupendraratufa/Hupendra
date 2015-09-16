//
//  Bot.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 18/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "Bot.h"
#import "CRFileUtils.h"

@implementation Bot
@dynamic botName;

-(NSString*)botImagePath
{
    return [NSString stringWithFormat:@"%@/Bots/%@.jpg",[CRFileUtils resourcesDirectory],self.botName];
}

+(Bot*)randomBot
{
    NSArray *bots = [Bot allObjects];
    return [bots lastObject];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entity]];
    
    NSInteger myEntityCount = [DELEGATE.managedObjectContext countForFetchRequest:request error:nil];
    NSInteger offset = myEntityCount - (arc4random() % myEntityCount);
    [request setFetchOffset:offset];
    [request setFetchLimit:1];

    NSError* error = nil;

    return [[DELEGATE.managedObjectContext executeFetchRequest:request error:&error] lastObject];
}

@end
