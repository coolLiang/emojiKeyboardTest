//
//  FaceView.h
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/30.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>

-(void)onClickFaceViewWithString:(NSString *)string;

-(void)onClickFaceViewWithDelete;


@end


@interface FaceView : UIView

+(instancetype)setupFaceView;


@property(nonatomic,weak)id delegate;

@end
