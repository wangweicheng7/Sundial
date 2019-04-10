//
//  ViewController.m
//  Example
//
//  Created by wangweicheng on 2017/11/14.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import "ViewController.h"
#import "Sundial.h"

@interface ViewController()

@property (nonatomic, strong) Sundial *Sundial;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGRect frame = CGRectMake(self.view.bounds.size.width - self.view.bounds.size.height/2, 0, self.view.bounds.size.height, self.view.bounds.size.height);
//    self.Sundial = [[Sundial alloc] initWithFrame:frame isPreview:YES];
    self.Sundial = [[Sundial alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height - 30) isPreview:YES];
    [self.Sundial setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
    [self.view addSubview:self.Sundial];
    [self.Sundial startAnimation];
    
    [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.Sundial animateOneFrame];
    }];
    
}

- (void)viewDidAppear {
    [super viewDidAppear];
}
- (IBAction)buttonClicked:(id)sender {
    
    NSWindow *preference = [self.Sundial configureSheet];
    [[NSApplication sharedApplication].keyWindow beginSheet:preference completionHandler:nil];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
