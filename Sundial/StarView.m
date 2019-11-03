//
//  StarView.m
//  Sundial
//
//  Created by xinyue on 2019/4/10.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import "StarView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSImage+addition.h"

@interface StarView ()

@property (nonatomic, strong) CAEmitterCell *particleCell;

@property (nonatomic, strong) NSTimer *emitterTimer;
@property (nonatomic, strong) CAEmitterLayer *emitter;
@property (nonatomic, strong) NSImageView *img;
@property (nonatomic, strong) CAEmitterLayer *starEmitterLayer;
@property (nonatomic, strong) CAEmitterLayer *sparkEmitterLayer;

@end

@implementation StarView

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

- (void)sparkAnimation:(BOOL)animation {
    NSLog(@"%d", animation);
    if (!animation) {
        if ([self.sparkEmitterLayer superlayer]) {
            [self.sparkEmitterLayer removeFromSuperlayer];
        }
        return;
    }
    
    if ([self.sparkEmitterLayer superlayer]) {
        return;
    }
    
    [self setWantsLayer:YES];
    [self.layer addSublayer:self.sparkEmitterLayer];
    
    /// 烟花
    // 爆炸前的移动星星圆粒子
    CAEmitterCell *cycleCell = [CAEmitterCell emitterCell];
    cycleCell.birthRate = 1;
    cycleCell.lifetime = 1.02;
    cycleCell.emissionLatitude = 0;
    cycleCell.emissionLongitude = 0;
    cycleCell.emissionRange = M_PI_4/2;    // 发射角度范围
    cycleCell.velocity = -self.frame.size.height+200;
    NSImage* someImage3 = [NSImage imageWithName:@"cycle1"];
    CGImageSourceRef source3 = CGImageSourceCreateWithData((CFDataRef)[someImage3 TIFFRepresentation], NULL);
    CGImageRef maskRef3 =  CGImageSourceCreateImageAtIndex(source3, 0, NULL);
    cycleCell.contents = (__bridge id _Nullable)(maskRef3);
    cycleCell.scale = 0.1;
    
    cycleCell.greenRange                 = 1.0;
    cycleCell.redRange                   = 1.0;
    cycleCell.blueRange                  = 1.0;
    
    // 爆炸时的粒子
    CAEmitterCell *burstCell = [CAEmitterCell emitterCell];
    burstCell.birthRate = cycleCell.birthRate;
    burstCell.scale = 2.5;
    burstCell.lifetime = 0.2;
    
    // 爆炸后的散射星星例子
    CAEmitterCell *sparkCell = [CAEmitterCell emitterCell];
    sparkCell.birthRate = 600;
    sparkCell.velocity = 200;
    sparkCell.lifetime = 1;
    sparkCell.lifetimeRange = 0.5;
    sparkCell.emissionRange = 2*M_PI;    // 发射角度范围
    sparkCell.yAcceleration = 75;
    NSImage* someImage4 = [NSImage imageWithName:@"spark"];
    CGImageSourceRef source4 = CGImageSourceCreateWithData((CFDataRef)[someImage4 TIFFRepresentation], NULL);
    CGImageRef maskRef4 =  CGImageSourceCreateImageAtIndex(source4, 0, NULL);
    sparkCell.contents = (__bridge id _Nullable)(maskRef4);
//    sparkCell.color = [NSColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
    sparkCell.alphaSpeed = -0.8;
    sparkCell.scale = 2;
    sparkCell.scaleRange = 0.1;
    sparkCell.spin = 2*M_PI;;
    
    sparkCell.color = cycleCell.color;
    sparkCell.redRange = 0.5;
    sparkCell.greenRange = 0.5;
    sparkCell.blueRange = 0.5;
    
    self.sparkEmitterLayer.emitterCells = @[cycleCell];
    cycleCell.emitterCells = @[burstCell];
    burstCell.emitterCells = @[sparkCell];
    
}

- (void)ccsparkAnimation:(BOOL)animation {
    
    NSLog(@"%d", animation);
    if (!animation) {
        if ([self.sparkEmitterLayer superlayer]) {
            [self.sparkEmitterLayer removeFromSuperlayer];
        }
        return;
    }
    
    if ([self.sparkEmitterLayer superlayer]) {
        return;
    }
    
    [self setWantsLayer:YES];
    [self.layer addSublayer:self.sparkEmitterLayer];


    self.sparkEmitterLayer.renderMode = kCAEmitterLayerAdditive;
//    cycleCell.birthRate = 1;
//    cycleCell.lifetime = 1.02;
//    cycleCell.emissionLatitude = 0;
//    cycleCell.emissionLongitude = 0;
//    cycleCell.emissionRange = M_PI_4/2;    // 发射角度范围
//    cycleCell.velocity = -self.frame.size.height+200;

//    CAEmitterCell *cycleCell = [CAEmitterCell emitterCell];
//    cycleCell.birthRate = 6;
//    cycleCell.lifetime = 1.02;
//    cycleCell.emissionLatitude = 0;
//    cycleCell.emissionLongitude = 0;
//    cycleCell.emissionRange = M_PI_4/2;    // 发射角度范围
//    cycleCell.velocity = -self.frame.size.height+200;
//    NSImage* someImage3 = [NSImage imageWithName:@"cycle1"];
//    CGImageSourceRef source3 = CGImageSourceCreateWithData((CFDataRef)[someImage3 TIFFRepresentation], NULL);
//    CGImageRef maskRef3 =  CGImageSourceCreateImageAtIndex(source3, 0, NULL);
//    cycleCell.contents = (__bridge id _Nullable)(maskRef3);
//    cycleCell.scale = 0.1;
//
//    cycleCell.greenRange                 = 1.0;
//    cycleCell.redRange                   = 1.0;
//    cycleCell.blueRange                  = 1.0;
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.emissionLongitude = 0;
    emitterCell.emissionLatitude = 0;
    emitterCell.lifetime = 1.02;
    emitterCell.birthRate = 1;
    emitterCell.velocity = -self.frame.size.height+200;
//    emitterCell.velocityRange = 0;
//    emitterCell.yAcceleration = 0;
    emitterCell.emissionRange = M_PI / 2;
//    emitterCell.color = [NSColor redColor].CGColor;
    emitterCell.scale = 0.2;
    emitterCell.redRange = 0.9;
    emitterCell.greenRange = 0.9;
    emitterCell.blueRange = 0.9;
    emitterCell.name = @"base";

    NSImage* someImage4 = [NSImage imageWithName:@"cycle1"];
    CGImageSourceRef source4 = CGImageSourceCreateWithData((CFDataRef)[someImage4 TIFFRepresentation], NULL);
    CGImageRef maskRef4 =  CGImageSourceCreateImageAtIndex(source4, 0, NULL);
    emitterCell.contents = (__bridge id _Nullable)(maskRef4);
    
//    CAEmitterCell *flareCell =  [CAEmitterCell emitterCell];
//    flareCell.emissionLongitude = 4 * M_PI / 2;
//    flareCell.scale = 0.4;
//    flareCell.velocity = 80;
//    flareCell.birthRate = 45;
//    flareCell.lifetime = 0.5;
//    flareCell.yAcceleration = -350;
//    flareCell.emissionRange = M_PI / 7;
//    flareCell.alphaSpeed = -0.7;
//    flareCell.scaleSpeed = -0.1;
//    flareCell.scaleRange = 0.1;
//    flareCell.beginTime = 0.01;
//    flareCell.duration = 1.7;
    CAEmitterCell *flareCell = [CAEmitterCell emitterCell];
    flareCell.birthRate = emitterCell.birthRate;
    flareCell.scale = 2.5;
    flareCell.lifetime = 0.2;
    
    CAEmitterCell *fireworkCell = [CAEmitterCell emitterCell];
    fireworkCell.birthRate = 600;
    fireworkCell.velocity = 200;
    fireworkCell.lifetime = 1;
    fireworkCell.lifetimeRange = 0.5;
    fireworkCell.emissionRange = 2*M_PI;    // 发射角度范围
    fireworkCell.yAcceleration = 75;
    NSImage* someImage5 = [NSImage imageWithName:@"spark"];
    CGImageSourceRef source5 = CGImageSourceCreateWithData((CFDataRef)[someImage5 TIFFRepresentation], NULL);
    CGImageRef maskRef5 =  CGImageSourceCreateImageAtIndex(source5, 0, NULL);
    fireworkCell.contents = (__bridge id _Nullable)(maskRef5);
    //    sparkCell.color = [NSColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
    fireworkCell.alphaSpeed = -0.8;
    fireworkCell.scale = 2;
    fireworkCell.scaleRange = 0.1;
    fireworkCell.spin = 2*M_PI;;
    
    fireworkCell.color = emitterCell.color;
    fireworkCell.redRange = 0.5;
    fireworkCell.greenRange = 0.5;
    fireworkCell.blueRange = 0.5;
    
    //    CAEmitterCell *fireworkCell = [CAEmitterCell emitterCell];
    //
    //    NSImage* someImage3 = [NSImage imageWithName:@"spark"];
    //    CGImageSourceRef source3 = CGImageSourceCreateWithData((CFDataRef)[someImage3 TIFFRepresentation], NULL);
    //    CGImageRef maskRef3 =  CGImageSourceCreateImageAtIndex(source3, 0, NULL);
    //
    //    fireworkCell.contents = (__bridge id _Nullable)(maskRef3);
        fireworkCell.birthRate = 600;
        fireworkCell.scale = 0.6;
    //    fireworkCell.velocity = 130;
    //    fireworkCell.lifetime = 100;
    //    fireworkCell.alphaSpeed = -0.2;
    //    fireworkCell.yAcceleration = -80;
    //    fireworkCell.beginTime = 1.5;
    //    fireworkCell.duration = 0.1;
    //    fireworkCell.emissionRange = 2 * M_PI;
    //    fireworkCell.scaleSpeed = -0.1;
    //    fireworkCell.spin = 2;
    
//    self.sparkEmitterLayer.emitterCells = @[emitterCell];
//    emitterCell.emitterCells = @[flareCell];
//    flareCell.emitterCells = @[fireworkCell];
    
    emitterCell.emitterCells = @[flareCell];
    flareCell.emitterCells = @[fireworkCell];
    self.sparkEmitterLayer.emitterCells = @[emitterCell];
    
}

- (void)ddsparkAnimation:(BOOL)animation {
    
    NSLog(@"%d", animation);
    if (!animation) {
        if ([self.sparkEmitterLayer superlayer]) {
            [self.sparkEmitterLayer removeFromSuperlayer];
        }
        return;
    }
    
    if ([self.sparkEmitterLayer superlayer]) {
        return;
    }
    
    [self setWantsLayer:YES];
    [self.layer addSublayer:self.sparkEmitterLayer];
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.emissionLongitude = 0;
    emitterCell.emissionLatitude = 0;
    emitterCell.lifetime = 1.02;
    emitterCell.birthRate = 6;
    emitterCell.velocity = -self.frame.size.height+200;
    emitterCell.velocityRange = 0;
    emitterCell.yAcceleration = 0;
    emitterCell.emissionRange = M_PI / 2;
    emitterCell.scale = 0.2;
    emitterCell.redRange = 0.9;
    emitterCell.greenRange = 0.9;
    emitterCell.blueRange = 0.9;
    emitterCell.name = @"base";
    
    NSImage* someImage4 = [NSImage imageWithName:@"cycle1"];
    CGImageSourceRef source4 = CGImageSourceCreateWithData((CFDataRef)[someImage4 TIFFRepresentation], NULL);
    CGImageRef maskRef4 =  CGImageSourceCreateImageAtIndex(source4, 0, NULL);
    CAEmitterCell *flareCell =  [CAEmitterCell emitterCell];
    flareCell.contents = (__bridge id _Nullable)(maskRef4);
    flareCell.emissionLongitude = 4 * M_PI / 2;
    flareCell.scale = 0.4;
    flareCell.velocity = 80;
    flareCell.birthRate = 45;
    flareCell.lifetime = 0.5;
    flareCell.yAcceleration = -350;
    flareCell.emissionRange = M_PI / 7;
    flareCell.alphaSpeed = -0.7;
    flareCell.scaleSpeed = -0.1;
    flareCell.scaleRange = 0.1;
    flareCell.beginTime = 0.01;
    flareCell.duration = 1.7;
    
    CAEmitterCell *fireworkCell = [CAEmitterCell emitterCell];
    
    NSImage* someImage3 = [NSImage imageWithName:@"spark"];
    CGImageSourceRef source3 = CGImageSourceCreateWithData((CFDataRef)[someImage3 TIFFRepresentation], NULL);
    CGImageRef maskRef3 =  CGImageSourceCreateImageAtIndex(source3, 0, NULL);
    
    fireworkCell.contents = (__bridge id _Nullable)(maskRef3);
    fireworkCell.birthRate = 600;
    fireworkCell.scale = 0.6;
    fireworkCell.velocity = 130;
    fireworkCell.lifetime = 100;
    fireworkCell.alphaSpeed = -0.2;
    fireworkCell.yAcceleration = -80;
    fireworkCell.beginTime = 1.5;
    fireworkCell.duration = 0.1;
    fireworkCell.emissionRange = 2 * M_PI;
    fireworkCell.scaleSpeed = -0.1;
    fireworkCell.spin = 2;
    
    emitterCell.emitterCells = @[flareCell,fireworkCell];
    self.sparkEmitterLayer.emitterCells = @[emitterCell];
}

- (void)starAnimation:(BOOL)animation {
    NSLog(@"%d", animation);
    if (!animation) {
        if ([self.emitter superlayer]) {
            [self.emitter removeFromSuperlayer];
        }
        if (self.starEmitterLayer) {
            [self.starEmitterLayer removeFromSuperlayer];
        }
        return;
    }
    if ([self.emitter superlayer]) {
        return;
    }
    
    [self setWantsLayer:YES];
    
    [self.layer addSublayer:self.emitter];
    [self.layer addSublayer:self.starEmitterLayer];
    
    self.emitter.emitterCells = @[self.particleCell];
    
    // 星星粒子
    CAEmitterCell *starCell = [CAEmitterCell emitterCell];
    starCell.birthRate = 6;
    starCell.lifetime = 1.02;
    
    CAEmitterCell *starCell1 = [CAEmitterCell emitterCell];
    starCell1.birthRate = 4.5;
    starCell1.lifetime = 1.02;
    starCell1.velocity = 0;
    starCell1.emissionRange = 2*M_PI;    // 发射角度范围
    
    
    NSImage* someImage1 = [NSImage imageWithName:@"bgAnimationStar1"];
    CGImageSourceRef source1 = CGImageSourceCreateWithData((CFDataRef)[someImage1 TIFFRepresentation], NULL);
    CGImageRef maskRef1 =  CGImageSourceCreateImageAtIndex(source1, 0, NULL);
    
    starCell1.contents = (__bridge id _Nullable)(maskRef1);
    starCell1.color = [[NSColor colorWithRed:1 green:1 blue:1 alpha:0] CGColor];
    starCell1.alphaSpeed = 0.6;
    starCell1.scale = 0.4;
    [starCell1 setName:@"star"];
    
    CAEmitterCell *starCell2 = [CAEmitterCell emitterCell];
    starCell2.birthRate = 4.5;
    starCell2.lifetime = 1.02;
    starCell2.velocity = 0;
    starCell2.emissionRange = 2*M_PI;    // 发射角度范围
    
    CAEmitterCell *starCell3 = [CAEmitterCell emitterCell];
    starCell3.birthRate = 4.5;
    starCell3.lifetime = 1;
    starCell3.velocity = 0;
    starCell3.emissionRange = 2*M_PI;    // 发射角度范围
    
    NSImage* someImage2 = [NSImage imageWithName:@"bgAnimationStar"];
    CGImageSourceRef source2 = CGImageSourceCreateWithData((CFDataRef)[someImage2 TIFFRepresentation], NULL);
    CGImageRef maskRef2 =  CGImageSourceCreateImageAtIndex(source2, 0, NULL);
    
    starCell3.contents = (__bridge id _Nullable)(maskRef2);
    starCell3.color = [NSColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    starCell3.alphaSpeed = -0.5;
    starCell3.scale = starCell1.scale;
    
    self.starEmitterLayer.emitterCells = @[starCell];
    starCell.emitterCells = @[starCell1, starCell2];
    starCell1.emitterCells = @[starCell3];
    
    [self didMoveToWindow];
}


- (void)didMoveToWindow
{
    if (self.emitterTimer != nil) {
        [self.emitterTimer invalidate];
        self.emitterTimer = nil;
    }else if (self.emitterTimer == nil) {
        self.emitterTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(randomizeEmitterPosition) userInfo:nil repeats:YES];
    }
}

- (void)randomizeEmitterPosition {
    CGFloat sizeWidth = MAX(self.bounds.size.width, self.bounds.size.height);
    CGFloat radius = fmodf((float)arc4random(), sizeWidth);
    self.emitter.emitterSize = CGSizeMake(radius, radius);
    self.particleCell.birthRate = 10 + sqrt(radius);
}

#pragma mark- lazy

- (CAEmitterLayer *)sparkEmitterLayer {
    if (!_sparkEmitterLayer) {
        _sparkEmitterLayer = [CAEmitterLayer layer];
        _sparkEmitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2, 0);    // 坐标
        _sparkEmitterLayer.emitterSize = CGSizeMake(self.bounds.size.width, 0);               // 粒子大小
        _sparkEmitterLayer.renderMode = kCAEmitterLayerAdditive;      // 递增渲染模式
        _sparkEmitterLayer.emitterMode = kCAEmitterLayerOutline;      // 粒子发射模式（向线外发射）
        _sparkEmitterLayer.emitterShape = kCAEmitterLayerLine;        // 粒子形状（线）
        _sparkEmitterLayer.seed = (arc4random()%100) + 1;
    }
    return _sparkEmitterLayer;
}

- (CAEmitterLayer *)starEmitterLayer {
    if (!_starEmitterLayer) {
        _starEmitterLayer = [CAEmitterLayer layer];
        _starEmitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);    // 坐标
        _starEmitterLayer.emitterSize = self.bounds.size;            // 粒子大小
        _starEmitterLayer.renderMode = kCAEmitterLayerOldestLast;     // 递增渲染模式
        _starEmitterLayer.emitterMode = kCAEmitterLayerSurface;      // 粒子发射模式（面发射）
        _starEmitterLayer.emitterShape = kCAEmitterLayerSphere;      // 粒子形状（球状）
        _starEmitterLayer.seed = (arc4random()%100)+1;   // 用于初始化随机数产生的种子
    }
    return _starEmitterLayer;
}

- (CAEmitterLayer *)emitter {
    if (!_emitter) {
        _emitter = [CAEmitterLayer layer];
        _emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);    // 坐标
        _emitter.emitterSize = self.bounds.size;            // 粒子大小
        _emitter.renderMode = kCAEmitterLayerOldestLast;     // 递增渲染模式
        _emitter.emitterMode = kCAEmitterLayerSurface;      // 粒子发射模式（面发射）
        _emitter.emitterShape = kCAEmitterLayerSphere;      // 粒子形状（球状）
        _emitter.seed = (arc4random()%100)+1;   // 用于初始化随机数产生的种子
        _emitter.frame = self.bounds;
    }
    return _emitter;
}

- (CAEmitterCell *)particleCell {
    if (!_particleCell) {
        _particleCell = [CAEmitterCell emitterCell];
        
        NSImage* someImage = [NSImage imageWithName:@"star"];
        CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[someImage TIFFRepresentation], NULL);
        CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
        
        _particleCell.contents = (__bridge id _Nullable)(maskRef);
        _particleCell.birthRate = 10;
        _particleCell.lifetime = 10;
        _particleCell.lifetimeRange = 5;
        _particleCell.velocity = 20;
        _particleCell.velocityRange = 10;
        _particleCell.scale = 0.5;
        _particleCell.scaleRange = 1.0;
        _particleCell.scaleSpeed = 0.02;
    }
    return _particleCell;
}

@end
