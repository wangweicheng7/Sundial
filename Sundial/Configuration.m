//
//  Configuration.m
//  Sundial
//
//  Created by xinyue on 2019/4/4.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import "Configuration.h"
#import <ScreenSaver/ScreenSaver.h>
#import "NSColor+hex.h"

static NSString *const kModuleName = @"com.sundial.defaults";
static NSString *const kFontFamily = @"kFontFamily";
static NSString *const kTintColor =  @"kTintColor";

@interface Configuration ()

@property (nonatomic, strong) ScreenSaverDefaults *defaults;

@end

@implementation Configuration

@synthesize fontFamily = _fontFamily;

+ (instancetype)shareInstance {
    static Configuration *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[Configuration alloc] init];
        [config initialization];
    });
    return config;
}

- (void)initialization {
    //
    _defaults = [ScreenSaverDefaults defaultsForModuleWithName:kModuleName];
    
    // Register our default values
    [_defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                     @"Libian SC", kFontFamily,
                                     @(0xFAFAFA), kTintColor,
                                     nil]];
    
    _fontFamily = [self.defaults stringForKey:kFontFamily];
    _tintColor = [NSColor colorWithHex:[self.defaults integerForKey:kTintColor]];
    
    _colorSet = @[
                  [NSColor colorWithHex:0xFFFFFF],
                  [NSColor colorWithHex:0x8B2323],
                  [NSColor colorWithHex:0xFAFAFA],
                  [NSColor colorWithHex:0x7CCD7C],
                  [NSColor colorWithHex:0xEBEBEB],
                  [NSColor colorWithHex:0x20B2AA]
                  ];
}

- (void)setTintColor:(NSColor *)tintColor {
    _tintColor = tintColor;
    [_defaults setInteger:[NSColor hexFromColor:_tintColor] forKey:kTintColor];
    [_defaults synchronize];
}

- (void)setFontFamily:(NSString *)fontFamily {
    _fontFamily = fontFamily;
    [_defaults setValue:fontFamily forKey:kFontFamily];
    [_defaults synchronize];
}

@end
