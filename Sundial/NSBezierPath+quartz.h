//
//  NSBezierPath+quartz.h
//  Sundial
//
//  Created by wangweicheng on 2017/11/14.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (quartz)

- (CGPathRef)quartzPath;

@end
