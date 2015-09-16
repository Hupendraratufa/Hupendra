//
//  Question.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "Question.h"
#import "QustionInfo.h"
#import "OpenedCell.h"
#import "NSMutableArray+Shuffling.h"
#import "CRFileUtils.h"

@implementation Question

@dynamic questionId;
@dynamic questionAnswers;
@dynamic openedCells;
@dynamic questionRemoveAllCells;

-(NSString*)questionImagePath
{
//    NSLog(@"Image Path - %@",[CRFileUtils resourcePath:[NSString stringWithFormat:@"/Content/%@.jpg",self.questionId]]);
    return [CRFileUtils resourcePath:[NSString stringWithFormat:@"/Content/%@.jpg",self.questionId]];
}
+(NSArray*)questionsByIndexes:(NSString *)ids
{
    
    //    NSLog(@"Qestions ids %@",ids);
    //    ids = @"251:251:251:251:251";
    NSArray *idsArray = [ids componentsSeparatedByString:@":"];
    
    NSMutableArray *result = [NSMutableArray array];
    
    if ([idsArray count] == 5)
    {
        for (NSString *ID in idsArray)
        {
            [result addObject:[self questionById:[NSNumber numberWithInt:[ID intValue]]]];
        }
    }
    else
    {
        for (int i = [result count]; i < 5; i++)
        {
            [result addObject:[self questionById:[NSNumber numberWithInt:(arc4random() % [[Question allObjects] count])]]];
        }
    }
    return result;
    
}

+(Question*)questionById:(NSNumber*)index
{
    NSFetchRequest* request = [DELEGATE.managedObjectModel fetchRequestFromTemplateWithName:@"question_by_index" substitutionVariables:[NSDictionary dictionaryWithObject:index forKey:@"questionId"]];
    
    NSError* error = nil;
    if ([[DELEGATE.managedObjectContext executeFetchRequest:request error:&error] lastObject])
        return [[DELEGATE.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    else
        return [self questionById:[NSNumber numberWithInt:(arc4random() % [[Question allObjects] count])]];
}



+(NSArray*)allQuestions
{
    NSFetchRequest* request = [DELEGATE.managedObjectModel fetchRequestFromTemplateWithName:@"question_sorted_by_id" substitutionVariables:nil];
    
	[request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"questionId" ascending:YES]]];
	NSError* error = nil;
	return [DELEGATE.managedObjectContext executeFetchRequest:request error:&error];
}

//-(NSArray*)allQuestionInfos
//{
//    NSMutableArray *array = [[self.questionAnswers allObjects] mutableCopy];
//    [array shuffle];
//    
//    return array;
//}

-(NSArray*)allQuestionInfos
{
    NSMutableArray *array = [[self.questionAnswers allObjects] mutableCopy];
    
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[array count]; i++) {
        
        QustionInfo *quetionInfo = [array objectAtIndex:i];
        
        NSNumber *iStatus = [NSNumber numberWithBool:YES];
        if ( [quetionInfo.bIsRightAnswer isEqualToNumber:iStatus])
        {
            [newArray addObject:[array objectAtIndex:i]];
            [array removeObjectAtIndex:i];
            break;
        }
    }
    
    for (uint i = 0; i < array.count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = array.count - i;
        int n = arc4random_uniform(nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    for (int i = 0; i<3; i++)
    {
        [newArray addObject:[array objectAtIndex:i]];
    }
    for (uint i = 0; i < newArray.count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = newArray.count - i;
        int n = arc4random_uniform(nElements) + i;
        [newArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    //   [array shuffle];
    
    return newArray;
}


@end
