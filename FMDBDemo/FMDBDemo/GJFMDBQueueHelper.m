//
//  GJFMDBQueueHelper.m
//  FMDBDemo
//
//  Created by Apple on 16/6/25.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import "GJFMDBQueueHelper.h"
#import "FMDB.h"
#import "Student.h"

static GJFMDBQueueHelper *sharedHelper = nil;

/**
 *  sqlite 的文件名
 */
#define databaseName @"student"
@interface GJFMDBQueueHelper()


@property (nonatomic , copy) NSString *dbFile;
@property (nonatomic, retain)FMDatabaseQueue *dbQueue;


@end

@implementation GJFMDBQueueHelper



-(BOOL)createDatabaseTable
{
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",databaseName]];
    
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_students (student_id integer PRIMARY KEY AUTOINCREMENT,student_age integer NOT NULL,student_name text NOT NULL );";
        BOOL result= [db executeUpdate:sql];
        NSLog(@"%@",result?@"create table t_students success":@"create table t_students faiiled");
        
        
    }];
    return YES;
}

- (id)init
{
    
    static id obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if ((obj =[super init])!=nil) {
            //创建表
            [self createDatabaseTable];
           
        }
        
    });
    self=obj;
    
    return  self;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [super allocWithZone:zone];
    });
    
    // 返回对象
    return sharedHelper;
}

+ (instancetype)sharedHelper
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    
    // 返回对象
    return sharedHelper;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return sharedHelper;
}


#pragma mark - private method
/*update*/
-(BOOL)updateWithSQL:(NSString *)sqlString{
    
    NSLog(@"update sql==%@",sqlString);
    
    __block BOOL  updateResult=NO;
    
    
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        [db open];
        updateResult=[db executeUpdate:sqlString];
        [db close];
        
    }];
    
    return updateResult;
    
}

/*query */
-(NSArray *)modelsWithSQL:(NSString *)sqlString{
    __block NSMutableArray *eventModels=[NSMutableArray array];
    
    NSLog(@"query sql==%@",sqlString);
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        [db open];
        
        FMResultSet *rs = [db executeQuery:sqlString];
        while ([rs next])
        {
            //
            [eventModels addObject:[self modelFromRS :rs]];
        }
        [db close];
    }];
    return eventModels;
    
}

/*add */
-(BOOL)addNewStudentToDB:(Student *)student{
    
    __block BOOL insertResult=NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db open];
        NSString *sqlString=[NSString stringWithFormat:@"INSERT INTO t_student (student_name,student_age) VALUES ('%@',%ld)",
                             student.studentName,
                             [student.studentAge integerValue]];
        insertResult=[db executeUpdate:sqlString];
        [db close];
        
    }];
    
    return insertResult;
    
    
}

/* delete */
-(BOOL)deleteStudentByStudentID:(NSString *)studentID{
    __block BOOL result=NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db open];
        NSString *sqlString=[NSString stringWithFormat:@"DELETE FROM t_student WHERE student_id = %ld",[studentID integerValue]];
        result=[db executeUpdate:sqlString];
        [db close];
    }];
    
    return result;


}

/**
 *  get model from FMResultSet
 *
 *  @param rs rs FMResultSet
 *
 *  @return FMResultSet
 */
-(id)modelFromRS:(FMResultSet *)rs{
    
    Student *student=[[Student alloc]init];
    student.studentAge=@([rs intForColumn:@"student_age"]);
    student.studentID=[NSString stringWithFormat:@"%d",[rs intForColumn:@"student_id"]];
    student.studentName=[rs stringForColumn:@"student_name"];
    
    
    return student;
}

-(Student *)studentWithStudentID:(NSString *)studentID{

    NSString *sqlString=[NSString stringWithFormat:@"SELECT * FROM t_students WHERE student_id = %@",studentID];
    NSArray *students=[self modelsWithSQL:sqlString];
    return students.firstObject;

}

-(NSArray *)studentsWithStudentName:(NSString *)studentName{

    NSString *sqlString=[NSString stringWithFormat:@"SELECT * FROM t_students WHERE student_name = '%@'",studentName];
    NSArray *students=[self modelsWithSQL:sqlString];
    return students;


}


-(NSArray *)allStudents{
    NSString *sqlString=[NSString stringWithFormat:@"SELECT * FROM t_students"];
    NSArray *allStudents=[self modelsWithSQL:sqlString];
    
    return allStudents;

}

-(BOOL)updateStudent:(Student *)student{
    
    
    NSString *sqlString=[NSString stringWithFormat:@"UPDATE t_students SET student_name = '%@' , student_age = %ld    WHERE student_id = %ld ",student.studentName,(long)[student.studentAge integerValue],(long)[student.studentID integerValue]];
    
    BOOL updateResult=[self updateWithSQL:sqlString];
    return updateResult;
    
}
@end
