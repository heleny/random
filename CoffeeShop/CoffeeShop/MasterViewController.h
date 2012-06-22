//
//  MasterViewController.h
//  CoffeeShop
//
//  Created by Helen on 12-06-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface MasterViewController : UITableViewController <RKObjectLoaderDelegate>

@property (strong, nonatomic) NSArray *data;

- (void) sendRequest;

@end
