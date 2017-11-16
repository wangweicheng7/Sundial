//
//  DiallView.h
//  Clock
//
//  Created by wangweicheng on 2017/11/14.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DialView : NSView

@property (nonatomic, strong) NSArray<NSString *> *textArray;

- (instancetype)initWithRadius:(CGFloat)radius center:(NSPoint)point minRadius:(CGFloat)minRadius;

@end
