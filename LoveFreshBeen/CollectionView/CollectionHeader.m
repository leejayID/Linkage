//
//  CollectionHeader.m
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/17.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import "CollectionHeader.h"

@implementation CollectionHeader

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = rgba(240, 240, 240, 0.8);

        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH-80, 20)];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        
    }
    return self;
}

@end
