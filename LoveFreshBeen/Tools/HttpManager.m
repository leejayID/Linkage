//
//  HttpManager.m
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/17.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"

@implementation HttpManager

+ (instancetype)sharedManager
{
    static HttpManager *shared_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)getDataWithURLString:(NSString *)urlString
                     succeed:(void (^)(id))succeed
                      failed:(void (^)(NSError *))failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (succeed) {
            succeed(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failed) {
            failed(error);
        }
    }];
}

@end
