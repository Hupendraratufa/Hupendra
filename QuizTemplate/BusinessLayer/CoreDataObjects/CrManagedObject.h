//
//  CrCoreData.h
//  Anti-Fat
//
//  Created by Yury Shubin on 18/09/2011.
//  Copyright 2011 EmperorLab. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CrManagedObject :  NSManagedObject  
{
}

+(NSManagedObject*)createObject;
+(void)delete:(NSManagedObject*)object;
+(NSEntityDescription*)entity;
+(NSArray*)allObjects;

@end



