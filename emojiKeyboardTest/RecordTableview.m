//
//  RecordTableview.m
//  emojiKeyboardTest
//
//  Created by FLY_AY on 16/1/4.
//  Copyright © 2016年 com.TYToO. All rights reserved.
//

#import "RecordTableview.h"

@implementation RecordTableview

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"onClickTheTableViewToHideKeyBoard" object:nil];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
