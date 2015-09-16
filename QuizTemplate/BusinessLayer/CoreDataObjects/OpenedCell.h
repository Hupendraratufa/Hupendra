//
//  OpenedCell.h
//  QuizTemplate
//
//  Created by Vladislav Yasnicki on 17/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CrManagedObject.h"

@class Question;

@interface OpenedCell : CrManagedObject

@property (nonatomic, retain) NSNumber * cellX;
@property (nonatomic, retain) NSNumber * cellY;
@property (nonatomic, retain) Question * question;
@end
