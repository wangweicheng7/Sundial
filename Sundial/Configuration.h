//
//  Configuration.h
//  Sundial
//
//  Created by xinyue on 2019/4/4.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NSColor;

@interface Configuration : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSString *fontFamily;

@property (nonatomic, strong) NSColor *tintColor;

@property (nonatomic, strong, readonly) NSArray<NSColor *> *colorSet;

@end

NS_ASSUME_NONNULL_END

