//
//  CollapsableTableViewViewController.h
//  TradeApp
//
//  Created by Helen Yang on 12-08-17.
//
//

#import <UIKit/UIKit.h>
#import "CollapsableTableView.h"

@interface CollapsableTableViewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *collapsableTableView;

- (IBAction)toggleSection2:(id)sender;

@end
