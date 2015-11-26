//
//  JXRequestManager.h
//  JXRequestManagerDemo
//
//  Created by JLee21 on 2015/11/26.
//  Copyright © 2015年 VS7X. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JXRequestHandler)(NSURLResponse *response, NSData *data, NSError *error);

@interface JXRequestManager : NSObject

+ (instancetype)sharedManager;
- (void)addRequest:(NSURLRequest *)request withHandler:(JXRequestHandler)requestHandler;

@end
