// 
//  CrCoreData.m
//  Anti-Fat
//
//  Created by Yury Shubin on 18/09/2011.
//  Copyright 2011 EmperorLab. All rights reserved.
//

#import "CrManagedObject.h"


@implementation CrManagedObject 

+(NSManagedObject*)createObject
{
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
															inManagedObjectContext:DELEGATE.managedObjectContext];
}

+(void)delete:(NSManagedObject*)object
{
	if(object)
		[DELEGATE.managedObjectContext deleteObject:object];
}

+(NSEntityDescription*)entity
{
	return [NSEntityDescription entityForName:NSStringFromClass([self class])
					   inManagedObjectContext:DELEGATE.managedObjectContext];
}

+(NSArray*)allObjects
{
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[self entity]];
	NSError* error = nil;
	return [DELEGATE.managedObjectContext executeFetchRequest:fetchRequest error:&error];	
}

@end
