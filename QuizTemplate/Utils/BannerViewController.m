//
//  BannerViewController.m
//  PDD
//
//  Created by Uladzislau Yasnitski on 14/11/13.
//  Copyright (c) 2013 Uladzislau Yasnitski. All rights reserved.
//

#import "BannerViewController.h"
#import "AppSettings.h"
#import "UIViewController+MJPopupViewController.h"
@interface BannerViewController ()

@end

@implementation BannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (isPad)
        nibNameOrNil = @"BannerViewController_iPad";
    else
    {
        nibNameOrNil = @"BannerViewController_iPhone_5";
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showWithBanner:(GetBannersRequestItem *)bannerItem
{
    _linkString = [[NSString alloc] initWithString:bannerItem.link];
    _imageView.image = [UIImage imageWithContentsOfFile:bannerItem.imagePath];
}

- (IBAction)didLink:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_linkString]];
    
    [_delegate bannerDidClose];
}

- (IBAction)didClose:(id)sender {
    [_delegate bannerDidClose];
}

@end
