//
//  Preferences.m
//  Sundial
//
//  Created by wangweicheng on 2017/11/21.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import "Preferences.h"
#import <ScreenSaver/ScreenSaver.h>
#import <Foundation/Foundation.h>
#import "Configuration.h"
#import "NSImage+addition.h"

#define FontFamilies @[@"Libian SC", @"FZXiaoZhuanTi-S13T"]

@interface Preferences ()

@property (nonatomic, strong) NSButton *okButton;
@property (nonatomic, strong) NSButton *cancelButton;

@property (nonatomic, strong) NSTextField *fontText;
@property (nonatomic, strong) NSTextField *colorText;

@property (nonatomic, strong) NSPopUpButton *fontPopUpButton;
@property (nonatomic, strong) NSPopUpButton *pickerButton;

@property (nonatomic, strong) NSTextField *previewText;
@property (nonatomic, strong) NSColorWell *colorWell;
@property (nonatomic, strong) NSTextField *tipsText;

@property (nonatomic, strong) NSButton *starCheckButton;
@property (nonatomic, strong) NSButton *sparkCheckButton;

@end

@implementation Preferences


- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    if (self) {
        self.releasedWhenClosed = NO;
        [self.contentView addSubview:self.okButton];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.fontPopUpButton];
        [self.contentView addSubview:self.pickerButton];
        [self.contentView addSubview:self.fontText];
        [self.contentView addSubview:self.colorText];
        
        [self.contentView addSubview:self.colorWell];
        [self.contentView addSubview:self.previewText];
        [self.contentView addSubview:self.tipsText];
        
        [self.contentView addSubview:self.starCheckButton];
        [self.contentView addSubview:self.sparkCheckButton];
        
        AnimationType type = [Configuration shareInstance].type;
        if (type & AnimationTypeSpark) {
            self.sparkCheckButton.state = YES;
        }
        if (type & AnimationTypeStar) {
            self.starCheckButton.state = YES;
        }
        
        NSLog(@"Preferences init...");
        
//        [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            [self.sundial animateOneFrame];
//        }];
    }
    return self;
}

- (void)buttonAction:(id)sender {
    [self.sheetParent endSheet:self];
}

- (void)selectFont:(NSPopUpButton *)sender {

//    self.fontPopUpButton.title = self.fontPopUpButton.selectedItem.title;
    NSInteger index = self.fontPopUpButton.indexOfSelectedItem;
    [Configuration shareInstance].fontFamily = FontFamilies[index];
    self.previewText.font = [NSFont fontWithName:[Configuration shareInstance].fontFamily size:24];
}
/*
- (void)pickFont:(id)sender {
    
    //不需要使用代理 NSFontManagerDelegate，代理也没有方法
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setTarget:self];
    [fontManager setAction:@selector(changeFont:)];
    [fontManager orderFrontFontPanel:self];
    fontManager.enabled = YES;
}

- (void)changeFont:(NSFontManager *)sender {
    NSFont *font = [sender convertFont:[NSFont systemFontOfSize:12]];
    
    self.fontText.font = [NSFont fontWithName:font.familyName size:12];
    
    [Configuration shareInstance].fontFamily = font.familyName;
    
    self.previewText.font = [NSFont fontWithName:[Configuration shareInstance].fontFamily size:24];
    
    NSLog(@"fontName : %@ , familyName : %@",font.fontName, font.familyName);
}
*/
- (void)selectColor:(NSPopUpButton *)sender {

    NSInteger index = self.pickerButton.indexOfSelectedItem;
    [Configuration shareInstance].tintColor = [Configuration shareInstance].colorSet[index];
    self.colorWell.color = [Configuration shareInstance].tintColor;
    self.previewText.textColor = [Configuration shareInstance].tintColor;
}
/*
- (void)pickColor:(id)sender {
    
    NSColorPanel *colorpanel = [NSColorPanel sharedColorPanel];
    
    colorpanel.mode = NSColorPanelModeRGB; //调出时，默认色盘
    
    [colorpanel setAction:@selector(changeColor:)];
    [colorpanel setTarget:self];
    [colorpanel orderFront:nil];
}

//颜色选择action事件
- (void)changeColor:(id)sender {
    NSColorPanel *colorPanel = sender ;
    NSColor *color = colorPanel.color;
    [Configuration shareInstance].tintColor = color;
    self.previewText.textColor = color;
}
*/

- (void)starCheckboxAction:(NSButton *)sender {
    
    AnimationType type = [Configuration shareInstance].type;
    
    if (sender.state) {
        [Configuration shareInstance].type = type | AnimationTypeStar;
    }else{
        [Configuration shareInstance].type = type ^ AnimationTypeStar;
    }
    
    NSLog(@"%lx", [Configuration shareInstance].type);
}

- (void)sparkCheckboxAction:(NSButton *)sender {
    
    AnimationType type = [Configuration shareInstance].type;
    
    if (sender.state) {
        [Configuration shareInstance].type = type | AnimationTypeSpark;
    }else{
        [Configuration shareInstance].type = type ^ AnimationTypeSpark;
    }
    
    NSLog(@"%lx", [Configuration shareInstance].type);
}

- (NSPopUpButton *)fontPopUpButton {
    if (!_fontPopUpButton) {
        _fontPopUpButton = [[NSPopUpButton alloc] initWithFrame:CGRectMake(50, 200, 100, 30) pullsDown:NO];
        [_fontPopUpButton addItemWithTitle:@"隶书"];
        [_fontPopUpButton addItemWithTitle:@"小篆"];
        [_fontPopUpButton setTarget:self];
        [_fontPopUpButton setAction:@selector(selectFont:)];
    }
    return _fontPopUpButton;
}

- (NSPopUpButton *)pickerButton {
    if (!_pickerButton) {
        _pickerButton = [[NSPopUpButton alloc] initWithFrame:CGRectMake(50, 150, 100, 30) pullsDown:NO];
        for (NSColor *color in [Configuration shareInstance].colorSet) {
            [_pickerButton addItemWithTitle:@""];
            [[_pickerButton lastItem] setImage:[NSImage imageWithColor:color size:CGSizeMake(55, 10)]];
        }
        [_pickerButton setTarget:self];
        [_pickerButton setAction:@selector(selectColor:)];
    }
    return _pickerButton;
}

- (NSButton *)okButton {
    if (!_okButton) {
        _okButton = [NSButton buttonWithTitle:@"好" target:self action:@selector(buttonAction:)];
        _okButton.frame = CGRectMake(440, 10, 50, 30);
        _okButton.highlighted = YES;
    }
    return _okButton;
}

- (NSButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [NSButton buttonWithTitle:@"取消" target:self action:@selector(buttonAction:)];
        _cancelButton.frame = CGRectMake(360, 10, 70, 30);
    }
    return _cancelButton;
}

- (NSTextField *)fontText {
    if (!_fontText) {
        _fontText = [NSTextField labelWithString:@"字体"];
        _fontText.frame = CGRectMake(10, 197, 40, 30);
        _fontText.maximumNumberOfLines = 1;
        _fontText.textColor = [NSColor whiteColor];
    }
    return _fontText;
}

- (NSTextField *)colorText {
    if (!_colorText) {
        _colorText = [NSTextField labelWithString:@"颜色"];
        _colorText.frame = CGRectMake(10, 147, 40, 30);
        _colorText.maximumNumberOfLines = 1;
        _colorText.textColor = [NSColor whiteColor];
        _colorText.stringValue = @"颜色";
    }
    return _colorText;
}

- (NSColorWell *)colorWell {
    if (!_colorWell) {
        _colorWell = [[NSColorWell alloc] initWithFrame:NSMakeRect(160, 150, 30, 30)];
        [_colorWell setWantsLayer:YES];
        _colorWell.color = [Configuration shareInstance].tintColor;
        _colorWell.enabled = NO;
//        _colorWell.target = self;
//        _colorWell.action = @selector(pickColor:);
    }
    return _colorWell;
}

- (NSTextField *)previewText {
    if (!_previewText) {
        _previewText = [NSTextField labelWithString:@"正午三刻"];
        _previewText.frame = CGRectMake(300, 200, 100, 50);
        _previewText.font = [NSFont fontWithName:[Configuration shareInstance].fontFamily size:24];
        _previewText.textColor = [Configuration shareInstance].tintColor;
        _previewText.maximumNumberOfLines = 1;
    }
    return _previewText;
}

- (NSButton *)starCheckButton {
    if (!_starCheckButton) {
        _starCheckButton = [NSButton buttonWithTitle:@"星星动画" target:self action:@selector(starCheckboxAction:)];
        [_starCheckButton setWantsLayer:YES];
        [_starCheckButton setButtonType:NSButtonTypeSwitch];
        _starCheckButton.highlighted = YES;
        _starCheckButton.allowsMixedState = NO;
        _starCheckButton.frame = CGRectMake(50, 100, 100, 30);
    }
    return _starCheckButton;
}

- (NSButton *)sparkCheckButton {
    if (!_sparkCheckButton) {
        _sparkCheckButton = [NSButton buttonWithTitle:@"烟火动画" target:self action:@selector(sparkCheckboxAction:)];
        [_sparkCheckButton setWantsLayer:YES];
        [_sparkCheckButton setButtonType:NSButtonTypeSwitch];
        _sparkCheckButton.highlighted = YES;
        _sparkCheckButton.allowsMixedState = NO;
        _sparkCheckButton.frame = CGRectMake(50, 70, 100, 30);
    }
    return _sparkCheckButton;
}

- (NSTextField *)tipsText {
    if (!_tipsText) {
        _tipsText = [NSTextField labelWithString:@"* 部分功能暂未开放"];
        _tipsText.frame = CGRectMake(20, 10, 200, 30);
        _tipsText.font = [NSFont systemFontOfSize:10];
        _tipsText.textColor = [NSColor lightGrayColor];
        _tipsText.maximumNumberOfLines = 1;
    }
    return _tipsText;
}

- (void)dealloc {
    NSLog(@"Preferences dealloc");
}

@end
