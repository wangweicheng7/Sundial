//
//  Sundial.h
//  Sundial
//
//  Created by wangweicheng on 2017/11/14.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import "Sundial.h"
#import "DialView.h"
#import <Quartz/Quartz.h>
#import "NSBezierPath+quartz.h"

@interface Sundial ()
{
    CGFloat _rotation;
    float _rate;
    NSBezierPath *_linePath;
    CGFloat _angle;
    
}

@property (nonatomic, strong) NSArray<NSString *> *textArray;
@property (nonatomic, strong) DialView *hourDialView;
@property (nonatomic, strong) DialView *quarterDialView;
@property (nonatomic, strong) DialView *secondDialView;
@property (nonatomic, strong) NSBezierPath *circularPath;
@property (nonatomic, strong) NSTextField *textField;
@property (nonatomic, strong) NSTextField   *timeTextField;

//@property (nonatomic, strong) TaiChiView *taiChiView;

@end

@implementation Sundial

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    if(self = [super initWithFrame:frame isPreview:isPreview]) {
        _rotation = 0;
        
        _rate = (frame.size.height)/([NSScreen mainScreen].visibleFrame.size.height);
        [self setAnimationTimeInterval:0.5];
//        [self addSubview:self.taiChiView];
        
    }
    return self;
}

- (void)startAnimation {
    [super startAnimation];
    
    
    self.hourDialView.textArray = @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"];
    self.quarterDialView.textArray = @[@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正"];
    
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSInteger i = 0; i < 96; i ++) {
        [tmp addObject:@""];
    }
    self.secondDialView.textArray = tmp;
    
    _linePath = [NSBezierPath bezierPath];
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow *)configureSheet {
    return nil;
}

- (void)animateOneFrame {
    [super animateOneFrame];
    
    if (!self.textField.superview) {
        [self addSubview:self.textField];
        
        
    }else if (!self.hourDialView.superview) {
        [self addSubview:self.hourDialView];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:self.hourDialView forKey:NSViewAnimationTargetKey];
//        NSRect viewZeroSize = [self.hourDialView frame];
//        viewZeroSize.size.width = 0;
//        viewZeroSize.size.height = 0;
//        [dict setObject:[NSValue valueWithRect:viewZeroSize] forKey:NSViewAnimationEndFrameKey];
//        [dict setObject:NSViewAnimationFadeInEffect forKey:NSViewAnimationEffectKey];
//        NSViewAnimation *anim = [[NSViewAnimation alloc] initWithViewAnimations:@[dict]];
//        anim.duration = 0.25;
//        anim.animationCurve = NSAnimationEaseInOut;
//        [anim startAnimation];
        
        
    }else if (!self.quarterDialView.superview) {
        [self addSubview:self.quarterDialView];
    }else if (!self.secondDialView.superview) {
        [self addSubview:self.secondDialView];
    }else{

    _rotation += 1;
//    [self.dialView setNeedsDisplay:YES];
    
    [self.hourDialView setNeedsLayout:YES];
    [self.quarterDialView setNeedsLayout:YES];
    [self.secondDialView setNeedsLayout:YES];
    self.textField.stringValue = [self currentDisplayTime];
    [self.textField sizeToFit];
    [self.textField setFrameOrigin:NSMakePoint(self.frame.size.width/2-_textField.bounds.size.width/2, self.frame.size.height/2- _textField.bounds.size.height/2)];
    }
    [self setNeedsDisplay:YES];
    
//    CALayer *layer = self.secondDialView.layer;
//
//    CATransform3D transfrom = CATransform3DIdentity;
//    _angle = _angle - M_PI/200.0;
//    if (_angle == -M_PI *2) {
//        _angle = 0;
//        NSLog(@"_angle reset");
//    }
//    CGPoint point = CGPointMake(0.5, 0.5);
////    transfrom = CATransform3DRotate(transfrom, _angle , 0.0f, 0.0f, 1.0f);
//    transfrom = CATransform3DConcat(transfrom, CATransform3DTranslate(CATransform3DIdentity, self.secondDialView.bounds.size.width, self.secondDialView.bounds.size.height, 0));
//    layer.anchorPoint = point;
//    layer.transform = transfrom;
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    
    [[NSColor whiteColor] set];
    
    [self.circularPath stroke];
    [_linePath removeAllPoints];
    
    float angle = M_PI/180*(360/1440.0);
    float radius = rect.size.height/2 - 30*_rate;
    float minRadius = rect.size.height/2-180*_rate;
    
    
    float minute = [self countTimeInterval]/60.0;
    
    NSPoint origin = NSMakePoint(rect.size.width/2+radius*sinf( angle*minute),
                                 rect.size.height/2+radius*cosf(angle*minute));
    
    NSPoint toPoint1 = NSMakePoint(rect.size.width/2+minRadius*sinf(angle*minute+M_PI/360),
                                  rect.size.height/2+minRadius*cosf(angle*minute+M_PI/360));
    
    NSPoint toPoint2 = NSMakePoint(rect.size.width/2+minRadius*sinf(angle*minute-M_PI/360),
                                  rect.size.height/2+minRadius*cosf(angle*minute-M_PI/360));
    
    [_linePath moveToPoint:origin];
    [_linePath lineToPoint:toPoint1];
    [_linePath lineToPoint:toPoint2];
    [_linePath closePath];
    [[NSColor redColor] set];
    [_linePath fill];
    
}

//计算时间差
-(NSTimeInterval)countTimeInterval{

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:date];
    
    NSString *zeroTime = @"00:00:00";
    NSDate *zeroDate = [formatter dateFromString:zeroTime];
    NSDate *currentDate = [formatter dateFromString:timeStr];
    // 因为是逆时针的
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:zeroDate];
    return interval;
}

//计算时间差
-(NSString *)currentDisplayTime{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:date];
    
    NSDate *currentDate = [formatter dateFromString:timeStr];
    NSString *time = [formatter stringFromDate:currentDate];
    
    return time;
}

- (NSTextField *)textField {
    if (!_textField) {
        _textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height-300*_rate, self.frame.size.height/2-150*_rate)];
        _textField.bordered = NO;
        _textField.backgroundColor = [NSColor clearColor];
        _textField.selectable = NO;
        _textField.textColor = [NSColor whiteColor];
        _textField.cell.font = [NSFont fontWithName:@"HelveticaNeue-UltraLight" size:108*_rate];
        _textField.cell.alignment = NSTextAlignmentCenter;
    }
    return _textField;
}

- (NSBezierPath *)circularPath {
    if (!_circularPath) {
        NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
        CGFloat radius = self.bounds.size.height/2-160*_rate;
        NSRect rect = NSMakeRect(point.x - radius, point.y - radius, radius*2, radius*2);
        _circularPath = [NSBezierPath bezierPathWithOvalInRect:rect];
    }
    return _circularPath;
}

- (DialView *)hourDialView {
    if (!_hourDialView) {
        
        NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
        _hourDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-100*_rate center:point minRadius:self.bounds.size.height/2-160*_rate];
    }
    return _hourDialView;
}

- (DialView *)quarterDialView {
    if (!_quarterDialView) {
        NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
        _quarterDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-50*_rate center:point minRadius:self.bounds.size.height/2-100*_rate];
    }
    return _quarterDialView;
}

- (DialView *)secondDialView {
    if (!_secondDialView) {
        
        NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
        _secondDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-30*_rate center:point minRadius:self.bounds.size.height/2-50*_rate];
    }
    return _secondDialView;
}

@end
