//
//  ActiveViewController.h
//  TradeApp
//
//  Created by Helen Yang on 12-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface ActiveViewController : PullRefreshTableViewController

@property (strong, nonatomic) NSMutableArray *data;

@end
