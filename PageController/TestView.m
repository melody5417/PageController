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
@property (nonatomic, strong) AutoSizingImageView *imageView;
@end

@implementation TestView

- (instancetype)init {
    if (self = [super init]) {
        NSView *contentView = [[NSView alloc] initWithFrame:NSZeroRect];
        [self setView:contentView];

        self.imageView = [[AutoSizingImageView alloc] initWithFrame:self.view.bounds];
        self.imageView.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
        [self.view addSubview:self.imageView];
    }
    return self;
}


- (void)setImage:(NSImage *)image {
    if (image) {
        [self.imageView setImage:image];
    }
}

@end
