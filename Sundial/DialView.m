//
//  DiallView.m
//  Sundial
//
//  Created by wangweicheng on 2017/11/14.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import "DialView.h"
#import <Quartz/Quartz.h>

@interface DialView () {
    float _rotation;
    float _minRadius;
    float _radius;
    float _rate;
    NSBezierPath *path;
    NSMutableArray *_textFields;
}

@end

@implementation DialView

@synthesize textArray = _textArray;

- (instancetype)initWithRadius:(CGFloat)radius center:(NSPoint)point minRadius:(CGFloat)minRadius {
    
    _rate = radius*2/([NSScreen mainScreen].visibleFrame.size.height);
    
    if (self = [super initWithFrame:NSMakeRect(point.x - radius, point.y - radius, radius*2, radius*2)]) {
        _minRadius = minRadius;
        _radius = radius;
        _textFields = [NSMutableArray array];
        path = [NSBezierPath bezierPath];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _textFields = [NSMutableArray array];
        path = [NSBezierPath bezierPath];
    }
    return self;
}

- (void)setTextArray:(NSArray<NSString *> *)textArray {
    _textArray = textArray;
    // 移除所有的文字
    [self.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    _rotation = 0;
    float radius = (_radius + _minRadius)/2;;
    float angle = M_PI/180*(360.0/textArray.count);
    NSUInteger i = textArray.count;
    for (NSString *text in _textArray) {
        
        NSTextField *textField = [[NSTextField alloc] init];
        textField.backgroundColor = [NSColor clearColor];
        textField.bordered = NO;
        textField.selectable = NO;
        textField.textColor = [NSColor whiteColor];
        textField.stringValue = text;
        if (textArray.count == 12) {
            textField.cell.font = [NSFont fontWithName:@"Libian SC" size:44*_rate];
        }else{
            textField.cell.font = [NSFont fontWithName:@"Libian SC" size:20*_rate];
        }
        [textField sizeToFit];
        
        NSPoint origin = NSMakePoint(radius*cosf(angle*(i+0.5)) - textField.frame.size.width/2 + _radius,
                                     radius*sinf(angle*(i+0.5)) - textField.frame.size.height/2 + _radius);
        
        [textField setFrameOrigin:origin];
        textField.frameCenterRotation = 180/M_PI * angle*(i+0.5) + 90;
        [self addSubview:textField];
        i --;
        [_textFields addObject:textField];
    }
    
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect _rect = NSMakeRect((dirtyRect.size.width - dirtyRect.size.height)/2, 0, dirtyRect.size.height, dirtyRect.size.height);
    [path appendBezierPathWithOvalInRect:_rect];
    
    CGFloat radius = 0;
    float radian = 360.0/(self.textArray.count == 0 ? 1 : self.textArray.count);
    double angle = M_PI/180*radian;
    
    for (NSInteger i = 0; i < 96; i ++) {
        
        radius = dirtyRect.size.height/2;
        
        NSPoint origin = NSMakePoint(radius+radius*cosf(angle*i),
                                     radius+radius*sinf(angle*i));
        
        NSPoint toPoint = NSMakePoint(dirtyRect.size.width/2 + _minRadius*cosf(angle*i),
                                      dirtyRect.size.width/2 + _minRadius*sinf(angle*i));
        [path moveToPoint:origin];
        [path lineToPoint:toPoint];
    }
    
    
    [[NSColor whiteColor] set];
    [path stroke];
    
    [path removeAllPoints];
}

- (NSArray<NSString *> *)textArray {
    if (!_textArray) {
        _textArray = [[NSArray alloc] init];
    }
    return _textArray;
}

@end
