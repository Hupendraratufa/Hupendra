//
//  Person.m
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 11/12/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "Person.h"


@implementation Person

@dynamic coinsBought;
@dynamic coinsEarned;
@dynamic points;
@dynamic questionIndex;
@dynamic cointsTapJoy;
@dynamic botWins;
@dynamic botDraws;
@dynamic botLoses;
@dynamic winCoin;
@dynamic lossCoin;

-(NSInteger)numberOfMatches
{
    return [self.botLoses integerValue] + [self.botWins integerValue] + [self.botDraws integerValue];
}

-(NSNumber*)allPersonPoints
{
    NSInteger value = [self.coinsEarned integerValue] + [self.coinsBought integerValue] + [self.cointsTapJoy integerValue];
    return [NSNumber numberWithInteger:value];
}


@end
