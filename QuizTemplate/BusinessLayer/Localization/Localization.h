//
//  Localization.h
//  Anti-Fat
//
//  Created by Yury Shubin on 5/12/2011.
//  Copyright 2011 IntellectSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localization : NSObject 
{
	NSMutableDictionary* _strings;	
	NSMutableDictionary* _images;
	NSMutableDictionary* _rects;

	NSLocale* _locale;
}

+(Localization*)instance;
+(void)shutdown;
-(NSString*)stringWithKey:(NSString*)key;
-(UIImage*)imageWithKey:(NSString*)key;
-(CGRect)rectWithKey:(NSString*)key;

@property(nonatomic, retain) NSLocale* locale;

@end
