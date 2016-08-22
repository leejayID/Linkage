//
//  RightTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//

#import "RightTableViewCell.h"
#import "CategoryModel.h"

@interface RightTableViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;

@end

@implementation RightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        [self.contentView addSubview:self.imageV];

        self.name = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, SCREEN_WIDTH - 70, 30)];
        self.name.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.name];
    }
    return self;
}

- (void)setModel:(FoodModel *)model
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    self.name.text = model.name;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
