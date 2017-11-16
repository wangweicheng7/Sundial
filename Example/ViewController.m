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
    
    self.Sundial = [[Sundial alloc] initWithFrame:self.view.bounds isPreview:YES];
    [self.Sundial setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
    [self.view addSubview:self.Sundial];
    [self.Sundial startAnimation];
    
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
