//
//  SGFocusImageItem.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title =  _title;
@synthesize image =  _image;
@synthesize tag =  _tag;
@synthesize link = _link;

- (void)dealloc
{
    [_title release];
    [_link release];
    [_image release];
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag link:(NSString *)link
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
        self.link = link;
    }
    
    return self;
}

+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag link:(NSString *)link
{
    return [[[SGFocusImageItem alloc] initWithTitle:title image:image tag:tag link:link] autorelease];
}
@end
