//
//  NSImage+color.h
//  Sundial
//
//  Created by xinyue on 2019/4/9.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (color)

+(instancetype)imageWithColor:(NSColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
