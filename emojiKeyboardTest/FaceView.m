//
//  FaceView.m
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/30.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import "FaceView.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface FaceView()

@property(nonatomic,strong)NSArray * faceImageArray; //表情图片数组

@property(nonatomic,strong)NSArray * faceDateArray;


@end


@implementation FaceView

+(instancetype)setupFaceView
{
    return [[self alloc]init];
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self buildData];
        
        
        [self buildUI];
        
    }
    return self;
}

-(void)buildData
{
    //加载plist文件中的数据
    NSBundle *bundle = [NSBundle mainBundle];
    //寻找资源的路径
    NSString *path = [bundle pathForResource:@"Emoji" ofType:@"plist"];
    //获取plist中的数据
    self.faceDateArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    self.faceImageArray = [self.faceDateArray valueForKey:@"Image"];
    
}

-(void)buildUI
{
    NSLog(@"%f",WIDTH);
    
    NSLog(@"%f",HEIGHT);
    
    CGFloat buttonWidth = (WIDTH - 80)/7;
    CGFloat buttonHeight = (WIDTH - 80)/7;
    
    int row = 0;
    
    for (int i = 0; i<self.faceImageArray.count + 1 ; i++) {
        
        
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if (i == self.faceDateArray.count) {
            
            button.tag = 1000+110;
            [button setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        }
        else
        {
            button.tag = 1000 + i;
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.faceImageArray[i]]] forState:UIControlStateNormal];
        }
        
        
        
        if (i % 7 ==0 && i != 0) {
            row ++;
            
        }
        
        CGFloat Xmargin = (10+buttonWidth)*(i%7) + 10;
        CGFloat Ymargin = (10+buttonHeight)*row + 10;
        button.frame = CGRectMake(Xmargin, Ymargin, buttonWidth, buttonHeight);
        [button addTarget:self action:@selector(buttonOnClickWithIndex:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:button];
        
    }
     
}

-(void)buttonOnClickWithIndex:(UIButton *)sender
{
    
    NSInteger tag = sender.tag;
    NSInteger index = tag - 1000;
    
    if (index == 110) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickFaceViewWithDelete)]) {
            
            [self.delegate onClickFaceViewWithDelete];
            return;
        }
        
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickFaceViewWithString:)]) {
    
        NSString * string = self.faceDateArray[index][@"String"];
        
        
        [self.delegate onClickFaceViewWithString:string];
        
    }
    
    
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
