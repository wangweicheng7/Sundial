//
//  NSColor+hex.m
//  Sundial
//
//  Created by xinyue on 2019/4/9.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import "NSColor+hex.h"
#import <ScreenSaver/ScreenSaver.h>

@implementation NSColor (hex)

+ (instancetype)colorWithHex:(NSInteger)hex {
    
    CGFloat red     = (hex >> 16 & 0xff)/255.0;
    CGFloat green   = (hex >> 8 & 0xff)/255.0;
    CGFloat blue    = (hex & 0xff)/255.0;
//    CGFloat alpha   = (hex >> 24 & 0xff)/255.0;
    
    NSAssert(red >= 0 && red <= 255, @"Invalid red component");
    NSAssert(green >= 0 && green <= 255, @"Invalid green component");
    NSAssert(blue >= 0 && blue <= 255, @"Invalid blue component");
//    NSAssert(alpha >= 0 && alpha <= 255, @"Invalid alpha component");
    
    NSColor *color = [NSColor colorWithRed:red green:green blue:blue alpha:1];
    return color;

}

+ (NSInteger)hexFromColor:(NSColor *)color {

    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    int r = resultingPixel[0];
    int g = resultingPixel[1];
    int b = resultingPixel[2];
    
    NSInteger hex = (r << 16) + (g << 8) + (b);
    
    
    NSLog(@"0x%lX",hex);
    return hex;
}

@end





