//
//  Localization.m
//  Anti-Fat
//
//  Created by Yury Shubin on 5/12/2011.
//  Copyright 2011 IntellectSoft. All rights reserved.
//

#import "Localization.h"
#import "TBXML.h"

Localization* _localizationInstance = nil;

@implementation Localization

@synthesize locale = _locale;

-(void)load
{
	NSString* path = [[NSBundle mainBundle] pathForResource:[_locale localeIdentifier] ofType:@"xml" inDirectory:@"Localization"];	
	NSString* directory = [NSString stringWithFormat:@"Localization/%@", [_locale localeIdentifier]];
	TBXML* tbxml = [TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:path]];
	TBXMLElement* root = tbxml.rootXMLElement;
	if([[TBXML elementName:root] isEqualToString:@"localization"])
	{
	 	TBXMLElement* child = root->firstChild;
		do 
		{
			NSString* name = [TBXML elementName:child];
			NSString* key = [TBXML valueOfAttributeNamed:@"key" forElement:child];
			NSString* value = [TBXML valueOfAttributeNamed:@"value" forElement:child];			
			if([name isEqualToString:@"string"])
				[_strings setObject:value forKey:key];			
			else if([name isEqualToString:@"image"]) 
			{

                    value = [NSString stringWithFormat:@"%@@2x",value];

                NSString* imagePath = [[NSBundle mainBundle] pathForResource:value ofType:@"png" inDirectory:directory];	
                
#ifndef NDEBUG				
				NSAssert1(imagePath, @"there is no %@", value);
#endif
				[_images setObject:imagePath forKey:key];
			}
            else if ([name isEqualToString:@"imageJpg"])
            {
                value = [NSString stringWithFormat:@"%@@2x",value];

				
                NSString* imagePath = [[NSBundle mainBundle] pathForResource:value ofType:@"jpg" inDirectory:directory];	
                
#ifndef NDEBUG				
				NSAssert1(imagePath, @"there is no %@", value);
#endif
				[_images setObject:imagePath forKey:key];
            }
			else if([name isEqualToString:@"rect"]) 
			{
				CGPoint pt = CGPointZero;
				pt.x = [[TBXML valueOfAttributeNamed:@"x" forElement:child] intValue];
				pt.y = [[TBXML valueOfAttributeNamed:@"y" forElement:child] intValue];
				CGSize sz = CGSizeZero;
				sz.width = [[TBXML valueOfAttributeNamed:@"width" forElement:child] intValue];
				sz.height = [[TBXML valueOfAttributeNamed:@"height" forElement:child] intValue];
				CGRect rc;
				rc.origin = pt;
				rc.size = sz;
				[_rects setObject:[NSValue valueWithCGRect:rc] forKey:key];
			}
			
		} while ((child = child->nextSibling));
	}
}

-(void)setLocale:(NSLocale*)value
{
	if(_locale != value)
	{
		[_locale release];
		_locale = [value retain];
		[_strings removeAllObjects];
		[_images removeAllObjects];
		[_rects removeAllObjects];
		[self load];		
	}
}

-(id)init
{
	if((self = [super init]) != nil)
	{
		NSString* lastLocale = [[NSUserDefaults standardUserDefaults] stringForKey:@"locale"];
		if(!lastLocale)
			lastLocale = @"en_US";
			
		_strings = [[NSMutableDictionary alloc] init];
		_images = [[NSMutableDictionary alloc] init];
		_rects = [[NSMutableDictionary alloc] init];
		self.locale = [[[NSLocale alloc] initWithLocaleIdentifier:lastLocale] autorelease];
	}
	return self;
}

+(Localization*)instance
{
	if(!_localizationInstance)
		_localizationInstance = [[Localization alloc] init];
	
	return _localizationInstance;
}

+(void)shutdown
{
	[[NSUserDefaults standardUserDefaults] setObject:[[self instance].locale localeIdentifier] forKey:@"locale"];
}

-(NSString*)stringWithKey:(NSString*)key
{
	return [_strings valueForKey:key];
}

-(UIImage*)imageWithKey:(NSString*)key
{
    return [UIImage imageWithContentsOfFile:[_images valueForKey:key]];
}

-(CGRect)rectWithKey:(NSString*)key
{
	return [[_rects valueForKey:key] CGRectValue];
}

@end
