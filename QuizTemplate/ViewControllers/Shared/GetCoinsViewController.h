//
//  GetCoinsViewController.h
//  QuizTemplate
//
//  Created by Uladzislau Yasnitski on 14/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetCoinsViewDelegate <NSObject>

-(void)getCoinsDismissed;


@end

@interface GetCoinsViewController : UIViewController
@property (nonatomic, assign) id <GetCoinsViewDelegate> delegate;
@end
