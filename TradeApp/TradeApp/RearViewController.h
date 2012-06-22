//
//  RearViewControllerViewController.h
//  TradeApp
//
//  Created by Helen on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RearViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *states;

@end
