//
//  InputView.m
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/31.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import "InputView.h"
#import "Masonry.h"
@implementation InputView

+(instancetype)setupFaceView
{
    return [[self alloc]init];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildUI];
        
        
    }
    return self;
}

-(void)buildUI
{
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.backgroundColor = [UIColor redColor];
    [self.sendButton addTarget:self action:@selector(sendInfo) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:self.sendButton];
    
    self.inputTextView = [[UITextView alloc]init];
    self.inputTextView.font = [UIFont systemFontOfSize:20];
    self.inputTextView.text = @"";
    self.inputTextView.delegate  = self;
    
    [self addSubview:self.inputTextView];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoButton.backgroundColor = [UIColor redColor];
    [self.photoButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.photoButton];
    
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceButton.backgroundColor = [UIColor yellowColor];
    [self.faceButton addTarget:self action:@selector(chooseFace) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.faceButton];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-5);
        
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(5);
        
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(33);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.faceButton.mas_right).offset(10);
        
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(33);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.photoButton.mas_right).offset(5);
        make.right.equalTo(self.sendButton.mas_left).offset(-5);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
        

    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickTheKeyBoardDeleteButton)]) {
            
            [self.delegate onClickTheKeyBoardDeleteButton];
        }
        
        return YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onInputWithString:)]) {
        
        [self.delegate onInputWithString:text];
    }
    
    return YES;
}


-(void)choosePhoto
{
    NSLog(@"123");
}

-(void)chooseFace
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickTheFaceButton)]) {
        
        [self.delegate onClickTheFaceButton];
        
    }
    
}

-(void)sendInfo
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickTheSendButton)]) {
        
        [self.delegate onClickTheSendButton];
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
