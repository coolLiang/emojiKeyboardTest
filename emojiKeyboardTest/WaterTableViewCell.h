//
//  WaterTableViewCell.h
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/31.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>

@interface WaterTableViewCell : UITableViewCell

+ (instancetype)WaterTableViewCellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)UITextView * contentTextView;

@property(nonatomic,copy)NSMutableAttributedString * string;

@property(nonatomic,assign)CGSize size;

@property(nonatomic,strong)YYLabel * label; 

@end
