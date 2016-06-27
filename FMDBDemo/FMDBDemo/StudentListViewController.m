//
//  StudentListViewController.m
//  FMDBDemo
//
//  Created by Apple on 16/6/26.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import "StudentListViewController.h"
#import "Student.h"
#import "StudentDetailViewController.h"
#import "GJFMDBQueueHelper.h"

@interface StudentListViewController ()
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;


@property (nonatomic,strong) NSArray *students;
@end

@implementation StudentListViewController

#pragma mark - getter and setter


-(UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView=[[UITableView alloc]init];
        
        tableView.dataSource=self;
        tableView.delegate=self;
        tableView.rowHeight=160;
        [self.view addSubview:tableView];
        _tableView=tableView;
    }
    return _tableView;

}

#pragma mark - vc life cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self pressEnqueryButton];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"FMDB full sql";
    
    UIButton *enqueryButton=[[UIButton alloc]init];
    
    [enqueryButton setTitle:@"enquery" forState:UIControlStateNormal];
    enqueryButton.backgroundColor=[UIColor blueColor];
    [enqueryButton addTarget:self action:@selector(pressEnqueryButton) forControlEvents:UIControlEventTouchUpInside];
    [enqueryButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:enqueryButton];
    
    [enqueryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
        make.top.equalTo(self.view.mas_top).offset(80);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(enqueryButton.mas_bottom);
    }];
    
    
    UIBarButtonItem *testMTOButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"test MTO" style:UIBarButtonItemStylePlain target:self action:@selector(pressMTOButton)];
    self.navigationItem.rightBarButtonItem=testMTOButtonItem;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - target action
-(void)pressEnqueryButton{
    NSLog(@"enquery button");
    GJFMDBQueueHelper *fmdbHelper=[GJFMDBQueueHelper sharedHelper];
    
    self.students=[fmdbHelper allStudents];
    
    [self.tableView reloadData];


}


-(void)pressMTOButton{
    NSLog(@"test mutiple thread operation");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //read
        
        GJFMDBQueueHelper *fmdbHelper=[GJFMDBQueueHelper sharedHelper];
        for (int i=0; i<100; i++) {
            Student *student=    [fmdbHelper studentWithStudentID:[NSString stringWithFormat:@"%d",i]];
            NSLog(@"111 first dispatch  studnet==%@",student);
            
            
        }
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //write
        
        GJFMDBQueueHelper *fmdbHelper=[GJFMDBQueueHelper sharedHelper];
        
        for (int i=0; i<100; i++) {
            Student *student=[[Student alloc]init];
            student.studentName=@"StudentDemo";
            student.studentAge=@11;
            NSLog(@"222 second dispatch operation ==%@",student);
            
            [fmdbHelper addNewStudentToDB:student];
        }
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //delete
        
        GJFMDBQueueHelper *fmdbHelper=[GJFMDBQueueHelper sharedHelper];
        for(int i=0;i<100;i++){
        
            NSArray *students=[fmdbHelper studentsWithStudentName:@"StudentDemo"];
            Student *student=students.firstObject;
            if (student) {
                [fmdbHelper deleteStudentByStudentID:student.studentID];
                NSLog(@"333 third dispatch operation %@",student);
            }
        
        }
    });
    
}
#pragma mark - table view datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdenfier=@"StudentListTableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfier];
    }
    cell.textLabel.numberOfLines=0;
    
    Student *student=self.students[indexPath.row];
    
    cell.textLabel.text=[NSString stringWithFormat:@"NO==%d %@",indexPath.row, student.description];
    
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.students.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Student *student=self.students[indexPath.row];
    StudentDetailViewController *detailVC=[[StudentDetailViewController alloc]init];
    detailVC.student=student;
    
    [self.navigationController pushViewController:detailVC animated:YES];

}

@end
