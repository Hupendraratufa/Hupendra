//
//  Person.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CrManagedObject.h"


@interface Person : CrManagedObject

@property (nonatomic, retain) NSNumber * coinsBought;
@property (nonatomic, retain) NSNumber * coinsEarned;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSNumber * questionIndex;
@property (nonatomic, retain) NSNumber * cointsTapJoy;
@property (nonatomic, retain) NSNumber * botDraws;
@property (nonatomic, retain) NSNumber * botLoses;
@property (nonatomic, retain) NSNumber * botWins;
@property (nonatomic, retain) NSNumber * winCoin;
@property (nonatomic, retain) NSNumber * lossCoin;


-(NSInteger)numberOfMatches;

-(NSNumber*)allPersonPoints;

@end
