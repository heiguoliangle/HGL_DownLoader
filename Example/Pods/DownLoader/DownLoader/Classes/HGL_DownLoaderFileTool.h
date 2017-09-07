//
//  HGL_DownLoaderFileTool.h
//  DownLoader_Example
//
//  Created by heiguoliangle on 2017/9/6.
//  Copyright © 2017年 heiguoliangle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGL_DownLoaderFileTool : NSObject
+(BOOL)isFileExists:(NSString *)path;
+(long long) fileSzieWithPath:(NSString *)path;

+(void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath;

+(void)removeFileAtPath:(NSString *)path;

@end
