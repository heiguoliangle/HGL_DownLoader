//
//  HGL_DownLoader.h
//  DownLoader_Example
//
//  Created by heiguoliangle on 2017/9/6.
//  Copyright © 2017年 heiguoliangle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HGL_DownLoaderPause,
    HGL_DownLoaderDowning,
    HGL_DownLoaderSuccess,
    HGL_DownLoaderFailed
} HGL_DownLoaderState;

typedef void(^DownLoadInfoType)(long long totalSize);
typedef void(^ProgressBlockType)(float progress);
typedef void(^SuccessBlockType)(NSString * filePath);
typedef void(^FailedBlockType)();
typedef void(^StateChangeType)(HGL_DownLoaderState state);





@interface HGL_DownLoader : NSObject

@property(nonatomic,assign,readonly)HGL_DownLoaderState state;
@property(nonatomic,assign,readonly)float downProgress;
@property(nonatomic,copy)DownLoadInfoType downLoadInfo;
@property(nonatomic,copy)StateChangeType stateChange;
@property(nonatomic,copy)ProgressBlockType progess;
@property(nonatomic,copy)SuccessBlockType successBlock;
@property(nonatomic,copy)FailedBlockType failedBlock;



+(instancetype)shareInance;



-(void)downLoadWithURL:(NSURL *)url downLoadInfo:(DownLoadInfoType) downLoadInfo progress:(ProgressBlockType)progress successs:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

-(void) resumeTask;

-(void)pause;

-(void)cancel;

-(void)cancelAndClear;

@end
