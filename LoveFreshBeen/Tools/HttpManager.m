//
//  HttpManager.m
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/17.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

static HttpManager *shared_manager = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_manager = [[self alloc]init];
    });
    return shared_manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_manager = [super allocWithZone:zone];
    });
    return shared_manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return shared_manager;
}

- (void)getDataWithURLString:(NSString *)urlString succeed:(Succeed)succeed failed:(Failed)failed {
    
}

@end
