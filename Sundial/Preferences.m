//
//  Preferences.m
//  Sundial
//
//  Created by wangweicheng on 2017/11/21.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import "Preferences.h"
#import <Foundation/Foundation.h>

@interface Preferences ()

@end

@implementation Preferences

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (NSNibName)windowNibName {
    return @"Preferences";
}

- (IBAction)okClicked:(NSButton *)sender {
//    [self.window endSheet:self.window];
    [NSApp endSheet:self.window];
}

@end
