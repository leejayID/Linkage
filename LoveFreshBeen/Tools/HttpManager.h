//
//  HttpManager.h
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/17.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

+ (instancetype)sharedManager;

- (void)getDataWithURLString:(NSString *)urlString
                     succeed:(void (^)(id response))succeed
                      failed:(void (^)(NSError *error))failed;

@end
