//
//  CRFileUtils.m
//  NeuroUI2
//
//  Created by yurysh on 15.10.09.
//  Copyright 2009 JVL. All rights reserved.
//

#import "CRFileUtils.h"
#import <sys/xattr.h>

@implementation CRFileUtils

+ (NSString *)applicationHiddenDocumentsDirectory {
    // NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@".data"];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [libraryPath stringByAppendingPathComponent:@"Private Documents"];//Private Documents
    
    BOOL isDirectory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        if (isDirectory)
            return path;
        else {
            // Handle error. ".data" is a file which should not be there...
            [NSException raise:@".data exists, and is a file" format:@"Path: %@", path];
            // NSError *error = nil;
            // if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
            //     [NSException raise:@"could not remove file" format:@"Path: %@", path];
            // }
        }
    }
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
        // Handle error.
        [NSException raise:@"Failed creating directory" format:@"[%@], %@", path, error];
    }
    return path;
}

+(NSString*)applicationHiddenDocumentsPath:(NSString *)file
{
    return [NSString stringWithFormat:@"%@/%@",[CRFileUtils applicationHiddenDocumentsDirectory],file];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else { // iOS >= 5.1
        NSError *error = nil;
        [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return error == nil;
    }
    
}

+(NSString*)cachesDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* dir = [NSString stringWithString:[paths objectAtIndex:0]];
    
    return dir;
}

+(NSString*)cachesPath:(NSString *)file
{
    return [NSString stringWithFormat:@"%@/%@", [CRFileUtils cachesDirectory], file];
}

+(NSString*)documentsDirectory
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* dir = [NSString stringWithString:[paths objectAtIndex:0]];
	return dir;
}

+(NSString*)documentPath:(NSString*)file
{
	return [NSString stringWithFormat:@"%@/%@", [CRFileUtils  documentsDirectory], file];
}

+(NSString*)resourcesDirectory
{
	return [[NSBundle mainBundle] bundlePath];
}

+(NSString*)resourcePath:(NSString*)file
{
	return [NSString stringWithFormat:@"%@/%@", [CRFileUtils  resourcesDirectory], file];
}

+(NSString*)resourceOrDocumentPath:(NSString*)file
{
	NSString* path;
	
	path = [self resourcePath:file];
	if([self fileExistsAtPath:path])
		return path;
	
	path = [self documentPath:file];
	if([self fileExistsAtPath:path])
		return path;
	
	return nil;
}

+(NSString*)trimResourcePath:(NSString*)file
{
	NSRange range = [file rangeOfString:[self resourcesDirectory]];
	range.length += 1;
	NSMutableString* str = [NSMutableString stringWithString:file];
	[str deleteCharactersInRange:range];
	return str;
}

+(NSString*)generateFilenameInDirectory:(NSString*)dir extension:(NSString*)extension
{
	for (NSUInteger i = 0; ; ++i)
	{
		NSString* filename = [NSString stringWithFormat:@"%@/%d.%@", dir, i, extension];
		if(![[NSFileManager defaultManager] fileExistsAtPath:filename])
			return [NSString stringWithFormat:@"%d.%@", i, extension];
	}
}

+(BOOL)fileExistsAtPath:(NSString*)path
{
	if( [path hasPrefix:@"~"] )
		path = [path stringByExpandingTildeInPath];
	
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+(BOOL)removeFileAtPath:(NSString*)path
{
	if( [path hasPrefix:@"~"] )
		path = [path stringByExpandingTildeInPath];
    
	return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

+(BOOL)createDirectoryInDocumentsDirectory:(NSString*)dir
{
	return [[NSFileManager defaultManager] createDirectoryAtPath:[self documentPath:dir] withIntermediateDirectories:YES attributes:nil error:NULL];
}

+(NSString*)pathShortName:(NSString*)path
{
	NSArray* strings = [path componentsSeparatedByString:@"/"];
	NSString* str = nil;
	if([strings count] >= 2)
		str = [NSString stringWithFormat:@"%@/%@", [strings objectAtIndex:[strings count] - 2], [strings objectAtIndex:[strings count] - 1]];
	else
		str = [strings objectAtIndex:0];
	
	return str;
}

@end
