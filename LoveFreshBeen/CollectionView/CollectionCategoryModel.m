//
//  CategoryModel.m
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/17.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import "CollectionCategoryModel.h"

@implementation CollectionCategoryModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"subcategories":[SubCategoryModel class]};
}

@end

@implementation SubCategoryModel

@end