//
//  Sundial.h
//  Sundial
//
//  Created by wangweicheng on 2017/11/14.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import "Sundial.h"
#import "DialView.h"
#import "StarView.h"
#import <Quartz/Quartz.h>
#import "NSBezierPath+quartz.h"
#import "Preferences.h"
#import "Configuration.h"

@interface Sundial ()<CAAnimationDelegate>
{
    float _rate;
}

@property (nonatomic, strong) NSArray<NSString *> *textArray;

@property (nonatomic, strong) StarView *starView;
@property (nonatomic, strong) DialView *hourDialView;
@property (nonatomic, strong) DialView *quarterDialView;
@property (nonatomic, strong) DialView *secondDialView;
@property (nonatomic, strong) NSTextField *textField;
@property (nonatomic, strong) NSTextField   *timeTextField;

@end

@implementation Sundial

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    if(self = [super initWithFrame:frame isPreview:isPreview]) {
        
        _rate = (frame.size.height)/([NSScreen mainScreen].visibleFrame.size.height);
        [self setAnimationTimeInterval:0.25];
        
    }
    return self;
}

- (void)exchange {
    
    NSPoint point = NSMakePoint(self.frame.size.width, self.frame.size.height/2);
    _hourDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-100*_rate center:point minRadius:self.bounds.size.height/2-160*_rate];
    _hourDialView.frameCenterRotation = 75;
    
    [self addSubview:self.hourDialView];
    
    point = NSMakePoint(self.frame.size.width, self.frame.size.height/2);
    _quarterDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-50*_rate center:point minRadius:self.bounds.size.height/2-100*_rate];
    
    [self addSubview:self.quarterDialView];
    
    point = NSMakePoint(self.frame.size.width, self.frame.size.height/2);
    _secondDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-30*_rate center:point minRadius:self.bounds.size.height/2-50*_rate];
    [self addSubview:self.secondDialView];
    
    
}

- (void)startAnimation {
    [super startAnimation];
    
    
    self.hourDialView.textArray = @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"];
    self.quarterDialView.textArray = @[@"始", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正",@"初", @"正"];
//    self.secondDialView.textArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSInteger i = 0; i < 96; i ++) {
        [tmp addObject:@""];
    }
    self.secondDialView.textArray = tmp;
    
//    [self.player play];
    [self display:YES];
    
    
}

- (BOOL)hasConfigureSheet {
    return YES;
}

- (NSWindow *)configureSheet {
    Preferences *preferences = [[Preferences alloc] initWithContentRect:CGRectMake(0, 0, 500, 300) styleMask:NSWindowStyleMaskNonactivatingPanel backing:NSBackingStoreBuffered defer:YES];
    return preferences;
}

- (void)animateOneFrame {
    [super animateOneFrame];
    
    if (!self.hourDialView.superview) {
        [self addSubview:self.hourDialView];
        [self.hourDialView display:YES];
    }else if (!self.quarterDialView.superview) {
        [self addSubview:self.quarterDialView];
        [self.quarterDialView display:YES];
    }else if (!self.secondDialView.superview) {
        [self addSubview:self.secondDialView];
        [self.secondDialView display:YES];
    }else if (!self.textField.superview) {
        [self addSubview:self.textField];
    }else if (![self.starView superview]){
        [self addSubview:self.starView];
        [self.starView startAnimation];
    }else{
        
        self.textField.stringValue = [self currentDisplayTime];
        [self.textField sizeToFit];
        [self.textField setFrameOrigin:NSMakePoint(self.frame.size.width/2-_textField.bounds.size.width/2, self.frame.size.height/2- _textField.bounds.size.height/2)];
    }
    
}

- (void)display:(BOOL)animation {
    // 画内圆
    NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat cicleRadius = self.bounds.size.height/2-160*_rate;
    NSRect pathRect = NSMakeRect(point.x - cicleRadius, point.y - cicleRadius, cicleRadius*2, cicleRadius*2);
    NSBezierPath *circularPath = [NSBezierPath bezierPathWithOvalInRect:pathRect];
    
    circularPath.lineWidth = 1.0f;
    
    CAShapeLayer *clayer = [CAShapeLayer layer];
    clayer.fillColor = [NSColor clearColor].CGColor;
    clayer.lineWidth = 1.0f;
    clayer.lineCap = kCALineCapRound;
    clayer.lineJoin = kCALineJoinRound;
    clayer.strokeColor = [Configuration shareInstance].tintColor.CGColor;
    clayer.autoreverses = YES;
    
    // 关联layer和贝塞尔路径
    clayer.path = [circularPath quartzPath];
    [self setWantsLayer:YES];
    [self.layer addSublayer:clayer];
    
    // 画指针
    NSBezierPath *linePath = [NSBezierPath bezierPath];
    
    CGRect rect = self.bounds;
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
    
    [linePath moveToPoint:toPoint2];
    [linePath lineToPoint:origin];
    
    [linePath lineToPoint:toPoint1];
    [linePath lineToPoint:origin];
    
    
    
    CAShapeLayer *llayer = [CAShapeLayer layer];
    llayer.fillColor = [NSColor clearColor].CGColor;
    llayer.lineWidth = 1.0f;
    llayer.lineCap = kCALineCapRound;
    llayer.lineJoin = kCALineJoinRound;
    llayer.strokeColor = [NSColor redColor].CGColor;
    llayer.autoreverses = NO;
    
    // 关联layer和贝塞尔路径
    llayer.path = [linePath quartzPath];
    [self setWantsLayer:YES];
    [self.layer addSublayer:llayer];
    
    // 创建Animation
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    anim.duration = 1.0;
    anim.delegate = self;
    if (animation) {
        // 设置layer的animation
        [clayer addAnimation:anim forKey:nil];
        [llayer addAnimation:anim forKey:nil];
    }
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    /*
    [[NSColor colorWithWhite:0.7 alpha:1] set];
    
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
    */
}

/// 计算时间差，画变盘上的红色指针
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

/// 计算时间差，显示时间
-(NSString *)currentDisplayTime{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:date];
    
    NSDate *currentDate = [formatter dateFromString:timeStr];
    NSString *time = [formatter stringFromDate:currentDate];
    
    return time;
}
/// 时间刻度
- (NSTextField *)textField {
    if (!_textField) {
        _textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height-300*_rate, self.frame.size.height/2-150*_rate)];
        _textField.bordered = NO;
        _textField.backgroundColor = [NSColor clearColor];
        _textField.selectable = NO;
        _textField.textColor = [Configuration shareInstance].tintColor;
        _textField.cell.font = [NSFont fontWithName:@"HelveticaNeue-UltraLight" size:108*_rate];
        _textField.cell.alignment = NSTextAlignmentCenter;
    }
    return _textField;
}

//- (NSBezierPath *)circularPath {
//    if (!_circularPath) {
//        NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
//        CGFloat radius = self.bounds.size.height/2-160*_rate;
//        NSRect rect = NSMakeRect(point.x - radius, point.y - radius, radius*2, radius*2);
//        _circularPath = [NSBezierPath bezierPathWithOvalInRect:rect];
//    }
//    return _circularPath;
//}

- (StarView *)starView {
    if (!_starView) {
        _starView = [[StarView alloc] initWithFrame:self.bounds];
        [_starView setWantsLayer:YES];
    }
    return _starView;
}

- (DialView *)hourDialView {
    if (!_hourDialView) {
        
        NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
        _hourDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-100*_rate center:point minRadius:self.bounds.size.height/2-160*_rate startAngle:360.0/24*M_PI/180];
    }
    return _hourDialView;
}

- (DialView *)quarterDialView {
    if (!_quarterDialView) {
        NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
        _quarterDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-50*_rate center:point minRadius:self.bounds.size.height/2-100*_rate startAngle:360.0/24*M_PI/180];
    }
    return _quarterDialView;
}

- (DialView *)secondDialView {
    if (!_secondDialView) {
        
        NSPoint point = NSMakePoint(self.frame.size.width/2, self.frame.size.height/2);
        _secondDialView = [[DialView alloc] initWithRadius:self.bounds.size.height/2-30*_rate center:point minRadius:self.bounds.size.height/2-50*_rate startAngle:360.0/96*M_PI/180];
    }
    return _secondDialView;
}

@end
