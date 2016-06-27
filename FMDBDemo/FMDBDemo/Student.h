//
//  Student.h
//  FMDBDemo
//
//  Created by Apple on 16/6/25.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic,copy) NSString *studentID;

@property (nonatomic,copy) NSString *studentName;

@property (nonatomic,strong) NSNumber *studentAge;

@end
