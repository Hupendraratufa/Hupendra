//
//  FonQuestion.m
//  GuessTheCar
//
//  Created by Uladzislau Yasnitski on 11/8/13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FonQuestion.h"
#import "Localytics.h"

#define NumberOfColumns 5.0f
#define NumberOfLines 4.0f

@implementation Cell
-(id)initWithCellIndexPath:(NSIndexPath *)indexPath frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _bIsOpen = NO;
        
        _cellIndexPath = indexPath;
        self.image = [UIImage imageNamed:isPad ? @"qe.png" : @"qe_iPhone.png"];
//        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        lb.backgroundColor = [UIColor clearColor];
//        lb.text = [NSString stringWithFormat:@"(%d,%d)",[indexPath row], [indexPath section]];
//        lb.adjustsFontSizeToFitWidth = YES;
//        lb.minimumScaleFactor = 0.5;
//        [self addSubview:lb];
        
        self.userInteractionEnabled = YES;
        
        //        [self setExclusiveTouch:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
    }
    
    return self;
}
-(void)singleTap
{
    [Localytics tagEvent:@" Every time the user removes a \"?\" Tile"];
    if (_bIsOpen)
        return;
   
    if ([_delegate respondsToSelector:@selector(cellCanOpenCell:)])
    {
        if ([_delegate cellCanOpenCell:self])
        {
            
            SystemSoundID toneSSID = 1104;
            AudioServicesPlaySystemSound(toneSSID);
            
            [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                self.image = nil;
            }];
            
            _bIsOpen = YES;
        }
    }
}
@end


@interface FonQuestion ()
{
    
}

@property (nonatomic, strong) NSMutableArray *imageWithIndexes;

@end

@implementation FonQuestion

- (id)initWithFrame:(CGRect)frame openedIndexes:(NSArray *)opened
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGSize cellSize = CGSizeMake(frame.size.width/NumberOfColumns, frame.size.height/NumberOfLines);
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        CGFloat xPosition = 0.0;
        CGFloat yPosition = 0.0;
        
        
        for (int x = 0; x < NumberOfLines; x++)
        {
            for (int y = 0; y < NumberOfColumns; y++)
            {
                CGRect fr;
                fr.origin = CGPointMake(xPosition, yPosition);
                fr.size = cellSize;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:y inSection:x];
                Cell *cell = [[Cell alloc] initWithCellIndexPath:indexPath frame:fr];
                cell.delegate = self;
//                [images setObject:cell forKey:indexPath];
                [images addObject:cell];
                [self addSubview:cell];
                
                if ([opened containsObject:indexPath])
                {
                    [cell removeFromSuperview];
                    [images removeObject:cell];
                }
                xPosition += cellSize.width;
            }
            
            xPosition = 0;
            yPosition += cellSize.height;
        }
        
        _imageWithIndexes = images;
    }
    return self;
}

-(void)removeAllCellsComplection:(void (^)(void))complectionBlock
{
    self.removeComplited = complectionBlock;
    CGFloat delay = 0.5;
    __block NSInteger i = 0;
    __block NSInteger arrayCount = [_imageWithIndexes count];
    
    for (Cell *cell in _imageWithIndexes)
    {
//        [UIView transitionWithView:cell duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//            cell.alpha = 0;
//        } completion:^(BOOL finished) {
//            i++;
//            if (i == arrayCount)
//            {
//                self.removeComplited();
//                self.removeComplited = nil;
//            }
//
//        }];
//        delay += 0.05;
        
        [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            cell.alpha = 0;
            cell.transform = CGAffineTransformMake(
                                                        1, 0, 0, -1, 0, cell.bounds.size.height
                                                        );
        } completion:^(BOOL finished) {
            cell.image = nil;
            i++;
            if (i == arrayCount)
            {
                self.removeComplited();
                self.removeComplited = nil;
            }
        }];
        delay += 0.05;
    }
    
    
}
-(NSInteger)cellsCount
{
    return [_imageWithIndexes count];
}
-(BOOL)cellCanOpenCell:(Cell *)cell
{
    
    if ([_delegate respondsToSelector:@selector(fonQuestionCanOpenVopr:)])
    {
        if ([_delegate fonQuestionCanOpenVopr:cell])
        {
            [_imageWithIndexes removeObject:cell];
            return YES;
        } 
    }
    
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
