//
//  InputView.h
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/31.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputViewDelegate <NSObject>

-(void)onClickTheFaceButton;

-(void)onClickThePhotoButton;

-(void)onClickTheSendButton;

-(void)onInputWithString:(NSString *)string;

-(void)onClickTheKeyBoardDeleteButton;

@end

@interface InputView : UIView<UITextViewDelegate>

+(instancetype)setupFaceView;

@property(nonatomic,strong)UIButton * sendButton;

@property(nonatomic,strong)UITextView * inputTextView;

@property(nonatomic,strong)UIButton * faceButton;

@property(nonatomic,strong)UIButton * photoButton;

@property(nonatomic,weak)id delegate;


@end
