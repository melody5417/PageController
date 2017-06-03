//
//  TestView.m
//  PageController
//
//  Created by yiqiwang(王一棋) on 2017/6/3.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "TestView.h"
#import "AutoSizingImageView.h"

@interface TestView ()
@property (weak) IBOutlet AutoSizingImageView *imageView;

@end

@implementation TestView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)setImage:(NSImage *)image {
    if (image) {
        [self.imageView setImage:image];
    }
}

@end
