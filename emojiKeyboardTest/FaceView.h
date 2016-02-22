//
//  FaceView.h
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/30.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>

//点击表情时将表情数据进行传递
-(void)onClickFaceViewWithString:(NSString *)string;

@optional
//本计划用以进行表情删除
-(void)onClickFaceViewWithDelete;

@end

@interface FaceView : UIView

+(instancetype)setupFaceView;

@property(nonatomic,weak)id delegate;

@end
