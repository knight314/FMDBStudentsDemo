//
//  Student.m
//  FMDBDemo
//
//  Created by Apple on 16/6/25.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import "Student.h"

@implementation Student

-(NSString *)description{
    NSMutableString *mutableDescription=[NSMutableString string];
    [mutableDescription appendFormat:@"student id==%@\n",self.studentID];
    [mutableDescription appendFormat:@"student name==%@\n",self.studentName ];
    [mutableDescription appendFormat:@"student age==%@",self.studentAge];
    
    return mutableDescription;
    

}

@end
