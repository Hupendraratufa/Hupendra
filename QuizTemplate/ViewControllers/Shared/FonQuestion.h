//
//  FonQuestion.h
//  GuessTheCar
//
//  Created by Uladzislau Yasnitski on 11/8/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class Cell;

@protocol CellDelegate <NSObject>

-(BOOL)cellCanOpenCell:(Cell*)cell;

@end

@interface Cell : UIImageView <UIGestureRecognizerDelegate>
{
    BOOL _bIsOpen;
}
-(id)initWithCellIndexPath:(NSIndexPath*)indexPath frame:(CGRect)frame;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, assign) id <CellDelegate> delegate;
@end

@protocol FonQuestionDelegate <NSObject>

-(BOOL)fonQuestionCanOpenVopr:(Cell*)cell;

@end

@interface FonQuestion : UIView <CellDelegate>
@property (nonatomic, assign) id <FonQuestionDelegate> delegate;
@property (nonatomic, copy) void (^removeComplited)();
- (id)initWithFrame:(CGRect)frame openedIndexes:(NSArray*)opened;
-(void)removeAllCellsComplection:(void (^)(void))complectionBlock;
-(NSInteger)cellsCount;
@end
