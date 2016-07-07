//
//  HttpManager.h
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/17.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Succeed)(id result);
typedef void(^Failed)(NSError *error);

@interface HttpManager : NSObject 

+ (instancetype)sharedManager;

- (void)getDataWithURLString:(NSString *)urlString succeed:(Succeed)succeed failed:(Failed)failed;

@end
