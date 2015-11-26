//
//  JXRequestManager.m
//  JXRequestManagerDemo
//
//  Created by JLee21 on 2015/11/26.
//  Copyright © 2015年 VS7X. All rights reserved.
//

#import "JXRequestManager.h"

#define DEFAULT_CONCURRENTOPERATION 1

@interface JXRequestManager()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray   *operations;
@end

@implementation JXRequestManager

+ (instancetype)sharedManager
{
    static JXRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JXRequestManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = DEFAULT_CONCURRENTOPERATION;
    }
    return self;
}

- (void)addRequest:(NSURLRequest *)request withHandler:(JXRequestHandler)requestHandler
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            requestHandler(response, data, error);
        }];
        [task resume];
    }];
    [_operationQueue addOperation:operation];
}

@end
