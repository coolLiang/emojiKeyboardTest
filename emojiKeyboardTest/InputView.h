//
//  InputView.h
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/31.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputViewDelegate <NSObject>

//每次点击键盘时触发方法.
-(void)onClickTheKeyBoard;

//点击表情按钮时
-(void)onClickTheFaceButton;

//点击相片按钮时
-(void)onClickThePhotoButton;

//点击发送按钮时
-(void)onClickTheSendButton;

//点击键盘上的删除按钮
-(void)onClickTheKeyBoardDeleteButton;


@end

@interface InputView : UIView<UITextViewDelegate>

+(instancetype)setupFaceView;

@property(nonatomic,strong)UIButton * sendButton;

@property(nonatomic,strong)UITextView * inputTextView;

@property(nonatomic,strong)UIButton * faceButton;

@property(nonatomic,strong)UIButton * photoButton;

@property(nonatomic,copy)NSString * lastTextViewStr;//上一次的的字符串.

@property(nonatomic,strong)UITextView * currentTextView; //当前展示出来的字符串。帮助记录数据

@property(nonatomic,weak)id delegate;


@end
