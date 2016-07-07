//
//  HeaderView.m
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/16.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = rgba(240, 240, 240, 0.8);
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
        self.name.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.name];
        
    }
    return self;
}

@end
