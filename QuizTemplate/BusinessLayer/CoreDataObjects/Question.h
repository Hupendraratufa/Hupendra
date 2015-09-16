//
//  Question.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CrManagedObject.h"

@class QustionInfo;
@class OpenedCell;

@interface Question : CrManagedObject

@property (nonatomic, retain) NSNumber * questionId;
@property (nonatomic, retain) NSSet *questionAnswers;
@property (nonatomic, retain) NSSet *openedCells;
@property (nonatomic, retain) NSNumber *questionRemoveAllCells;


+(NSArray*)allQuestions;
+(NSArray*)questionsByIndexes:(NSString*)ids;

-(NSArray*)allQuestionInfos;
-(NSString*)questionImagePath;

@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addQuestionAnswersObject:(QustionInfo *)value;
- (void)removeQuestionAnswersObject:(QustionInfo *)value;
- (void)addQuestionAnswers:(NSSet *)values;
- (void)removeQuestionAnswers:(NSSet *)values;

- (void)addOpenedCellsObject:(OpenedCell *)value;
- (void)removeOpenedCellsObject:(OpenedCell *)value;
- (void)addOpenedCells:(NSSet *)values;
- (void)removeOpenedCells:(NSSet*)values;
@end
