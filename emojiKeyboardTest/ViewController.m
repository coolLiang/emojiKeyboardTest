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

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<FaceViewDelegate,InputViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)InputView * inputView;

@property(nonatomic,strong)FaceView * faceView;

@property(nonatomic,assign)CGSize  inputViewSize;

@property(nonatomic,strong)UITextView * myTextView;

@property(nonatomic,copy)NSString * inputSrting;

@property(nonatomic,strong)NSMutableArray * SelectedFaceArray;

@property(nonatomic,strong)NSArray * faceDataArray;

@property(nonatomic,strong)UITextView * testTextView;

@property(nonatomic,strong)RecordTableview * recordTableView;

@property(nonatomic,strong)NSMutableArray * cellDataArray; //



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputSrting = @"";
    
    self.cellDataArray = [[NSMutableArray alloc]init];

    
    [self buildData];
    
    self.faceView = [FaceView setupFaceView];
    self.faceView.backgroundColor = [UIColor redColor];
    self.faceView.delegate = self;
    [self.view addSubview:self.faceView];

   
    self.inputView = [InputView setupFaceView];
    self.inputView.backgroundColor = [UIColor greenColor];
    self.inputView.delegate = self;
    
    [self.view addSubview:self.inputView];
    

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    self.recordTableView = [[RecordTableview alloc]init];
    
    UIView * view = [[UIView alloc]init];
    self.recordTableView.tableFooterView = view;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.estimatedRowHeight  = 66;
    self.recordTableView.rowHeight = UITableViewAutomaticDimension;

    
    
    [self.view addSubview:self.recordTableView];
    
    
    [self buildCS];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyBoard) name:@"onClickTheTableViewToHideKeyBoard" object:nil];
    
}

-(void)hideKeyBoard
{
    [self.view endEditing:YES];
    
    if (self.inputView.inputTextView.text.length <= 0) {
        
        return;
    }
    
    [self restoreFaceView];
}

-(void)keyboardWillShow
{
    [self restoreFaceView];
}

-(void)restoreFaceView
{
    NSLog(@"%@",NSStringFromCGRect(self.inputView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.faceView.frame));
    
//    SCREEN_HEIGHT-self.inputView.frame.size.height
    [UIView animateWithDuration:3 animations:^{
        self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-self.inputView.frame.size.height, self.inputView.frame.size.width, self.inputView.frame.size.height);
        
        self.faceView.frame = CGRectMake(0, SCREEN_HEIGHT, self.faceView.frame.size.width, self.faceView.frame.size.height);
        
        NSLog(@"%@",NSStringFromCGRect(self.inputView.frame));
        NSLog(@"%@",NSStringFromCGRect(self.faceView.frame));
        
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.mas_equalTo(0);
                
            }];
            [self updateInputViewFrame];

        }

    }];

}



- (CGSize)contentSizeOfTextView:(UITextView *)textView
{
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width-1, FLT_MAX)];
    
    
    return textViewSize;
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

-(void)buildCS
{
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
  
    }];
    
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.inputView.mas_bottom).offset(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT/4);
        
    }];
    
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.bottom.equalTo(self.inputView.mas_top).offset(0);
        
    }];
    
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
    
    self.inputView.inputTextView.attributedText = [Tools getTheTextViewWithString:self.inputSrting];
    [self updateInputViewFrame];
    
    
}

-(void)onClickFaceViewWithDelete
{
    [self.SelectedFaceArray removeLastObject];
    self.inputSrting  = [self updateInputString];
    
    self.inputView.inputTextView.attributedText = [Tools getTheTextViewWithString:self.inputSrting];
    [self updateInputViewFrame];
    
}

-(void)onClickTheFaceButton
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:.5 animations:^{
       
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(self.view.mas_bottom).offset(-SCREEN_HEIGHT/4);
            
        }];
        
        [self.inputView layoutIfNeeded];
        [self.faceView layoutIfNeeded];
        
        
    }];
}

-(void)onInputWithString:(NSString *)string
{
    
    [self.SelectedFaceArray addObject:string];
    self.inputView.inputTextView.font = [UIFont systemFontOfSize:22];
    [self updateInputViewFrame];

}

-(void)onClickTheKeyBoardDeleteButton
{
    [self.SelectedFaceArray removeLastObject];
    [self updateInputViewFrame];

}

-(void)onClickThePhotoButton
{
    NSLog(@"231");
    
}

-(void)updateInputViewFrame
{
    
    
    self.inputViewSize = [self contentSizeOfTextView:self.inputView.inputTextView];
    
    self.inputView.inputTextView.frame = CGRectMake(self.inputView.inputTextView.frame.origin.x, self.inputView.inputTextView.frame.origin.y, self.inputView.inputTextView.frame.size.width, self.inputViewSize.height);
    
    
    [UIView animateWithDuration:0 animations:^{
        
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(self.inputViewSize.height + 10);
            
        }];
        
        [self.inputView layoutIfNeeded];
        [self.faceView layoutIfNeeded];
        
        
    }];
}

-(void)onClickTheSendButton
{
    self.inputSrting = [self updateInputString];
    
    
    [self.SelectedFaceArray removeAllObjects];
    self.inputView.inputTextView.text = @"";
    
    [self.cellDataArray addObject:self.inputSrting];
    
    [self restoreFaceView];
    
    [self.view endEditing:YES];
    [self.recordTableView reloadData];
    
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
    
   cell.string = self.cellDataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForString:self.cellDataArray[indexPath.row] fontSize:22 andWidth:SCREEN_WIDTH-100];
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    
    detailTextView.attributedText = [Tools getTheTextViewWithString:value];
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,FLT_MAX)];
    return deSize.height+10;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
