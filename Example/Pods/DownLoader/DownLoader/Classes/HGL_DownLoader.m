

//
//  HGL_DownLoader.m
//  DownLoader_Example
//
//  Created by heiguoliangle on 2017/9/6.
//  Copyright © 2017年 heiguoliangle. All rights reserved.
//

#import "HGL_DownLoader.h"
#import "NSString+MD5.h"
#import "HGL_DownLoaderFileTool.h"

#define kCache     NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

#define kTmp NSTemporaryDirectory()


@interface HGL_DownLoader()<NSURLSessionDataDelegate>
{
    long long _tempFileSize;
    long long _totalFileSize;
}

@property(nonatomic,copy)NSString * cacheFilePath;
@property(nonatomic,copy)NSString * temFilePath;

@property(nonatomic,strong)NSURLSession * session;
@property(nonatomic,strong)NSOutputStream * outputStream;

@property(nonatomic,weak)NSURLSessionDataTask * task;
@end

@implementation HGL_DownLoader


+(instancetype)shareInance{
    static HGL_DownLoader * downLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downLoader = [[HGL_DownLoader alloc]init];
    });
    return downLoader;
    
    
}

-(void)downLoadWithURL:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progress successs:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    
    NSLog(@"%@",kCache);
    self.downLoadInfo = downLoadInfo;
    self.progess = progress;
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    [self downLoadWithURL:url];
    
    
}


-(void)downLoadWithURL:(NSURL *)url{
    
    self.cacheFilePath = [kCache stringByAppendingPathComponent:url.lastPathComponent];
    self.temFilePath = [kTmp stringByAppendingPathComponent:[url.absoluteString md5]];
    if ([HGL_DownLoaderFileTool isFileExists:self.cacheFilePath]) {
        NSLog(@"文件已经下载完毕");
        self.state = HGL_DownLoaderSuccess;
        return;
    }
    _tempFileSize = [HGL_DownLoaderFileTool fileSzieWithPath:self.temFilePath];
    
    
    
    
    if ([url isEqual:self.task.originalRequest.URL]) {
        
        if (self.state == HGL_DownLoaderPause) {
//            [self resumeTask];
            [self downloadWithURL:url offset:_tempFileSize];
            return;
        }
    }
    
    
//    [self cancelTask];
    
    self.state = HGL_DownLoaderPause;
    [self downloadWithURL:url offset:_tempFileSize];
    
}


- (void)resumeTask {
    if (self.task && self.state == HGL_DownLoaderPause) {
        [self.task resume];
        self.state = HGL_DownLoaderDowning;
    }
}

-(void)pause{
    if (self.state == HGL_DownLoaderDowning) {
        
        [self.task suspend];
        self.state = HGL_DownLoaderPause;
    }
}

- (void)cancelTask {
    self.session = nil;
    [self.session invalidateAndCancel];
    self.state = HGL_DownLoaderPause;
}

-(void)cancel{
    
    
    if (self.state == HGL_DownLoaderDowning) {
        
        [self.session invalidateAndCancel];
        self.session = nil;
        [HGL_DownLoaderFileTool removeFileAtPath: self.temFilePath];
    }else{
        NSLog(@"现在还没有下载任务");
    }
    
}


-(void)cancelAndClear{
    [self cancel];
    [HGL_DownLoaderFileTool removeFileAtPath:self.cacheFilePath];
}


- (void)downloadWithURL:(NSURL *)url offset:(long long)offset {
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-",offset] forHTTPHeaderField:@"Range"];
    self.task= [self.session dataTaskWithRequest:request];
    
    [self resumeTask];
    
}



#pragma mark - 代理

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@",httpResponse);
    _totalFileSize = [httpResponse.allHeaderFields[@"Content-Length"]longLongValue];
    NSString * contentRangStr = httpResponse.allHeaderFields[@"Content-Range"];
    if (contentRangStr.length > 0) {
    
        _totalFileSize = [[[contentRangStr componentsSeparatedByString:@"/"]lastObject]longLongValue];
    }
    if (self.downLoadInfo) {
        self.downLoadInfo(_totalFileSize);
    }
    
    if (_tempFileSize == _totalFileSize) {
        [HGL_DownLoaderFileTool moveFile:self.temFilePath toPath:self.cacheFilePath];
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    if (_tempFileSize > _totalFileSize) {
        [HGL_DownLoaderFileTool removeFileAtPath:self.temFilePath];
        completionHandler(NSURLSessionResponseCancel);
        [self downloadWithURL:response.URL offset:0];
        return;
    }
    self.state = HGL_DownLoaderDowning;
    
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.temFilePath append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    
    _tempFileSize += data.length;
    self.downProgress = 1.0 * _tempFileSize / _totalFileSize;
    
    [self.outputStream write:data.bytes maxLength:data.length];
    
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    [self.outputStream close];
    self.outputStream = nil;
    
    if (error == nil) {
        NSLog(@"下载成功");
        [HGL_DownLoaderFileTool moveFile:self.temFilePath toPath:self.cacheFilePath];
        self.state = HGL_DownLoaderSuccess;
    }else{
        NSLog(@"下载失败");
        if (-999 == error.code) {
            self.state = HGL_DownLoaderPause;
        }else{
            self.state = HGL_DownLoaderFailed;
        }
        
        
        
    }
    
    
}



#pragma mark - 懒加载

-(NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

-(void)setState:(HGL_DownLoaderState)state{
    if (_state == state) {
        return;
    }
    _state = state;
    
    if (self.stateChange) {
        self.stateChange(state);
    }
    if (state == HGL_DownLoaderSuccess && self.successBlock) {
        self.successBlock(self.cacheFilePath);
    }
    
    if (state == HGL_DownLoaderFailed && self.failedBlock) {
        
        self.failedBlock();
        
        
    }
    
    
}


-(void)setDownProgress:(float)downProgress{
    _downProgress = downProgress;
    
    if (self.progess) {
        self.progess(downProgress);
    }
    
    
    
}

@end
