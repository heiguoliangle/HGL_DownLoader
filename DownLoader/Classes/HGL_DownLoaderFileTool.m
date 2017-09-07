
//
//  HGL_DownLoaderFileTool.m
//  DownLoader_Example
//
//  Created by heiguoliangle on 2017/9/6.
//  Copyright © 2017年 heiguoliangle. All rights reserved.
//

#import "HGL_DownLoaderFileTool.h"

@implementation HGL_DownLoaderFileTool

+(BOOL)isFileExists:(NSString *)path{
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}
+(long long)fileSzieWithPath:(NSString *)path{
    if (![self isFileExists:path]) {
        return  0;
    }
    NSDictionary * fileInfo = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
    long long size = [fileInfo[NSFileSize] longLongValue];
    return size;
    
    
}

+(void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath{
    if (![self isFileExists:fromPath]) {
        return;
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
}

+(void)removeFileAtPath:(NSString *)path{
    
    [[NSFileManager defaultManager]removeItemAtPath:path error:NULL];
    
    
}


@end
