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
    self.inputTextView.layer.cornerRadius = 5;
    self.inputTextView.layer.borderWidth = 1;
    self.inputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self addSubview:self.inputTextView];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoButton.backgroundColor = [UIColor redColor];
    [self.photoButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.photoButton];
    
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceButton.backgroundColor = [UIColor yellowColor];
    [self.faceButton addTarget:self action:@selector(chooseFace) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.faceButton];
    
    self.currentTextView = [[UITextView alloc]init];
    [self addSubview:self.currentTextView];
    
    
    //监听输入框中字符输入的变化.PS:表情增加时不进入监听方法。
    [self.currentTextView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        
        //当用户在键盘上选择字符时。会有单个字符替换的过程.
        if (self.currentTextView.text.length == self.lastTextViewStr.length) {
            
            //让数据数组移除之前最新的一个字符.增加现在变换后的字符.
            NSRange range = {self.currentTextView.text.length - 1,1};
            
            
            NSString * str = [self.currentTextView.text substringWithRange:range];
            
            [self.delegate onUpdateText:str];
            
        }
        
        //其他情况下。输入的新内容遍历字符传出.
        if (self.currentTextView.text.length > self.lastTextViewStr.length) {
            
            NSString * result = [self.currentTextView.text substringFromIndex:self.lastTextViewStr.length];
            
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onInputWithString:)]) {
                
                for (int i = 0; i < result.length; i++) {
                    
                    NSRange range = {i,1};
                    
                    NSString * str = [result substringWithRange:range];
                    
                    
                    [self.delegate onInputWithString:str];
                }
                
            }
        }
        
        //记录上一次传出的字符串数据.
        self.lastTextViewStr = self.currentTextView.text;

    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    //每次用完整的文字输入后改变text.
    if (textView.markedTextRange == nil) {
        
        if (textView.text.length == 0) {

            return;
        }
        
        
        self.currentTextView.text = textView.text;
 
    }
   
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

    
    return YES;
}


-(void)choosePhoto
{
    [self.delegate onClickThePhotoButton];
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
