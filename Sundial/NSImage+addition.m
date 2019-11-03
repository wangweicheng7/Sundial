//
//  NSImage+color.m
//  Sundial
//
//  Created by xinyue on 2019/4/9.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import "NSImage+addition.h"

@implementation NSImage (color)

+ (instancetype)imageWithColor:(NSColor *)color size:(CGSize)size {
    
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    [color drawSwatchInRect:NSMakeRect(0, 0, size.width, size.height)];
    [image unlockFocus];
    return image;
}

@end

@implementation NSImage (bundle)

+ (instancetype)imageWithName:(NSString *)imgName {
    NSString *resourcePath = [[NSBundle bundleWithIdentifier:@"com.sundial.weicheng"] pathForImageResource:imgName];
//    NSString *resourcePath = [[NSBundle mainBundle] pathForImageResource:imgName];
    NSURL *url = [NSURL fileURLWithPath:resourcePath];
    return [[NSImage alloc] initWithContentsOfURL:url];
}

@end
