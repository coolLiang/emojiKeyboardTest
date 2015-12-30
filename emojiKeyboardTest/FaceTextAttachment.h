//
//  FaceTextAttachment.h
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/30.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceTextAttachment : NSTextAttachment

//表情的字符串表示，见前文
@property(strong, nonatomic) NSString *emojiTag;

//新增：保存当前表情图片的大小
@property(assign, nonatomic) CGFloat emojiSize;

@end
