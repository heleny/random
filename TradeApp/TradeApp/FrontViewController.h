//
//  FrontViewController.h
//  TradeApp
//
//  Created by Helen on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"

@interface FrontViewController : UIViewController

@property (strong, nonatomic) NSArray *activeList;
@property (strong, nonatomic) NSArray *closingList;
@property (strong, nonatomic) NSArray *wonList;
@property (strong, nonatomic) NSArray *lostList;
@property (strong, nonatomic) NSArray *arrivedList;
@property (strong, nonatomic) NSArray *deliveredList;

- (IBAction)pushExample:(id)sender;

@end
