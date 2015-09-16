//
//  QustionInfo.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CrManagedObject.h"

@class Question;

@interface QustionInfo : CrManagedObject

@property (nonatomic, retain) NSNumber * bIsRightAnswer;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Question *question;
@property (nonatomic, retain) NSNumber * bIsRemoved;

@end
