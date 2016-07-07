//
//  SupermarketModel.m
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/16.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import "SupermarketModel.h"

@implementation CategoryModel

+ (void)load {
    [CategoryModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"categoryId":@"id"};
    }];
}

@end

@implementation SupermarketModel

@end
