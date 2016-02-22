//
//  Tools.h
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/31.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YYImage/YYImage.h>
#import <YYText/YYText.h>

@interface Tools : NSObject


//点击表情列表中表情的将字符串转换成富文本展示在输入框中
+(NSMutableAttributedString *)getTheTextViewWithString:(NSString *)string;

//从服务器中得到的字符串转换成动态视图+文字的富文本
+(NSMutableAttributedString *)getTheGifViewWithString:(NSString *)string;

//根据上面2个方面中获得到的字符串。返回cell中相关内容所需要的行高。
+(CGFloat)getContentHeight:(NSString *)value;

//判断内容字符串中是否存在表情.
//存在表情时与不存在表情时返回高度时的逻辑运算不一致。
+(BOOL)stringIsHaveImage:(NSString *)string;

//判断是否存在emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

//字符串中存在空格的部分 用表情数组进行替换。
+ (NSString *)changeString:(NSString *)string withFaceArray:(NSMutableArray *)faceArray;

+ (NSRange)getNeedChangeStringRange:(NSString *)string;

@end
