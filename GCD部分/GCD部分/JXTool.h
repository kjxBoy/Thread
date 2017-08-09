//
//  JXTool.h
//  GCD部分
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXTool : NSObject<NSCopying,NSMutableCopying>

//提供类方法，方便外界访问

/*
 规范:share + 类名 |share |default + 类名|manager
 */

+ (instancetype)shareTool;

@end
