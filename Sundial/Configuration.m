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

static NSString *const kModuleName  = @"com.sundial.defaults";
static NSString *const kFontFamily  = @"kFontFamily";
static NSString *const kTintColor   = @"kTintColor";
static NSString *const kAnimType    = @"kAnimType";

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
    [self registerFonts];
    //
    _defaults = [ScreenSaverDefaults defaultsForModuleWithName:kModuleName];
    
    // Register our default values
    [_defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Libian SC", kFontFamily,
                                 @(0xFAFAFA), kTintColor,
                                 @(AnimationTypeStar | AnimationTypeSpark), kAnimType,
                                 nil]];
    
    
    _fontFamily = [self.defaults stringForKey:kFontFamily];
    _tintColor = [NSColor colorWithHex:[self.defaults integerForKey:kTintColor]];
    
    _type = [self.defaults integerForKey:kAnimType];
    
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

- (void)setType:(AnimationType)type {
    _type = type;
    [_defaults setInteger:type forKey:kAnimType];
    [_defaults synchronize];
}

- (void)registerFonts {
    
    NSArray *fontURLs = [[NSBundle bundleWithIdentifier:@"com.sundial.weicheng"] URLsForResourcesWithExtension:@"TTF" subdirectory:@""];
    
    for (NSURL *URL in fontURLs) {
        CFErrorRef error = 0;
        bool ok = CTFontManagerRegisterFontsForURL((__bridge CFURLRef)URL, kCTFontManagerScopeProcess, &error);
        assert(ok && !error);
    }
    CTFontRef f = CTFontCreateWithName( CFSTR( "FZXZTFW" ), 10.0, NULL ) ;
    assert(f);
}

@end
