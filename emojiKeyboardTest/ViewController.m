//
//  ViewController.m
//  emojiKeyboardTest
//
//  Created by FLY_AY on 15/12/30.
//  Copyright © 2015年 com.TYToO. All rights reserved.
//

#import "ViewController.h"
#import "FaceView.h"
#import "InputView.h"
#import "FaceTextAttachment.h"
#import "Masonry.h"
#import "WaterTableViewCell.h"
#import "Tools.h"
#import "RecordTableview.h"
#import "IQKeyboardManager.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<FaceViewDelegate,InputViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)InputView * inputView;

@property(nonatomic,strong)FaceView * faceView;

@property(nonatomic,assign)CGSize  inputViewSize;

@property(nonatomic,strong)UITextView * myTextView;

@property(nonatomic,copy)NSString * inputSrting;

@property(nonatomic,strong)NSArray * faceDataArray;

@property(nonatomic,strong)UITextView * testTextView;

@property(nonatomic,strong)RecordTableview * recordTableView;

@property(nonatomic,strong)NSMutableArray * cellDataArray; //

@property(nonatomic,strong)UIView * animationView;//input and face.

@property(nonatomic,assign)BOOL isKeyBoardShow;  //标识. 键盘是否展示出来

@property(nonatomic,assign)BOOL isFaceViewShow;  //标识. 表情键盘是否展示出来

@property(nonatomic,copy)NSString * currentString;  //当前textview展示出来的字符串

@property(nonatomic,strong)NSMutableArray * faceArray; //选择的表情.


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputSrting = @"";
    
    self.cellDataArray = [[NSMutableArray alloc]init];
    self.faceArray = [[NSMutableArray alloc]init];
    
 
    self.faceView = [FaceView setupFaceView];
    self.faceView.delegate = self;
    self.faceView.backgroundColor = [UIColor clearColor];

    self.inputView = [InputView setupFaceView];
    self.inputView.backgroundColor = [UIColor lightTextColor];
    self.inputView.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    self.recordTableView = [[RecordTableview alloc]init];
    
    UIView * view = [[UIView alloc]init];
    
    self.recordTableView.backgroundColor = [UIColor lightGrayColor];
    
    self.recordTableView.tableFooterView = view;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self; 

    [self.view addSubview:self.recordTableView];
    
    self.animationView = [[UIView alloc]init];
    self.animationView.backgroundColor = [UIColor lightGrayColor];
    [self.animationView addSubview:self.faceView];
    [self.animationView addSubview:self.inputView];
    
    
    [self.view addSubview:self.animationView];
    
    
    [self buildCS];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyBoard) name:@"onClickTheTableViewToHideKeyBoard" object:nil];

    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
}

//点击列表视图.回收键盘以及表情视图
-(void)hideKeyBoard
{
    [self.view endEditing:YES];
    self.isKeyBoardShow = NO;
    [self restoreFaceView];
}

//键盘展示时。
-(void)keyboardWillShow
{
    
    self.isKeyBoardShow = YES;
    
    [UIView animateWithDuration:0 animations:^{
        
        
        [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view.mas_bottom).offset(-self.inputView.frame.size.height);
            
        }];

        [self.animationView layoutIfNeeded];
        self.isFaceViewShow = NO;
      
        
    }];
}

//键盘隐藏时.
-(void)keyboardWillHidden
{
    self.isKeyBoardShow = NO;
}

//回收表情视图.
-(void)restoreFaceView
{

    [UIView animateWithDuration:.5 animations:^{

        [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.view.mas_bottom).offset(-self.inputView.frame.size.height);
            
        }];
        
        [self.animationView layoutIfNeeded];
        self.isFaceViewShow = NO;

    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(0);
                
            }];
        }

    }];

}


//根据输入框中的内容 返回所相适应的高度
- (CGSize)contentSizeOfTextView:(UITextView *)textView
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, textView.frame.size.width - 1, 0)];
    
    detailTextView.font = [UIFont systemFontOfSize:19];

    detailTextView.attributedText = [Tools getTheTextViewWithString:[Tools changeString:self.inputView.inputTextView.text withFaceArray:self.faceArray]];
    
    return detailTextView.contentSize;

}



-(void)buildCS
{
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(50 + SCREEN_WIDTH * 0.75);
        make.top.equalTo(self.view.mas_bottom).offset(-50);
        
    }];
    
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
  
    }];
    
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.mas_equalTo(0);
        make.bottom.equalTo(self.animationView.mas_bottom).offset(0);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.75);
        
    }];

    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        
    }];
    
}

-(void)onClickFaceViewWithString:(NSString *)string
{
    
    NSRange currentRange =  self.inputView.inputTextView.selectedRange;
    
    
    
    NSString * currentText = self.inputView.inputTextView.text;

    [self.faceArray addObject:string];
    
    currentText = [currentText stringByReplacingCharactersInRange:currentRange withString:string];

    
    currentText = [Tools changeString:currentText withFaceArray:self.faceArray];
    
    self.inputView.inputTextView.attributedText = [Tools getTheTextViewWithString:currentText];

    [self updateInputViewFrame];
}



-(void)onClickTheFaceButton
{
    [self.view endEditing:YES];
    
    if (self.isFaceViewShow) {
        
        [self restoreFaceView];
        
    }
    else
    {
        [UIView animateWithDuration:.5 animations:^{
            
            
            [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_bottom).offset(-self.animationView.frame.size.height);
                
            }];
            
            [self.animationView layoutIfNeeded];
            self.isFaceViewShow = YES;
            
            
        }];
    }

}


-(void)onClickTheKeyBoardDeleteButton
{
    
    NSString * str = self.inputView.inputTextView.text;
    
    if (str.length == 0) {
        
        [self sendedUpdateUI];
        return;
    }
    
    NSString * test = [str substringFromIndex:str.length-1];
    
    
    
    if ([test isEqualToString:@"\U0000fffc"]) {
        
        [self.faceArray removeLastObject];
    }

    
//    [self updateInputViewFrame];

}

-(void)onClickThePhotoButton
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [sheet showInView:self.view];
    
}

-(void)onClickTheKeyBoard
{
    [self updateInputViewFrame];
}

//用以更新输入框的高度.
-(void)updateInputViewFrame
{

    self.inputViewSize = [self contentSizeOfTextView:self.inputView.inputTextView];
    
    CGFloat heightR = self.inputViewSize.height - self.inputView.inputTextView.frame.size.height;
    
    NSLog(@"高度差 = %f",heightR);
    
    if (heightR == 0) {
        
        return;
    }
    
    //输入框的坐标更新.
    if (self.inputViewSize.height > 40) {
        
        if (self.inputViewSize.height > 150) {
            
            CGFloat offset = self.inputView.inputTextView.contentSize.height - self.inputView.inputTextView.bounds.size.height;
            if (offset > 0)
            {
                [self.inputView.inputTextView setContentOffset:CGPointMake(0, offset) animated:YES];

            }

            return;
        }
        
        self.inputView.inputTextView.frame = CGRectMake(self.inputView.inputTextView.frame.origin.x, self.inputView.inputTextView.frame.origin.y, self.inputView.inputTextView.frame.size.width, self.inputViewSize.height);

        
    }
    
    
    [UIView animateWithDuration:.1 animations:^{
        
        
        //输入框所在父视图的高度更新.
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            if (self.inputViewSize.height < 40) {
                
                make.height.mas_equalTo(50);
            }
            else
            {
                make.height.mas_equalTo(self.inputViewSize.height + 10);
            }

        }];
        
        self.inputView.inputTextView.font = [UIFont systemFontOfSize:19];
        
        if (heightR > 0) {
            
            //整体视图坐标更新.
            if (self.isKeyBoardShow) {
                
                [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.height.mas_equalTo(self.animationView.frame.size.height + heightR);
                    make.top.equalTo(self.view.mas_bottom).offset(-(self.inputView.frame.size.height + heightR));
                    
                }];
            }
            else
            {
                if (self.isFaceViewShow) {
                    
                    [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.height.mas_equalTo(self.animationView.frame.size.height + heightR);
                        make.top.equalTo(self.view.mas_bottom).offset(-(self.animationView.frame.size.height + heightR));
                        
                    }];
                }
                else
                {
                    
                    
                    [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.height.mas_equalTo(self.animationView.frame.size.height + heightR);
                        make.top.equalTo(self.view.mas_bottom).offset(-(self.inputView.frame.size.height + heightR));
                        
                    }];
                }
                
            }
            
            [self.inputView layoutIfNeeded];
        }
        else
        {
            
            [UIView animateWithDuration:.5 animations:^{
               
                if ((self.animationView.frame.size.height + heightR )> 50 + SCREEN_WIDTH * 0.75) {
                    
                    [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.height.mas_equalTo(self.animationView.frame.size.height + heightR);
                        make.top.equalTo(self.view.mas_bottom).offset(-(self.inputView.frame.size.height + heightR));
                        
                    }];
                }
                else
                {
                    [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.height.mas_equalTo(50 + SCREEN_WIDTH * 0.75);
                        make.top.equalTo(self.view.mas_bottom).offset(-50);
                        
                    }];
                }
                [self.inputView layoutIfNeeded];
                
            }];
 
        }

    }];
}

-(void)onClickTheSendButton
{
    
    //判断发送的数据是否长度为空
    if ([Tools changeString:self.inputView.inputTextView.text withFaceArray:self.faceArray].length == 0) {
        
        return;
    }
    
    //判断发送的数据是否带有emoji表情
    if ([Tools stringContainsEmoji:[Tools changeString:self.inputView.inputTextView.text withFaceArray:self.faceArray]]) {
        
        return;
    }

    
    [self.cellDataArray addObject:[Tools changeString:self.inputView.inputTextView.text withFaceArray:self.faceArray]];
    
    [self sendedUpdateUI];
    
    
    [self.recordTableView reloadData];
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:self.cellDataArray.count - 1 inSection:0];
    [self.recordTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    
}

//发送后将UI更新为初始状态.并且重置相关数据。
-(void)sendedUpdateUI
{
    [UIView animateWithDuration:.5 animations:^{
        
        [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view.mas_bottom).offset(-50);
            make.height.mas_equalTo(50 + SCREEN_WIDTH * 0.75);
            
        }];
        
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(50);
        }];

        [self.animationView layoutIfNeeded];

    }];
    
    [self.faceArray removeAllObjects];
    self.inputView.inputTextView.text = @"";
    self.inputView.inputTextView.font = [UIFont systemFontOfSize:19];
    [self.view endEditing:YES];
}



#pragma mark - tableview delegate;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaterTableViewCell * cell = [WaterTableViewCell WaterTableViewCellWithTableView:tableView];
    
    cell.string = [Tools getTheGifViewWithString:self.cellDataArray[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [Tools getContentHeight:self.cellDataArray[indexPath.row]];
}



#pragma mark - actionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
