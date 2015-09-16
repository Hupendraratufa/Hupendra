//
//  BannerViewController.h
//  PDD
//
//  Created by Uladzislau Yasnitski on 14/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBannersRequest.h"

@protocol BannertViewDelegate <NSObject>

-(void)bannerDidClose;

@end
@interface BannerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSString *linkString;
@property (nonatomic, assign) id <BannertViewDelegate> delegate;

-(void)showWithBanner:(GetBannersRequestItem*)bannerItem;
- (IBAction)didLink:(id)sender;
- (IBAction)didClose:(id)sender;
@end
