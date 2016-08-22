//
//  CategoryModel.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//

#import "CollectionCategoryModel.h"

@implementation CollectionCategoryModel

+ (NSDictionary *)objectClassInArray
{
    return @{ @"subcategories": @"SubCategoryModel"};
}

@end

@implementation SubCategoryModel

@end