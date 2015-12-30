//
//  FaceTextAttachment.m
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/30.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import "FaceTextAttachment.h"

@implementation FaceTextAttachment

//重点！重写NSTextAttachmentContainer Protocol的方法
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
    //根据emojiSize计算新的大小
    return [self scaleImageSizeToWidth:_emojiSize];
}

//计算新的图片大小
//这里不涉及对图片实际数据的压缩，所以不用异步处理~

- (CGRect)scaleImageSizeToWidth:(CGFloat)width {
    //缩放系数
    CGFloat factor = 1.0;
    
    //获取原本图片大小
    CGSize oriSize = [self.image size];
    
    //计算缩放系数
    factor = (CGFloat) (width / oriSize.width);
    
    //创建新的Size
    CGRect newSize = CGRectMake(0, 0, oriSize.width * factor, oriSize.height * factor);
    
    return newSize;
    
}


@end
