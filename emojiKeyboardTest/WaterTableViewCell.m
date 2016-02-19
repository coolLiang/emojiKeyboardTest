//
//  WaterTableViewCell.m
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/31.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import "WaterTableViewCell.h"
#import "Masonry.h"
#import "Tools.h"


@implementation WaterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)WaterTableViewCellWithTableView:(UITableView *)tableView

{
    
    static NSString * water = @"water";
    
    WaterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:water];
    
    if (!cell) {
        
        cell = [[WaterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:water];
        cell.backgroundColor = [UIColor yellowColor];
        
    }
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self buildUI];
        
        [self buildCS];

        
    }
    
    return self;
}

-(void)buildUI
{
    self.label = [YYLabel new];
    self.label.numberOfLines = 0;
    [self.contentView addSubview:self.label];
    
}

-(void)buildCS
{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);

        
    }];

}

-(void)setString:(NSMutableAttributedString *)string
{
    self.label.attributedText = string;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
