//
//  DiallView.m
//  Sundial
//
//  Created by wangweicheng on 2017/11/14.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import "DialView.h"
#import <Quartz/Quartz.h>
#import "Configuration.h"
#import "NSBezierPath+quartz.h"

@interface DialView () {
    float _rotation;
    float _minRadius;
    float _radius;
    float _rate;
    float _startAngle;
    NSBezierPath *_path;
    NSMutableArray *_textFields;
    BOOL _animation;
}

@end

@implementation DialView

@synthesize textArray = _textArray;

- (instancetype)initWithRadius:(CGFloat)radius center:(NSPoint)point minRadius:(CGFloat)minRadius startAngle:(CGFloat)angle {
    _rate = radius*2/([NSScreen mainScreen].visibleFrame.size.height);
    _startAngle = angle;
    if (self = [super initWithFrame:NSMakeRect(point.x - radius, point.y - radius, radius*2, radius*2)]) {
        _minRadius = minRadius;
        _radius = radius;
        _textFields = [NSMutableArray array];
        _path = [NSBezierPath bezierPath];
    }
    return self;
}

- (instancetype)initWithRadius:(CGFloat)radius center:(NSPoint)point minRadius:(CGFloat)minRadius {
    
    _rate = radius*2/([NSScreen mainScreen].visibleFrame.size.height);
    _startAngle = 0;
    if (self = [super initWithFrame:NSMakeRect(point.x - radius, point.y - radius, radius*2, radius*2)]) {
        _minRadius = minRadius;
        _radius = radius;
        _textFields = [NSMutableArray array];
        _path = [NSBezierPath bezierPath];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _textFields = [NSMutableArray array];
        _path = [NSBezierPath bezierPath];
        _startAngle = 0;
    }
    return self;
}

- (void)display:(BOOL)animation {

    CGRect rect = NSMakeRect((self.bounds.size.width - self.bounds.size.height)/2+1, 1, self.bounds.size.height-2, self.bounds.size.height-2);
    NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:rect];
    circlePath.lineWidth = 2;
    
    CGFloat radius = 0;
    float radian = 360.0/(self.textArray.count == 0 ? 1 : self.textArray.count);
    double angle = M_PI/180*radian;
    
    for (NSInteger i = 0; i < self.textArray.count; i ++) {
        
        radius = self.frame.size.height/2;
        
        NSPoint origin = NSMakePoint(radius+radius*cosf(angle*i-_startAngle),
                                     radius+radius*sinf(angle*i-_startAngle));
        
        NSPoint toPoint = NSMakePoint(self.frame.size.width/2 + _minRadius*cosf(angle*i-_startAngle),
                                      self.frame.size.width/2 + _minRadius*sinf(angle*i-_startAngle));
        [circlePath moveToPoint:origin];
        [circlePath lineToPoint:toPoint];
    }
    
    CAShapeLayer *clayer = [CAShapeLayer layer];
    clayer.fillColor = [NSColor clearColor].CGColor;
    clayer.lineWidth = 1.0f;
    clayer.lineCap = kCALineCapRound;
    clayer.lineJoin = kCALineJoinRound;
    clayer.strokeColor = [Configuration shareInstance].tintColor.CGColor;
    clayer.autoreverses = YES;
    
    // 关联layer和贝塞尔路径
    clayer.path = [circlePath quartzPath];
    [self setWantsLayer:YES];
    [self.layer addSublayer:clayer];
    
    // 创建Animation
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    anim.duration = 3.0;
    
    if (animation) {
        // 设置layer的animation
        [clayer addAnimation:anim forKey:nil];
    }
}

- (void)setTextArray:(NSArray<NSString *> *)textArray {
    _textArray = textArray;
    // 移除所有的文字
    [self.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSTextField class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    NSView *colorView = [[NSView alloc] initWithFrame:CGRectMake(10,10, 100, 100)];
    colorView.layer.backgroundColor = [NSColor redColor].CGColor;
    [self addSubview:colorView];
    [colorView setNeedsDisplay:YES];
    
    _rotation = 0;
    float radius = (_radius + _minRadius)/2;;
    float angle = M_PI/180*(360.0/textArray.count);
    // 文字偏移弧度
    float offset = _startAngle - angle/2;
    NSUInteger i = 0;
    for (NSString *text in _textArray) {
        
        NSTextField *textField = [[NSTextField alloc] init];
        textField.backgroundColor = [NSColor clearColor];
        textField.bordered = NO;
        textField.selectable = NO;
        textField.textColor = [Configuration shareInstance].tintColor;
        textField.stringValue = text;
        if (textArray.count == 12) {
            textField.cell.font = [NSFont fontWithName:[Configuration shareInstance].fontFamily size:44*_rate];
        }else{
            textField.cell.font = [NSFont fontWithName:@"Libian SC" size:20*_rate];
        }
        [textField sizeToFit];
        
        NSPoint origin = NSMakePoint(radius*sinf(angle*i-offset) - textField.frame.size.width/2 + _radius,
                                     radius*cosf(angle*i-offset) - textField.frame.size.height/2 + _radius);
        
        [textField setFrameOrigin:origin];
        textField.frameCenterRotation = 180/M_PI * (M_PI - (angle*i-offset));
        [self addSubview:textField];
        i ++;
        [_textFields addObject:textField];
    }
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    /*[_path removeAllPoints];
    NSRect _rect = NSMakeRect((dirtyRect.size.width - dirtyRect.size.height)/2+1, 1, dirtyRect.size.height-2, dirtyRect.size.height-2);
    [_path appendBezierPathWithOvalInRect:_rect];
    
    CGFloat radius = 0;
    float radian = 360.0/(self.textArray.count == 0 ? 1 : self.textArray.count);
    double angle = M_PI/180*radian;
    
    for (NSInteger i = 0; i < self.textArray.count; i ++) {
        
        radius = dirtyRect.size.height/2;
        
        NSPoint origin = NSMakePoint(radius+radius*cosf(angle*i-_startAngle),
                                     radius+radius*sinf(angle*i-_startAngle));
        
        NSPoint toPoint = NSMakePoint(dirtyRect.size.width/2 + _minRadius*cosf(angle*i-_startAngle),
                                      dirtyRect.size.width/2 + _minRadius*sinf(angle*i-_startAngle));
        [_path moveToPoint:origin];
        [_path lineToPoint:toPoint];
    }
    
    
    [[NSColor colorWithWhite:0.7 alpha:1] set];
    [_path stroke];
    
    [_path removeAllPoints];*/
}

- (NSArray<NSString *> *)textArray {
    if (!_textArray) {
        _textArray = [[NSArray alloc] init];
    }
    return _textArray;
}

@end
