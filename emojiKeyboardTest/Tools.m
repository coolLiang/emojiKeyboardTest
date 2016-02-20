//
//  Tools.m
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/31.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import "Tools.h"
#import "FaceTextAttachment.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define TEXT_FONT 16

@implementation Tools

+(NSMutableAttributedString *)getTheTextViewWithString:(NSString *)string;
{
    //加载plist文件中的数据
    NSBundle *bundle = [NSBundle mainBundle];
    //寻找资源的路径
    NSString *path = [bundle pathForResource:@"Emoji" ofType:@"plist"];
    //获取plist中的数据
    NSArray * faceArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:TEXT_FONT]};
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:dict];
    
    //正则匹配要替换的文字的范围
    //正则表达式
    NSString * pattern = @"lyj+.{4}";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [string substringWithRange:range];
        
        for (int i = 0; i < faceArray.count; i ++)
        {
            if ([faceArray[i][@"String"] isEqualToString:subStr])
            {
                
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                FaceTextAttachment * textAttachment = [[FaceTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:faceArray[i][@"Image"]];
                textAttachment.emojiSize = 50;
                
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    //从后往前替换
    for (int i = (int)(imageArray.count -1); i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    return attributeString;
    
}

+(NSMutableAttributedString *)getTheGifViewWithString:(NSString *)string
{
 
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:TEXT_FONT]};
    UIFont *font = [UIFont systemFontOfSize:TEXT_FONT];

    string = [string stringByReplacingOccurrencesOfString:@"\U0000fffc" withString:@""];
    
    
    //正则匹配要替换的文字的范围
    //正则表达式
    NSString * pattern = @"lyj+.{4}";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:string options:0 range:NSMakeRange(0, string.length)];

    
    //内容中未含有表情元素.就直接展示文字
    if (resultArray.count == 0) {
        
        [text appendAttributedString:[[NSAttributedString alloc]initWithString:string attributes:attribute]];
        
    }
    
    //含有表情元素.进行进一步处理，
    else
    {
        
        //标识的范围。用以判断是否第一次进入。
        NSRange indexRange = {0,0};
        
        
        for (int i = 0; i < resultArray.count; i++) {
            
            NSTextCheckingResult * match = resultArray[i];
            NSRange range = [match range];
            
            //说明在第一个表情前方有文字输入.增加显示
            if (range.location != 0) {
                
                if (indexRange.length == 0 && indexRange.location == 0) {
                    
                    NSRange textRange = {0,range.location};
                    NSString * firstText = [string substringWithRange:textRange];
                    
                    [text appendAttributedString:[[NSAttributedString alloc]initWithString:firstText attributes:attribute]];
                    
                }
                
            }
            //判断起一次的range 跟这一次的range之间是否存在字符。
            if (range.location > indexRange.location + indexRange.length && indexRange.length != 0) {
                
                NSRange centerRange = {indexRange.location + indexRange.length,range.location - indexRange.location - indexRange.length};
                
                NSString * centerText = [string substringWithRange:centerRange];
                
                [text appendAttributedString:[[NSAttributedString alloc]initWithString:centerText attributes:attribute]];
                
            }
            
            //获取原字符串中对应的值
            NSString *subStr = [string substringWithRange:range];
            
            NSString * gifPath = [NSString stringWithFormat:@"%@.gif",subStr];
            YYImage * image = [YYImage imageNamed:gifPath];
            image.preloadAllAnimatedImageFrames = YES;
            YYAnimatedImageView * imageView = [[YYAnimatedImageView alloc]initWithImage:image];
            imageView.autoPlayAnimatedImage = NO;
            [imageView startAnimating];
            
            NSMutableAttributedString * gifText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            
            [text appendAttributedString:gifText];
            
            //表情末尾有文字时.
            if (i == resultArray.count - 1) {
                
                if (string.length > (range.location + range.length)) {
                    
                    CGFloat indexR = range.location + range.length;
                    
                    
                    NSString * lastText = [string substringFromIndex:indexR];
                    
                    [text appendAttributedString:[[NSAttributedString alloc]initWithString:lastText attributes:attribute]];
                    
                }
            }
            
            indexRange = range;
        }

            
    }
    
   
    return text;
}

+(CGFloat)getContentHeight:(NSString *)value
{
    if ([Tools stringIsHaveImage:value]) {
        
        UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 0)];
        
        detailTextView.font = [UIFont systemFontOfSize:TEXT_FONT];
        
        detailTextView.attributedText = [Tools getTheTextViewWithString:value];
        
        
        return detailTextView.contentSize.height - 11;
    }
    else
    {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:TEXT_FONT]};
        
        
        CGSize retSize = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)
                                                 options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
        
        return ceil(retSize.height) + 6;
        
    }
  
    return 0;
 
}

+(BOOL)stringIsHaveImage:(NSString *)string
{
    
    NSString * pattern = @"lyj+.{4}";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    
    //内容中未含有表情元素.就直接展示文字
    if (resultArray.count == 0) {
        
        return NO;
        
    }
    else
    {
        return YES;
    }
    
}
@end
