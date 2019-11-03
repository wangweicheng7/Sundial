//
//  NSColor+hex.h
//  Sundial
//
//  Created by xinyue on 2019/4/9.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (hex)

+ (instancetype)colorWithHex:(NSInteger)hex;

+ (NSInteger)hexFromColor:(NSColor *)color;

@end

NS_ASSUME_NONNULL_END
