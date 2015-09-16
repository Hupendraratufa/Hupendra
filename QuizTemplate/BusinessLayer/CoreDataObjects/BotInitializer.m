//
//  BotInitializer.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 19/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "BotInitializer.h"
#import "CRFileUtils.h"
#import "Bot.h"

@implementation BotInitializer

+(void)initBots
{
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Bots",[CRFileUtils resourcesDirectory]] error:nil];
    
    for (NSString *file in files)
    {
        NSString* name = [file stringByDeletingPathExtension];
   
        Bot *bot = (Bot*)[Bot createObject];
        bot.botName = name;
    }
}

@end
