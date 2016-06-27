//
//  GJFMDBQueueHelper.h
//  FMDBDemo
//
//  Created by Apple on 16/6/25.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Student;
@interface GJFMDBQueueHelper : NSObject

/*单例的接口*/
+ (instancetype)sharedHelper;

/*增加学生的接口*/
-(BOOL)addNewStudentToDB:(Student *)student;

/*通过学生ID来删除记录*/
-(BOOL)deleteStudentByStudentID:(NSString *)studentID;

/**获得某个名字学生的列表*/
-(NSArray *)studentsWithStudentName:(NSString *)studentName;

/*根据学生ID获得记录*/
-(Student *)studentWithStudentID:(NSString *)studentID;

/*获得所有学生的列表*/
-(NSArray *)allStudents;

/*更新学生的状态*/
-(BOOL)updateStudent:(Student *)student;
@end
