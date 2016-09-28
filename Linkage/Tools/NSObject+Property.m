//
//  NSObject+Property.m
//  RuntimeDemo
//
//  Created by LeeJay on 16/8/9.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    id obj = [[self alloc] init];

    // 获取所有的成员变量
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);

    for (unsigned int i = 0; i < count; i++)
    {
        Ivar ivar = ivars[i];

        // 取出的成员变量，去掉下划线
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [ivarName substringFromIndex:1];

        id value = dictionary[key];

        // 当这个值为空时，判断一下是否执行了replacedKeyFromPropertyName协议，如果执行了替换原来的key查值
        if (!value)
        {
            if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)])
            {
                NSString *replaceKey = [self replacedKeyFromPropertyName][key];
                value = dictionary[replaceKey];
            }
        }

        // 字典嵌套字典
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex:range.location];
            Class modelClass = NSClassFromString(type);

            if (modelClass)
            {
                value = [modelClass objectWithDictionary:value];
            }
        }

        // 字典嵌套数组
        if ([value isKindOfClass:[NSArray class]])
        {
            if ([self respondsToSelector:@selector(objectClassInArray)])
            {
                NSMutableArray *models = [NSMutableArray array];

                NSString *type = [self objectClassInArray][key];
                Class classModel = NSClassFromString(type);
                for (NSDictionary *dict in value)
                {
                    id model = [classModel objectWithDictionary:dict];
                    [models addObject:model];
                }
                value = models;
            }
        }

        if (value)
        {
            [obj setValue:value forKey:key];
        }
    }
    
    // 释放ivars
    free(ivars);

    return obj;
}

@end
