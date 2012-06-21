//
//  com_restkit_sampleModelController.h
//  RestKitSampleApp
//
//  Created by Helen on 12-06-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class com_restkit_sampleDataViewController;

@interface com_restkit_sampleModelController : NSObject <UIPageViewControllerDataSource>

- (com_restkit_sampleDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(com_restkit_sampleDataViewController *)viewController;

@end
