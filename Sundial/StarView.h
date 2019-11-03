//
//  StarView.h
//  Sundial
//
//  Created by xinyue on 2019/4/10.
//  Copyright © 2019 wangweicheng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface StarView : NSView
/// 烟火动画
- (void)sparkAnimation:(BOOL)animation;
/// 星星动画
- (void)starAnimation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
