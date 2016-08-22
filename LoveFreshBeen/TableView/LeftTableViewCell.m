//
//  LeftTableViewCell.m
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/16.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageV.image = [UIImage imageNamed:@"llll"];
        self.imageV.highlightedImage = [UIImage imageNamed:@"kkkkkkk"];
        [self.contentView addSubview:self.imageV];

        self.name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = rgba(130, 130, 130, 1);
        self.name.highlightedTextColor = rgba(253, 212, 49, 1);
        [self.contentView addSubview:self.name];

        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 5, 35)];
        self.yellowView.backgroundColor = rgba(253, 212, 49, 1);
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state

    self.imageV.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
