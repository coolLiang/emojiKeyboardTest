//
//  ViewController.m
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/30.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import "ViewController.h"
#import "FaceView.h"
#import "FaceTextAttachment.h"
@interface ViewController ()<FaceViewDelegate>
@property(nonatomic,strong)UITextView * myTextView;

@property(nonatomic,copy)NSString * inputSrting;

@property(nonatomic,strong)NSMutableArray * SelectedFaceArray;



@property(nonatomic,strong)NSArray * faceDataArray;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputSrting = @"";
    
    
    [self buildData];
    
    FaceView * face = [FaceView setupFaceView];
    face.frame = CGRectMake(0, 20, self.view.frame.size.width, 220);
    face.backgroundColor = [UIColor redColor];
    
    face.delegate = self;
    [self.view addSubview:face];

    
    self.myTextView = [[UITextView alloc]init];
    self.myTextView.backgroundColor = [UIColor lightGrayColor];
    self.myTextView.frame = CGRectMake(0, 240, self.view.frame.size.width, 100);
    [self.view addSubview:self.myTextView];

    
}

- (CGSize)contentSizeOfTextView:(UITextView *)textView
{
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    
    
    return textViewSize;
}

-(void)updateTextView:(NSString *)string
{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    //正则匹配要替换的文字的范围
    //正则表达式
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
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
        
        for (int i = 0; i < self.faceDataArray.count; i ++)
        {
            if ([self.faceDataArray[i][@"String"] isEqualToString:subStr])
            {
                
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                FaceTextAttachment * textAttachment = [[FaceTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:self.faceDataArray[i][@"Image"]];
                textAttachment.emojiSize = 80;
                
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
    
    
    self.myTextView.attributedText = attributeString;
    
    CGSize size =[self contentSizeOfTextView:self.myTextView];
    
    self.myTextView.frame = CGRectMake(self.myTextView.frame.origin.x, self.myTextView.frame.origin.y, self.view.frame.size.width, size.height);

}

-(void)buildData
{
    //加载plist文件中的数据
    NSBundle *bundle = [NSBundle mainBundle];
    //寻找资源的路径
    NSString *path = [bundle pathForResource:@"Emoji" ofType:@"plist"];
    //获取plist中的数据
    self.faceDataArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    
    self.SelectedFaceArray = [[NSMutableArray alloc]init];
    
}

-(NSString *)updateInputString;
{
    NSString * string = @"";
    
    for (int i = 0; i<self.SelectedFaceArray.count; i++) {
        
        string = [string stringByAppendingString:self.SelectedFaceArray[i]];
    }
    
    return string;
    
}

-(void)onClickFaceViewWithString:(NSString *)string
{
    
    [self.SelectedFaceArray addObject:string];
    
    
    
    self.inputSrting = [self updateInputString];
    
    [self updateTextView:self.inputSrting];
    
    
}

-(void)onClickFaceViewWithDelete
{
    [self.SelectedFaceArray removeLastObject];
    self.inputSrting  = [self updateInputString];
    [self updateTextView:self.inputSrting];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
