//
//  ViewController.m
//  Example
//
//  Created by wangweicheng on 2017/11/14.
//  Copyright © 2017年 wangweicheng. All rights reserved.
//

#import "ViewController.h"
#import "Clock.h"

@interface ViewController()

@property (nonatomic, strong) Clock *clock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clock = [[Clock alloc] initWithFrame:self.view.bounds isPreview:YES];
    [self.clock setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
    [self.view addSubview:self.clock];
    [self.clock startAnimation];
    
}

- (void)viewDidAppear {
    [super viewDidAppear];
}
- (IBAction)buttonClicked:(id)sender {
    
   
//    [textField.layer addAnimation:anim forKey:nil];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
