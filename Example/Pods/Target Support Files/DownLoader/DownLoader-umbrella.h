#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HGL_DownLoader.h"
#import "HGL_DownLoaderFileTool.h"
#import "NSString+MD5.h"

FOUNDATION_EXPORT double DownLoaderVersionNumber;
FOUNDATION_EXPORT const unsigned char DownLoaderVersionString[];

