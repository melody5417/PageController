//
//  ViewController.m
//  PageController
//
//  Created by yiqiwang(王一棋) on 2017/6/2.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"

@interface ViewController () <NSPageControllerDelegate>
@property (nonatomic, strong) NSPageController *pageController;
@property (strong) NSMutableArray *data;
@property (assign) id initialSelectedObject;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    self.pageController = [[NSPageController alloc] init];
    [self.pageController setView:[[NSView alloc] initWithFrame:self.view.bounds]];
    [self.view addSubview:self.pageController.view];
    [self.pageController setDelegate:self];
    self.pageController.transitionStyle = NSPageControllerTransitionStyleHorizontalStrip;
//    self.pageController.transitionStyle = NSPageControllerTransitionStyleStackHistory;
//    self.pageController.transitionStyle = NSPageControllerTransitionStyleStackBook;

    NSURL *dirURL = [[NSBundle mainBundle] resourceURL];

    // load all the necessary image files by enumerating through the bundle's Resources folder,
    // this will only load images of type "kUTTypeImage"
    //
    self.data = [[NSMutableArray alloc] initWithCapacity:1];

    NSDirectoryEnumerator *itr = [[NSFileManager defaultManager] enumeratorAtURL:dirURL includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLLocalizedNameKey, NSURLEffectiveIconKey, NSURLIsDirectoryKey, NSURLTypeIdentifierKey, nil] options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];

    for (NSURL *url in itr) {
        NSString *utiValue;
        [url getResourceValue:&utiValue forKey:NSURLTypeIdentifierKey error:nil];

        if (UTTypeConformsTo((__bridge CFStringRef)(utiValue), kUTTypeImage)) {
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
            [self.data addObject:image];
        }
    }

    // set the first image in our list to the main magnifying view
    if ([self.data count] > 0) {
        [self.pageController setArrangedObjects:self.data];
    }

}


- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object {
    if ([self.data indexOfObject:object]%2 == 1) {
        return @"pic";
    }
    return @"picture1";
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"pic"]) {
        return [[TestView alloc] init];
    } else {
        return [[NSViewController alloc] initWithNibName:@"imageview" bundle:nil];
    }

}

-(void)pageController:(NSPageController *)pageController prepareViewController:(NSViewController *)viewController withObject:(id)object {
    // viewControllers may be reused... make sure to reset important stuff like the current magnification factor.

    // Normally, we want to reset the magnification value to 1 as the user swipes to other images. However if the user cancels the swipe, we want to leave the original magnificaiton and scroll position alone.
    if ([viewController isKindOfClass:[TestView class]]) {
        [(TestView *)viewController setImage:object];
        return ;
    }

    BOOL isRepreparingOriginalView = (self.initialSelectedObject && self.initialSelectedObject == object) ? YES : NO;
    if (!isRepreparingOriginalView) {
        [(NSScrollView*)viewController.view setMagnification:1.0];
    }

    // Since we implement this delegate method, we are reponsible for setting the representedObject.
    viewController.representedObject = object;
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController {
    // Remember the initial selected object so we can determine when a cancel occurred.
    self.initialSelectedObject = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
    [pageController completeTransition];
}


@end
