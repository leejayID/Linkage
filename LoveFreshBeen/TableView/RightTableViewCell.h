//
//  RightTableViewCell.h
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/16.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SupermarketModel;

#define kCellIdentifier_Right @"RightTableViewCell"

@interface RightTableViewCell : UITableViewCell

@property (nonatomic, strong) SupermarketModel *model;

@end
