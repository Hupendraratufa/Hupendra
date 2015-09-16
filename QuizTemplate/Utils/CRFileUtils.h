//
//  CRFileUtils.h
//  NeuroUI2
//
//  Created by yurysh on 15.10.09.
//  Copyright 2009 JVL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CRFileUtils : NSObject 
{

}
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (NSString*)applicationHiddenDocumentsDirectory;
+ (NSString*)applicationHiddenDocumentsPath:(NSString*)file;
+(NSString*)cachesDirectory;
+(NSString*)cachesPath:(NSString*)file;
+(NSString*)documentsDirectory;
+(NSString*)documentPath:(NSString*)file;
+(NSString*)resourcesDirectory;
+(NSString*)resourcePath:(NSString*)file;
+(NSString*)resourceOrDocumentPath:(NSString*)file;
+(NSString*)trimResourcePath:(NSString*)file;
+(NSString*)generateFilenameInDirectory:(NSString*)dir extension:(NSString*)extension;
+(BOOL)fileExistsAtPath:(NSString*)path;
+(BOOL)removeFileAtPath:(NSString*)path;
+(BOOL)createDirectoryInDocumentsDirectory:(NSString*)dir;
+(NSString*)pathShortName:(NSString*)path;

@end
