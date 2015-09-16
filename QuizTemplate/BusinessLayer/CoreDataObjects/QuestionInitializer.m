//
//  QuestionInitializer.m
//  AudioQuiz
//
//  Created by Vladislav on 4/8/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "QuestionInitializer.h"
#import "Question.h"
#import "QustionInfo.h"
#import "SBJsonParser.h"
#import "AppSettings.h"
#import "CRFileUtils.h"
#import "OpenedCell.h"

@implementation QuestionInitializer

/*
+(BOOL)initializeCoreData
{

    NSString *json = [NSString stringWithContentsOfFile:[CRFileUtils resourcePath:@"base.json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* obj = [[SBJsonParser new] objectWithString:json];
	NSDictionary* workbook = [obj objectForKey:@"Workbook"];
	NSDictionary* worksheet = [workbook objectForKey:@"Worksheet"];
	NSDictionary* table = [worksheet objectForKey:@"Table"];
	NSArray* rows = [table objectForKey:@"Row"];
    
    for (NSUInteger iRow = 0; iRow < [rows count]; ++iRow)
    {
        NSDictionary* row =[rows objectAtIndex:iRow];
        NSArray *cells = [row objectForKey:@"Cell"];
        
        if ([cells count] != 4)
        {
            NSLog(@"DELEtequestionId - %@", [NSNumber numberWithInteger:iRow+1]);
            continue;
        }
        Question* question = (Question*)[Question createObject];
        question.questionId = [NSNumber numberWithInteger:iRow+1];
        question.questionRemoveAllCells = [NSNumber numberWithBool:NO];
        //temp Opened Cell
        OpenedCell *op = (OpenedCell*)[OpenedCell createObject];
        op.cellX = [NSNumber numberWithInt:200];
        op.cellY = [NSNumber numberWithInt:200];
        op.question = question;
        //
        

        for (NSUInteger i = 0; i < [cells count]; i++)
        {
            NSDictionary* cell = [cells objectAtIndex:i];
            NSDictionary* data = [cell objectForKey:@"Data"];
            NSString * text = [data objectForKey:@"#text"];
            
            if (text == nil && i != 0)
            {
                [Question delete:question];
                question = nil;
                break;
            }
            
            switch (i) {
               
                case 0:
                {
                    QustionInfo *answer = (QustionInfo*)[QustionInfo createObject];
                    answer.index = [NSNumber numberWithInt:i-1];
                    answer.bIsRightAnswer = [NSNumber numberWithBool:YES];
                    answer.title = text;
                    answer.bIsRemoved = [NSNumber numberWithBool:NO];
                    answer.question = question;
                }
                    break;
                case 1:
                {
                    QustionInfo *answer = (QustionInfo*)[QustionInfo createObject];
                    answer.index = [NSNumber numberWithInt:i-1];
                    answer.bIsRightAnswer = [NSNumber numberWithBool:NO];
                    answer.title = text;
                    answer.bIsRemoved = [NSNumber numberWithBool:NO];
                    answer.question = question;
                }
                    break;
                case 2:
                {
                    QustionInfo *answer = (QustionInfo*)[QustionInfo createObject];
                    answer.index = [NSNumber numberWithInt:i-1];
                    answer.bIsRightAnswer = [NSNumber numberWithBool:NO];
                    answer.title = text;
                    answer.bIsRemoved = [NSNumber numberWithBool:NO];
                    answer.question = question;
                    
                }
                    break;
                case 3:
                {
                    QustionInfo *answer = (QustionInfo*)[QustionInfo createObject];
                    answer.index = [NSNumber numberWithInt:i-1];
                    answer.bIsRightAnswer = [NSNumber numberWithBool:NO];
                    answer.title = text;
                    answer.bIsRemoved = [NSNumber numberWithBool:NO];
                    answer.question = question;
                    
                }
                    break;
                default:
                    break;
            }
            
        }
        
        //        if (![CRFileUtils fileExistsAtPath:question.questionImagePath])
        //            NSLog(@"file EMPTY");
        
    }

    return YES;
}
*/

+(BOOL)initializeCoreData
{
    
    NSString *json = [NSString stringWithContentsOfFile:[CRFileUtils resourcePath:@"base.json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* obj = [[SBJsonParser new] objectWithString:json];
    NSDictionary* workbook = [obj objectForKey:@"Workbook"];
    NSDictionary* worksheet = [workbook objectForKey:@"Worksheet"];
    NSDictionary* table = [worksheet objectForKey:@"Table"];
    
    NSArray* rows = [table objectForKey:@"Row"];
    
    for (NSUInteger iRow = 0; iRow < [rows count]; ++iRow)
    {
        NSDictionary* row =[rows objectAtIndex:iRow];
        NSArray *cells = [row objectForKey:@"Cell"];
        
        //        if ([cells count] != 4)
        //        {
        //            NSLog(@"DELEtequestionId - %@", [NSNumber numberWithInteger:iRow+1]);
        //            continue;
        //        }
        Question* question = (Question*)[Question createObject];
        question.questionId = [NSNumber numberWithInteger:iRow+1];
        question.questionRemoveAllCells = [NSNumber numberWithBool:NO];
        //temp Opened Cell
        OpenedCell *op = (OpenedCell*)[OpenedCell createObject];
        op.cellX = [NSNumber numberWithInt:200];
        op.cellY = [NSNumber numberWithInt:200];
        op.question = question;
        //
        
        
        for (NSUInteger i = 0; i < [cells count]; i++)
        {
            NSDictionary* cell = [cells objectAtIndex:i];
            NSDictionary* data = [cell objectForKey:@"Data"];
            NSString * text = [data objectForKey:@"#text"];
            
            if (text == nil && i != 0)
            {
                [Question delete:question];
                question = nil;
                break;
            }
            if (i == 0)
            {
                QustionInfo *answer = (QustionInfo*)[QustionInfo createObject];
                answer.index = [NSNumber numberWithInt:i-1];
                answer.bIsRightAnswer = [NSNumber numberWithBool:YES];
                answer.title = text;
                answer.bIsRemoved = [NSNumber numberWithBool:NO];
                answer.question = question;
            }
            else
            {
                QustionInfo *answer = (QustionInfo*)[QustionInfo createObject];
                answer.index = [NSNumber numberWithInt:i-1];
                answer.bIsRightAnswer = [NSNumber numberWithBool:NO];
                answer.title = text;
                answer.bIsRemoved = [NSNumber numberWithBool:NO];
                answer.question = question;
                
            }
            //            switch (i) {
            //
            //                case 0:
            //                {
            //                                   }
            //                    break;
            //                case 1:
            //                {
            //                                 }
            //                    break;
            //                case 2:
            //                {
            //                    QustionInfo *answer = (QustionInfo*)[QustionInfo createObject];
            //                    answer.index = [NSNumber numberWithInt:i-1];
            //                    answer.bIsRightAnswer = [NSNumber numberWithBool:NO];
            //                    answer.title = text;
            //                    answer.bIsRemoved = [NSNumber numberWithBool:NO];
            //                    answer.question = question;
            //
            //                }
            //                    break;
            //                case 3:
            //                {
            //                    QustionInfo *answer = (QustionInfo*)[QustionInfo createObject];
            //                    answer.index = [NSNumber numberWithInt:i-1];
            //                    answer.bIsRightAnswer = [NSNumber numberWithBool:NO];
            //                    answer.title = text;
            //                    answer.bIsRemoved = [NSNumber numberWithBool:NO];
            //                    answer.question = question;
            //                    
            //                }
            //                    break;
            //                default:
            //                    break;
            //            }
            
        }
        
        //        if (![CRFileUtils fileExistsAtPath:question.questionImagePath])
        //            NSLog(@"file EMPTY");
        
    }
    
    return YES;
}
@end
