//
//  Configuration.h
//  Sundial
//
//  Created by xinyue on 2019/4/4.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, AnimationType) {
    AnimationTypeNone = 0,
    AnimationTypeStar = 1 << 0,
    AnimationTypeSpark = 1 << 1
};

NS_ASSUME_NONNULL_BEGIN

@class NSColor;

@interface Configuration : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSString *fontFamily;

@property (nonatomic, strong) NSColor *tintColor;

@property (nonatomic, strong, readonly) NSArray<NSColor *> *colorSet;

@property (nonatomic, assign) AnimationType type;

@end

NS_ASSUME_NONNULL_END

