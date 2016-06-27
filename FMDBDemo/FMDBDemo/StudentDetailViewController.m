//
//  StudentDetailViewController.m
//  FMDBDemo
//
//  Created by Apple on 16/6/26.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "Student.h"
#import "GJFMDBQueueHelper.h"

@interface StudentDetailViewController ()

@property (nonatomic,weak) UITextField *userNameTextField;
@property (nonatomic,weak) UITextField *userAgeTextField;
@property (nonatomic,weak) UITextField *userIDTextField;
@property (nonatomic,strong) UIBarButtonItem *editBarButtonItem;

@property (nonatomic,strong) UIBarButtonItem *saveBarButtonItem;

@end

@implementation StudentDetailViewController

#pragma mark - getter and setter

-(UIBarButtonItem *)editBarButtonItem{
    
    if (!_editBarButtonItem) {
        
        UIBarButtonItem *editBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"EDIT" style:UIBarButtonItemStylePlain target:self action:@selector(pressEditButton)];
        
        _editBarButtonItem=editBarButtonItem;
        
    }
    
    return _editBarButtonItem;
    
}

-(UIBarButtonItem *)saveBarButtonItem{
    if (!_saveBarButtonItem) {
        UIBarButtonItem *saveBarButtonitem=[[UIBarButtonItem alloc]initWithTitle:@"SAVE" style:UIBarButtonItemStylePlain target:self action:@selector(pressSaveButton)];
        _saveBarButtonItem=saveBarButtonitem;
    }
    return _saveBarButtonItem;
    
}

-(UITextField *)userNameTextField{
    if (!_userNameTextField) {
        UITextField *userNameTextField=  [self textFieldWithInfor:@"student name"];
        [self.view addSubview:userNameTextField];
        _userNameTextField=userNameTextField;
    }
    return _userNameTextField;
    
}

-(UITextField *)userIDTextField{
    if (!_userIDTextField) {
        UITextField *userIDTextField=[self textFieldWithInfor:@"student id"];
        [self.view addSubview:userIDTextField];
        _userIDTextField=userIDTextField;
    }
    return _userIDTextField;
    
}
-(UITextField *)userAgeTextField{
    if (!_userAgeTextField) {
        UITextField *userAgeTextField=[self textFieldWithInfor:@"student age"];
        [self.view addSubview:userAgeTextField];
        _userAgeTextField=userAgeTextField;
    }
    return _userAgeTextField;
    
}

-(UITextField *)textFieldWithInfor:(NSString *)leftTitle{
    UITextField *textField=[[UITextField alloc]init];
    
    textField.layer.borderColor=[[UIColor grayColor]CGColor];
    textField.layer.cornerRadius=5.0;
    
    UILabel *label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:13.0];
    label.frame=CGRectMake(0, 0, 160, 40);
    label.text=leftTitle;
    textField.leftView=label;
    
    textField.leftViewMode=UITextFieldViewModeAlways;
    
    return textField;
    
}

#pragma makrk - vc life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.userIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@40);
    }];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.userIDTextField);
        make.top.equalTo(self.userIDTextField.mas_bottom).offset(30);
    }];
    
    [self.userAgeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.userNameTextField);
        make.top.equalTo(self.userNameTextField.mas_bottom).offset(30);
    }];
    
    self.userIDTextField.text=self.student.studentID;
    self.userNameTextField.text=self.student.studentName;
    self.userAgeTextField.text=[NSString stringWithFormat:@"%ld",(long)[self.student.studentAge integerValue]];
    
    self.userIDTextField.userInteractionEnabled=NO;
    self.userAgeTextField.userInteractionEnabled=NO;
    self.userNameTextField.userInteractionEnabled=NO;
    
    self.navigationItem.rightBarButtonItem=self.editBarButtonItem;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - target action

-(void)pressEditButton{
    
    self.userNameTextField.userInteractionEnabled=YES;
    self.userAgeTextField.userInteractionEnabled=YES;
    
    self.navigationItem.rightBarButtonItem=self.saveBarButtonItem;


}

-(void)pressSaveButton{
    
    GJFMDBQueueHelper *fmdbHelper=[GJFMDBQueueHelper sharedHelper];
    
    Student *student=[[Student alloc]init];
    student.studentName=self.userNameTextField.text;
    student.studentAge=@([self.userAgeTextField.text integerValue]);
    student.studentID=self.userIDTextField.text;
    
    BOOL saveResult=[fmdbHelper updateStudent:student];
    if (saveResult) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"save failed") ;
    }


}

@end
