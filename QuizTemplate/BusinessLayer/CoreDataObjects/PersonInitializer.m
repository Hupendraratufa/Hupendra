//
//  PersonInitializer.m
//  AudioQuiz
//
//  Created by Vladislav on 4/8/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "PersonInitializer.h"
#import "Person.h"

@implementation PersonInitializer

+(BOOL)initializePerson{
    
    Person *person = (Person*)[Person createObject];

    person.coinsEarned = [NSNumber numberWithInteger:100];
// person.earnedPoints = [NSNumber numberWithInteger:2500 + rand() % 1000];
    person.coinsBought = [NSNumber numberWithInteger:0];
    person.cointsTapJoy = [NSNumber numberWithInteger:0];
    person.questionIndex = [NSNumber numberWithInteger:0];
    person.points = [NSNumber numberWithInteger:0];
    person.botDraws = [NSNumber numberWithInteger:0];
    person.botLoses = [NSNumber numberWithInteger:0];
    person.botWins = [NSNumber numberWithInteger:0];
    person.winCoin = [NSNumber numberWithInteger:0];
    person.lossCoin = [NSNumber numberWithInteger:0];
    return YES;
}

@end
